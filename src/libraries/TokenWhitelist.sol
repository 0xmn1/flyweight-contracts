// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract TokenWhitelist {
    address constant public UNISWAP_ROUTER_ADDRESS = 0xE592427A0AEce92De3Edee1F18E0157C05861564;
    mapping(string => address) public addresses;

    constructor(uint chainId) {
        if (chainId == 1) {
            initTokenWhitelistMainnet();
        } else if (chainId == 5) {
            initTokenWhitelistGoerli();
        }
    }

    function initTokenWhitelistMainnet() private {
        addresses["1INCH"] = 0x111111111117dC0aa78b770fA6A738034120C302;
        addresses["AAVE"] = 0x7Fc66500c84A76Ad7e9c93437bFc5Ac33E2DDaE9;
        addresses["AXS"] = 0xBB0E17EF65F82Ab018d8EDd776e8DD940327B28b;
        addresses["BAL"] = 0xba100000625a3754423978a60c9317c58a424e3D;
        addresses["BUSD"] = 0x4Fabb145d64652a948d72533023f6E7A623C7C53;
        addresses["COMP"] = 0xc00e94Cb662C3520282E6f5717214004A7f26888;
        addresses["CRV"] = 0xD533a949740bb3306d119CC777fa900bA034cd52;
        addresses["DAI"] = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
        addresses["DYDX"] = 0x92D6C1e31e14520e676a687F0a93788B716BEff5;
        addresses["ENS"] = 0xC18360217D8F7Ab5e7c516566761Ea12Ce7F9D72;
        addresses["FXS"] = 0x3432B6A60D23Ca0dFCa7761B7ab56459D9C964D0;
        addresses["GUSD"] = 0x056Fd409E1d7A124BD7017459dFEa2F387b6d5Cd;
        addresses["IMX"] = 0xF57e7e7C23978C3cAEC3C3548E3D615c346e79fF;
        addresses["LDO"] = 0x5A98FcBEA516Cf06857215779Fd812CA3beF1B32;
        addresses["LINK"] = 0x514910771AF9Ca656af840dff83E8264EcF986CA;
        addresses["LRC"] = 0xBBbbCA6A901c926F240b89EacB641d8Aec7AEafD;
        addresses["MATIC"] = 0x7D1AfA7B718fb893dB30A3aBc0Cfc608AaCfeBB0;
        addresses["MKR"] = 0x9f8F72aA9304c8B593d555F12eF6589cC3A579A2;
        addresses["PAXG"] = 0x45804880De22913dAFE09f4980848ECE6EcbAf78;
        addresses["RPL"] = 0xD33526068D116cE69F19A9ee46F0bd304F21A51f;
        addresses["RUNE"] = 0x3155BA85D5F96b2d030a4966AF206230e46849cb;
        addresses["SHIB"] = 0x95aD61b0a150d79219dCF64E1E6Cc01f0B64C4cE;
        addresses["SNX"] = 0xC011a73ee8576Fb46F5E1c5751cA3B9Fe0af2a6F;
        addresses["STETH"] = 0xae7ab96520DE3A18E5e111B5EaAb095312D7fE84;
        addresses["SUSHI"] = 0x6B3595068778DD592e39A122f4f5a5cF09C90fE2;
        addresses["UNI"] = 0x1f9840a85d5aF5bf1D1762F925BDADdC4201F984;
        addresses["USDC"] = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
        addresses["USDT"] = 0xdAC17F958D2ee523a2206206994597C13D831ec7;
        addresses["WBTC"] = 0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599;
        addresses["WETH"] = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
        addresses["XAUT"] = 0x68749665FF8D2d112Fa859AA293F07A622782F38;

        IERC20(addresses["1INCH"]).approve(UNISWAP_ROUTER_ADDRESS, type(uint).max);
        IERC20(addresses["AAVE"]).approve(UNISWAP_ROUTER_ADDRESS, type(uint).max);
        IERC20(addresses["AXS"]).approve(UNISWAP_ROUTER_ADDRESS, type(uint).max);
        IERC20(addresses["BAL"]).approve(UNISWAP_ROUTER_ADDRESS, type(uint).max);
        IERC20(addresses["BUSD"]).approve(UNISWAP_ROUTER_ADDRESS, type(uint).max);
        IERC20(addresses["COMP"]).approve(UNISWAP_ROUTER_ADDRESS, type(uint).max);
        IERC20(addresses["CRV"]).approve(UNISWAP_ROUTER_ADDRESS, type(uint).max);
        IERC20(addresses["DAI"]).approve(UNISWAP_ROUTER_ADDRESS, type(uint).max);
        IERC20(addresses["DYDX"]).approve(UNISWAP_ROUTER_ADDRESS, type(uint).max);
        IERC20(addresses["ENS"]).approve(UNISWAP_ROUTER_ADDRESS, type(uint).max);
        IERC20(addresses["FXS"]).approve(UNISWAP_ROUTER_ADDRESS, type(uint).max);
        IERC20(addresses["GUSD"]).approve(UNISWAP_ROUTER_ADDRESS, type(uint).max);
        IERC20(addresses["IMX"]).approve(UNISWAP_ROUTER_ADDRESS, type(uint).max);
        IERC20(addresses["LDO"]).approve(UNISWAP_ROUTER_ADDRESS, type(uint).max);
        IERC20(addresses["LINK"]).approve(UNISWAP_ROUTER_ADDRESS, type(uint).max);
        IERC20(addresses["LRC"]).approve(UNISWAP_ROUTER_ADDRESS, type(uint).max);
        IERC20(addresses["MATIC"]).approve(UNISWAP_ROUTER_ADDRESS, type(uint).max);
        IERC20(addresses["MKR"]).approve(UNISWAP_ROUTER_ADDRESS, type(uint).max);
        IERC20(addresses["PAXG"]).approve(UNISWAP_ROUTER_ADDRESS, type(uint).max);
        IERC20(addresses["RPL"]).approve(UNISWAP_ROUTER_ADDRESS, type(uint).max);
        IERC20(addresses["RUNE"]).approve(UNISWAP_ROUTER_ADDRESS, type(uint).max);
        IERC20(addresses["SHIB"]).approve(UNISWAP_ROUTER_ADDRESS, type(uint).max);
        IERC20(addresses["SNX"]).approve(UNISWAP_ROUTER_ADDRESS, type(uint).max);
        IERC20(addresses["STETH"]).approve(UNISWAP_ROUTER_ADDRESS, type(uint).max);
        IERC20(addresses["SUSHI"]).approve(UNISWAP_ROUTER_ADDRESS, type(uint).max);
        IERC20(addresses["UNI"]).approve(UNISWAP_ROUTER_ADDRESS, type(uint).max);
        IERC20(addresses["USDC"]).approve(UNISWAP_ROUTER_ADDRESS, type(uint).max);
        IERC20(addresses["USDT"]).approve(UNISWAP_ROUTER_ADDRESS, type(uint).max);
        IERC20(addresses["WBTC"]).approve(UNISWAP_ROUTER_ADDRESS, type(uint).max);
        IERC20(addresses["WETH"]).approve(UNISWAP_ROUTER_ADDRESS, type(uint).max);
        IERC20(addresses["XAUT"]).approve(UNISWAP_ROUTER_ADDRESS, type(uint).max);
    }

    function initTokenWhitelistGoerli() private {
        addresses["UNI"] = 0x1f9840a85d5aF5bf1D1762F925BDADdC4201F984;
        addresses["WETH"] = 0xB4FBF271143F4FBf7B91A5ded31805e42b2208d6;

        IERC20(addresses["UNI"]).approve(UNISWAP_ROUTER_ADDRESS, type(uint).max);
        IERC20(addresses["WETH"]).approve(UNISWAP_ROUTER_ADDRESS, type(uint).max);
    }
}
