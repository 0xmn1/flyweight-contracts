// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./TokenWhitelist.sol";

contract Flyweight {
    address constant public UNISWAP_ROUTER_ADDRESS = 0xE592427A0AEce92De3Edee1F18E0157C05861564;

    struct Order {
        uint id;
        address owner;
        OrderState orderState;
        string tokenIn;
        string tokenOut;
        string tokenInTriggerPrice;
        OrderTriggerDirection direction;
        uint tokenInAmount;
    }
    struct NewPriceItem {
        string symbol;
        string price;
    }

    event PriceUpdated (
        uint timestamp,
        string symbol,
        string oldPrice,
        string newPrice
    );

    event OrderTriggered (
        uint orderId
    );

    event OrderExecuted (
        uint orderId
    );

    enum OrderState { UNTRIGGERED, EXECUTED }
    enum OrderTriggerDirection { BELOW, EQUAL, ABOVE }

    uint public ordersCount;
    mapping(uint => Order) public orders;
    mapping(string => string) public prices;
    TokenWhitelist public immutable tokenWhitelist;

    constructor() {
        tokenWhitelist = new TokenWhitelist(block.chainid);
    }

    function getWhitelistedSymbols(string[] calldata symbols) external view returns(string[] memory) {
        string[] memory whitelist = new string[](symbols.length);
        uint whitelistCount = 0;
        for (uint i = 0; i < symbols.length; i++) {
            string calldata symbol = symbols[i];
            bool isWhitelisted = tokenWhitelist.addresses(symbol) != address(0);
            if (isWhitelisted) {
                whitelist[whitelistCount] = symbol;
                whitelistCount++;
            }
        }

        string[] memory trimmedWhitelist = new string[](whitelistCount);
        for (uint i = 0; i < whitelistCount; i++) {
            trimmedWhitelist[i] = whitelist[i];
        }

        return trimmedWhitelist;
    }

    function tryGetTokenAddress(string calldata symbol) external view returns(address) {
        return tokenWhitelist.addresses(symbol);
    }

    function addNewOrder(string calldata tokenIn, string calldata tokenOut, string calldata tokenInTriggerPrice, OrderTriggerDirection direction, uint tokenInAmount) external returns(uint) {
        uint id = ordersCount;
        orders[id] = Order({
            id: id,
            owner: msg.sender,
            orderState: OrderState.UNTRIGGERED,
            tokenIn: tokenIn,
            tokenOut: tokenOut,
            tokenInTriggerPrice: tokenInTriggerPrice,
            direction: direction,
            tokenInAmount: tokenInAmount
        });

        ordersCount++;
        return id;
    }

    function storePricesAndProcessTriggeredOrderIds(NewPriceItem[] calldata newPriceItems, uint[] calldata newTriggeredOrderIds) external {
        for (uint i = 0; i < newPriceItems.length; i++) {
            NewPriceItem memory item = newPriceItems[i];
            string memory oldPrice = prices[item.symbol];
            prices[item.symbol] = item.price;

            emit PriceUpdated({
                timestamp: block.timestamp,
                symbol: item.symbol,
                oldPrice: oldPrice,
                newPrice: item.price
            });
        }

        for (uint i = 0; i < newTriggeredOrderIds.length; i++) {
            uint orderId = newTriggeredOrderIds[i];
            emit OrderTriggered({
                orderId: orderId
            });
            
            executeOrderId(orderId);
            emit OrderExecuted({
                orderId: orderId
            });
        }
    }

    function executeOrderId(uint orderId) private {
        Order storage order = orders[orderId];
        address tokenInAddress = tokenWhitelist.addresses(order.tokenIn);
        address tokenOutAddress = tokenWhitelist.addresses(order.tokenOut);
        uint balance = IERC20(tokenInAddress).balanceOf(address(this));
        require(balance >= order.tokenInAmount);

        address[2] memory path = [tokenInAddress, tokenOutAddress];
        uint tokenOutMinQuote = 0;  // todo: when front-end is made, it should allow user-defined max slippage

        ISwapRouter swapRouter = ISwapRouter(UNISWAP_ROUTER_ADDRESS);
        ISwapRouter.ExactInputSingleParams memory swapParams = ISwapRouter.ExactInputSingleParams({
            tokenIn: path[0],
            tokenOut: path[1],
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
}
