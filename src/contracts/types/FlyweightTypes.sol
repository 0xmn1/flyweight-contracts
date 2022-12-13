// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * Represents the various states during an order's lifecycle.
 * @dev Untriggered = EOA has deposited erc20 into the flyweight contract & is ready to swap
 * @dev Pending deposit = EOA has created the order without a deposit yet.
 * @dev Executed = Swap has executed and resulting erc20 has been sent to order owner
 * @dev Cancelled = EOA has cancelled the order and the deposited erc20 (if any) has been returned to them
 */
enum OrderState {
  UNTRIGGERED,
  PENDING_DEPOSIT,
  EXECUTED,
  CANCELLED
}

/// Price direction for an orders' trigger condition
enum OrderTriggerDirection {
  BELOW,
  EQUAL,
  ABOVE
}

/// An EOA order
struct Order {
  uint id;
  address owner;
  OrderState orderState;
  string tokenIn;
  string tokenOut;
  string tokenInTriggerPrice;
  OrderTriggerDirection direction;
  uint tokenInAmount;
  uint blockNumber;
}

/// Represents a token price fetched from the Flyweight oracle
struct NewPriceItem {
  string symbol;
  string price;
}

/**
 * Represents an EOA order deposit
 * @dev This is an on-chain erc20 transaction from the EOA to the Flyweight smart contract
 */
struct NewDepositTx {
  uint orderId;
  bytes32 txHash;
}
