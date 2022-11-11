// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import '@uniswap/v2-periphery/contracts/UniswapV2Router02.sol';
import '@uniswap/v2-periphery/contracts/interfaces/IERC20.sol';

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
    struct Price {
        string token0;
        string token1;
        string price;
        string unixTimestamp;
    }

    enum OrderState { UNTRIGGERED, TRIGGERED, EXECUTED }
    enum OrderTriggerDirection { BELOW, EQUAL, ABOVE }

    uint public ordersCount;
    uint public pricesCount;
    mapping(uint => Order) public orders;
    mapping(uint => Price) public prices;

    mapping(string => address) public tokenAddresses;

    // TODO: solidity constructor to approve UNISWAP spending via IERC20
    constructor() {
        tokenAddresses["UNI"] = "0x1f9840a85d5af5bf1d1762f925bdaddc4201f984";
        tokenAddresses["WETH"] = "0xb4fbf271143f4fbf7b91a5ded31805e42b2208d6";
    }

    function addNewOrder(string calldata tokenIn, string calldata tokenOut, string calldata tokenInTriggerPrice, OrderTriggerDirection direction, uint tokenInAmount) external returns(uint) {
        uint id = ordersCount;
        orders[id] = Order({
            id: id,
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

    function storePricesAndProcessTriggeredOrderIds(Price[] calldata newPrices, uint[] calldata newTriggeredOrderIds) external {
        for (uint i = 0; i < newPrices.length; i++) {
            prices[pricesCount] = newPrices[i];
            pricesCount++;
        }

        for (uint i = 0; i < newTriggeredOrderIds.length; i++) {
            uint orderId = newTriggeredOrderIds[i];
            orders[orderId].orderState = OrderState.TRIGGERED;
        }
    }

    function processTriggeredOrderIds(uint[] calldata newTriggeredOrderIds) private {
        for (uint i = 0; i < newTriggeredOrderIds.length; i++) {
            uint orderId = newTriggeredOrderIds[i];
            Order order = orders[orderId];
            address[] path = [tokenAddresses[order.tokenIn], tokenAddresses[order.tokenOut]];
            uint tokenOutMinQuote = 0;  // todo: when front-end is made, it should allow user-defined max slippage
            UniswapV2Router02.swapExactTokensForTokens(order.tokenInAmount, tokenOutMinQuote, path, order.owner, block.timestamp);

            order.orderState = OrderState.EXECUTED;
        }
    }
}
