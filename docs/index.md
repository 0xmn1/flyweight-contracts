# Solidity API

## Flyweight

### uniswapRouterAddress

```solidity
address uniswapRouterAddress
```

_These are public to maximise contract transparency with users_

### oracleNodeAddress

```solidity
address oracleNodeAddress
```

### tokenWhitelist

```solidity
contract TokenWhitelist tokenWhitelist
```

### ordersCount

```solidity
uint256 ordersCount
```

### orders

```solidity
mapping(uint256 => struct Order) orders
```

### orderIdsByAddress

```solidity
mapping(address => uint256[]) orderIdsByAddress
```

### prices

```solidity
mapping(string => string) prices
```

### depositTxns

```solidity
mapping(uint256 => bytes32) depositTxns
```

### constructor

```solidity
constructor(address _uniswapRouterAddress, address _oracleNodeAddress, string[] tokenSymbols, address[] tokenAddresses) public
```

### getWhitelistedSymbols

```solidity
function getWhitelistedSymbols() external view returns (string[])
```

_Whitelisted token symbols are stored immutably in contract state during contract creation_

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | string[] | Token symbols supported on the Flyweight platform |

### tryGetTokenAddress

```solidity
function tryGetTokenAddress(string symbol) external view returns (address)
```

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | address | address(0) if the token is not supported on the Flyweight platform |

### addNewOrder

```solidity
function addNewOrder(string tokenIn, string tokenOut, string tokenInTriggerPrice, enum OrderTriggerDirection direction, uint256 tokenInAmount) external returns (uint256)
```

Adds a new order to the contract storage

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| tokenIn | string | The token to swap from. This will be the token the EOA has to deposit into the contract |
| tokenOut | string | The token to swap to. This will be the token sent to the order owner's address after swap execution |
| tokenInTriggerPrice | string |  |
| direction | enum OrderTriggerDirection |  |
| tokenInAmount | uint256 |  |

### storePricesAndProcessTriggeredOrderIds

```solidity
function storePricesAndProcessTriggeredOrderIds(struct NewPriceItem[] newPriceItems, uint256[] newTriggeredOrderIds) external
```

Updates latest token prices (retrieved via the Flyweight oracle) & then proceeds to execute swaps for triggered orders

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| newPriceItems | struct NewPriceItem[] | Latest token prices |
| newTriggeredOrderIds | uint256[] | Latest order id's to trigger |

### executeOrderId

```solidity
function executeOrderId(uint256 orderId) private
```

Executes the swap for an order & sends the resulting tokens to the order owner's address

### getOrdersByAddress

```solidity
function getOrdersByAddress(address addr) external view returns (struct Order[])
```

### cancelOrder

```solidity
function cancelOrder(uint256 orderId) external
```

### storeDepositTransactionsAndUpdateOrderStates

```solidity
function storeDepositTransactionsAndUpdateOrderStates(struct NewDepositTx[] txns) external
```

Stores data that links on-chain transactions to Flyweight order deposits

### getPendingDepositOrders

```solidity
function getPendingDepositOrders() external view returns (struct Order[])
```

### onlyValidOracle

```solidity
modifier onlyValidOracle()
```

### onlyEoa

```solidity
modifier onlyEoa()
```

## TokenWhitelist

_The decision to only support a limited set of "trusted" ERC20's is an intentional product decision. E.g.: if a flyweight order were to swap a coin called SuperMoonDoggyDegenCoin, there is no guarantee on slippage for coins with no uniswap liquidity. Only coins with decent uniswap liquidity should be permitted for best user experience with Flyweight._

### symbols

```solidity
string[] symbols
```

_These are public to maximise contract transparency with users_

### addresses

```solidity
mapping(string => address) addresses
```

### constructor

```solidity
constructor(address uniswapRouterAddress, string[] _symbols, address[] _addresses) public
```

### getSymbols

```solidity
function getSymbols() public view returns (string[])
```

## FlyweightEvents

### PriceUpdated

```solidity
event PriceUpdated(uint256 timestamp, string symbol, string oldPrice, string newPrice)
```

Records token prices that are updated in the contract

_Prices obtained from Flyweight oracle_

### OrderTriggered

```solidity
event OrderTriggered(uint256 orderId)
```

Records when an order is triggered.

_This event happens after the Flyweight oracle calculating that an order's swap should be executed, & before the actual on-chain swap occurring._

### OrderExecuted

```solidity
event OrderExecuted(uint256 orderId)
```

Records when an order is executed.

_This event happens after the on-chain swap is executed._

### OrderCancelRequested

```solidity
event OrderCancelRequested(uint256 orderId, address sender)
```

Records when an order cancelled is requested.

_This event happens after the EOA calls the cancel contract method, & before the order state is updated in the contract data._

### OrderCancelled

```solidity
event OrderCancelled(uint256 orderId, uint256 tokenInAmount, string tokenIn, address owner, uint256 blockNumber, uint256 blockTimestamp)
```

Records when an order is cancelled.

_This event happens after the data is updated in the smart contract._

## OrderState

```solidity
enum OrderState {
  UNTRIGGERED,
  PENDING_DEPOSIT,
  EXECUTED,
  CANCELLED
}
```

## OrderTriggerDirection

```solidity
enum OrderTriggerDirection {
  BELOW,
  EQUAL,
  ABOVE
}
```

## Order

```solidity
struct Order {
  uint256 id;
  address owner;
  enum OrderState orderState;
  string tokenIn;
  string tokenOut;
  string tokenInTriggerPrice;
  enum OrderTriggerDirection direction;
  uint256 tokenInAmount;
  uint256 blockNumber;
}
```

## NewPriceItem

```solidity
struct NewPriceItem {
  string symbol;
  string price;
}
```

## NewDepositTx

```solidity
struct NewDepositTx {
  uint256 orderId;
  bytes32 txHash;
}
```

