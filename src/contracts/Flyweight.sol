// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./TokenWhitelist.sol";
import "./types/FlyweightTypes.sol";
import {FlyweightEvents} from "./libraries/FlyweightEvents.sol";

/**
 * @title Flyweight
 * Holds/manages order data
 */
contract Flyweight {
  /// @dev These are public to maximise contract transparency with users
  address public immutable uniswapRouterAddress;
  address public immutable oracleNodeAddress;
  TokenWhitelist public immutable tokenWhitelist;
  uint public ordersCount;
  mapping(uint => Order) public orders;
  mapping(address => uint[]) public orderIdsByAddress;
  mapping(string => string) public prices;
  mapping(uint => bytes32) public depositTxns;

  constructor(
    address _uniswapRouterAddress,
    address _oracleNodeAddress,
    string[] memory tokenSymbols,
    address[] memory tokenAddresses
  ) {
    uniswapRouterAddress = _uniswapRouterAddress;
    oracleNodeAddress = _oracleNodeAddress;
    ordersCount = 0;
    tokenWhitelist = new TokenWhitelist(
      _uniswapRouterAddress,
      tokenSymbols,
      tokenAddresses
    );

    for (uint i = 0; i < tokenSymbols.length; i++) {
      /// @dev Approvals to automatically send erc20's upon swap execution, back to order owner address
      IERC20(tokenAddresses[i]).approve(uniswapRouterAddress, type(uint).max);
    }
  }

  /**
   * @dev Whitelisted token symbols are stored immutably in contract state during contract creation
   * @return Token symbols supported on the Flyweight platform
   */
  function getWhitelistedSymbols() external view returns (string[] memory) {
    return tokenWhitelist.getSymbols();
  }

  /// @return address(0) if the token is not supported on the Flyweight platform
  function tryGetTokenAddress(
    string calldata symbol
  ) external view returns (address) {
    return tokenWhitelist.addresses(symbol);
  }

  /**
   * Adds a new order to the contract storage
   * @param tokenIn The token to swap from. This will be the token the EOA has to deposit into the contract
   * @param tokenOut The token to swap to. This will be the token sent to the order owner's address after swap execution
   */
  function addNewOrder(
    string calldata tokenIn,
    string calldata tokenOut,
    string calldata tokenInTriggerPrice,
    OrderTriggerDirection direction,
    uint tokenInAmount
  ) external onlyEoa returns (uint) {
    // Only allow 1 pending order per user
    uint[] storage orderIds = orderIdsByAddress[msg.sender];
    if (orderIds.length > 0) {
      uint lastOrderId = orderIds[orderIds.length - 1];
      require(orders[lastOrderId].orderState != OrderState.PENDING_DEPOSIT);
    }

    uint id = ordersCount;
    orders[id] = Order({
      id: id,
      owner: msg.sender,
      orderState: OrderState.PENDING_DEPOSIT,
      tokenIn: tokenIn,
      tokenOut: tokenOut,
      tokenInTriggerPrice: tokenInTriggerPrice,
      direction: direction,
      tokenInAmount: tokenInAmount,
      blockNumber: block.number
    });

    orderIdsByAddress[msg.sender].push(id);
    ordersCount++;
    return id;
  }

  /**
   * Updates latest token prices (retrieved via the Flyweight oracle) & then proceeds to execute swaps for triggered orders
   * @param newPriceItems Latest token prices
   * @param newTriggeredOrderIds Latest order id's to trigger
   */
  function storePricesAndProcessTriggeredOrderIds(
    NewPriceItem[] calldata newPriceItems,
    uint[] calldata newTriggeredOrderIds
  ) external onlyEoa onlyValidOracle {
    // Update prices
    for (uint i = 0; i < newPriceItems.length; i++) {
      NewPriceItem memory item = newPriceItems[i];
      string memory oldPrice = prices[item.symbol];
      prices[item.symbol] = item.price;

      emit FlyweightEvents.PriceUpdated({
        timestamp: block.timestamp,
        symbol: item.symbol,
        oldPrice: oldPrice,
        newPrice: item.price
      });
    }

    // Trigger orders
    for (uint i = 0; i < newTriggeredOrderIds.length; i++) {
      uint orderId = newTriggeredOrderIds[i];
      emit FlyweightEvents.OrderTriggered({orderId: orderId});

      executeOrderId(orderId);
      emit FlyweightEvents.OrderExecuted({orderId: orderId});
    }
  }

  /// Executes the swap for an order & sends the resulting tokens to the order owner's address
  function executeOrderId(uint orderId) private {
    Order storage order = orders[orderId];
    assert(order.orderState == OrderState.UNTRIGGERED);

    address tokenInAddress = tokenWhitelist.addresses(order.tokenIn);
    address tokenOutAddress = tokenWhitelist.addresses(order.tokenOut);
    uint balance = IERC20(tokenInAddress).balanceOf(address(this));
    require(balance >= order.tokenInAmount);

    address[2] memory path = [tokenInAddress, tokenOutAddress];
    uint tokenOutMinQuote = 0; // todo: front-end feature request - add UI slider bar to allow user to set preferred slippage

    ISwapRouter swapRouter = ISwapRouter(uniswapRouterAddress);
    ISwapRouter.ExactInputSingleParams memory swapParams = ISwapRouter
      .ExactInputSingleParams({
        tokenIn: path[0],
        tokenOut: path[1],
        /**
         * "fee" is the uniswap LP pool "fee tier", not the "swap fee".
         * The swap fees are paid from the Flyweight treasury, not the user/EOA.
         * Flyweight does not take "cuts" from swaps and passes the savings onto the users.
         */
        fee: 3000,
        recipient: order.owner,
        deadline: block.timestamp,
        amountIn: order.tokenInAmount,
        amountOutMinimum: tokenOutMinQuote,
        sqrtPriceLimitX96: 0
      });

    swapRouter.exactInputSingle(swapParams);
    order.orderState = OrderState.EXECUTED;
  }

  function getOrdersByAddress(
    address addr
  ) external view returns (Order[] memory) {
    uint[] storage orderIds = orderIdsByAddress[addr];
    Order[] memory ordersForAddress = new Order[](orderIds.length);
    for (uint i = 0; i < orderIds.length; i++) {
      uint orderId = orderIds[i];
      ordersForAddress[i] = orders[orderId];
    }

    return ordersForAddress;
  }

  function cancelOrder(uint orderId) external onlyEoa {
    emit FlyweightEvents.OrderCancelRequested({
      orderId: orderId,
      sender: msg.sender
    });

    Order storage order = orders[orderId];
    assert(msg.sender == order.owner);
    require(
      order.orderState == OrderState.PENDING_DEPOSIT ||
        order.orderState == OrderState.UNTRIGGERED
    );

    /// @dev Only refund deposit if user sent it to the contract
    if (order.orderState == OrderState.UNTRIGGERED) {
      address tokenInAddress = tokenWhitelist.addresses(order.tokenIn);
      IERC20(tokenInAddress).transfer(order.owner, order.tokenInAmount);
    }

    order.orderState = OrderState.CANCELLED;
    emit FlyweightEvents.OrderCancelled({
      orderId: order.id,
      tokenInAmount: order.tokenInAmount,
      tokenIn: order.tokenIn,
      owner: order.owner,
      blockNumber: block.number,
      blockTimestamp: block.timestamp
    });
  }

  /// Stores data that links on-chain transactions to Flyweight order deposits
  function storeDepositTransactionsAndUpdateOrderStates(
    NewDepositTx[] calldata txns
  ) external onlyEoa onlyValidOracle {
    for (uint i = 0; i < txns.length; i++) {
      NewDepositTx calldata newDepositTx = txns[i];
      depositTxns[newDepositTx.orderId] = newDepositTx.txHash;

      Order storage order = orders[newDepositTx.orderId];
      if (order.orderState == OrderState.PENDING_DEPOSIT) {
        orders[newDepositTx.orderId].orderState = OrderState.UNTRIGGERED;
      }
    }
  }

  function getPendingDepositOrders() external view returns (Order[] memory) {
    Order[] memory pendingDepositOrders = new Order[](ordersCount);
    uint pendingDepositOrdersCount = 0;
    for (uint i = 0; i < ordersCount; i++) {
      if (orders[i].orderState == OrderState.PENDING_DEPOSIT) {
        pendingDepositOrders[pendingDepositOrdersCount] = orders[i];
        pendingDepositOrdersCount++;
      }
    }

    return pendingDepositOrders;
  }

  modifier onlyValidOracle() {
    assert(msg.sender == oracleNodeAddress);
    _;
  }

  modifier onlyEoa() {
    assert(msg.sender == tx.origin);
    _;
  }
}
