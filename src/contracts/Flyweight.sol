// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Flyweight {
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
    mapping(string => address) public tokenAddresses;

    constructor() {
        tokenAddresses["UNI"] = 0x1f9840a85d5aF5bf1D1762F925BDADdC4201F984;
        tokenAddresses["WETH"] = 0xB4FBF271143F4FBf7B91A5ded31805e42b2208d6;

        address uniswapRouterAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
        IERC20 uni = IERC20(tokenAddresses["UNI"]);
        IERC20 weth = IERC20(tokenAddresses["WETH"]);
        uni.approve(uniswapRouterAddress, type(uint).max);
        weth.approve(uniswapRouterAddress, type(uint).max);
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
        uint balance = IERC20(address(tokenAddresses[order.tokenIn])).balanceOf(address(this));
        require(balance >= order.tokenInAmount);

        address[2] memory path = [tokenAddresses[order.tokenIn], tokenAddresses[order.tokenOut]];
        uint tokenOutMinQuote = 0;  // todo: when front-end is made, it should allow user-defined max slippage

        address uniswapRouterAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
        ISwapRouter swapRouter = ISwapRouter(uniswapRouterAddress);
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
