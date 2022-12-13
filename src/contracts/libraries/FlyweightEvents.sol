// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title FlyweightEvents
library FlyweightEvents {
  /**
   * Records token prices that are updated in the contract
   * @dev Prices obtained from Flyweight oracle
   */
  event PriceUpdated(
    uint timestamp,
    string symbol,
    string oldPrice,
    string newPrice
  );

  /**
   * Records when an order is triggered.
   * @dev This event happens after the Flyweight oracle calculating that an order's swap should be executed, & before the actual on-chain swap occurring.
   */
  event OrderTriggered(uint orderId);

  /**
   * Records when an order is executed.
   * @dev This event happens after the on-chain swap is executed.
   */
  event OrderExecuted(uint orderId);

  /**
   * Records when an order cancelled is requested.
   * @dev This event happens after the EOA calls the cancel contract method, & before the order state is updated in the contract data.
   */
  event OrderCancelRequested(uint orderId, address sender);

  /**
   * Records when an order is cancelled.
   * @dev This event happens after the data is updated in the smart contract.
   */
  event OrderCancelled(
    uint orderId,
    uint tokenInAmount,
    string tokenIn,
    address owner,
    uint blockNumber,
    uint blockTimestamp
  );
}
