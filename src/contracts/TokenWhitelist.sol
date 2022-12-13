// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/**
 * @title TokenWhitelist
 * Holds token addresses swappable on the Flyweight platform. These addresses are only set during contract creation and are never changed
 * @dev The decision to only support a limited set of "trusted" ERC20's is an intentional product decision. E.g.: if a flyweight order were to swap a coin called SuperMoonDoggyDegenCoin, there is no guarantee on slippage for coins with no uniswap liquidity. Only coins with decent uniswap liquidity should be permitted for best user experience with Flyweight.
 */
contract TokenWhitelist {
  /// @dev These are public to maximise contract transparency with users
  string[] public symbols;
  mapping(string => address) public addresses;

  constructor(
    address uniswapRouterAddress,
    string[] memory _symbols,
    address[] memory _addresses
  ) {
    assert(uniswapRouterAddress != address(0));
    assert(_symbols.length == _addresses.length);

    /// Set symbols
    symbols = _symbols;

    /// Set addresses
    for (uint i = 0; i < _symbols.length; i++) {
      string memory symbol = _symbols[i];
      address addr = _addresses[i];
      addresses[symbol] = addr;
    }
  }

  function getSymbols() public view returns (string[] memory) {
    return symbols;
  }
}
