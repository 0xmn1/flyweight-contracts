// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract Flyweight {
    struct Order {
        OrderState orderState;
        string tokenIn;
        string tokenOut;
        string tokenInTriggerPrice;
        string tokenOutTriggerPrice;
        uint tokenInAmount;
    }
    struct Price {
        string token0;
        string token1;
        string unixTimestamp;
        string price;
    }

    event GetNewOrderResults ();

    enum OrderState { UNTRIGGERED, TRIGGERED, EXECUTED }

    uint public OrdersCount;
    uint public PricesCount;
    mapping(uint => Order) public orders;
    mapping(uint => Price) public prices;

    function storePriceAndGetNewOrderResults(string calldata token0, string calldata token1, string calldata unixTimestamp, string calldata price) external {
        storePrice(token0, token1, unixTimestamp, price);
        emit GetNewOrderResults();
    }

    function storePrice(string calldata token0, string calldata token1, string calldata unixTimestamp, string calldata price) private {
        prices[PricesCount] = Price({
            token0: token0,
            token1: token1,
            unixTimestamp: unixTimestamp,
            price: price
        });

        PricesCount++;
    }

    function storeAndProcessOrderResults(uint[] calldata triggeredOrderIds) external {
        storeOrderResults(triggeredOrderIds);
        processOrderResults(triggeredOrderIds);
    }

    function storeOrderResults(uint[] calldata triggeredOrderIds) private {
        for (uint i = 0; i < triggeredOrderIds.length; i++) {
            uint orderId = triggeredOrderIds[i];
            orders[orderId].orderState = OrderState.TRIGGERED;
        }
    }

    function processOrderResults(uint[] calldata triggeredOrderIds) private {
        // todo uniswap
    }
}
