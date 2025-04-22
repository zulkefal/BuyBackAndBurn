// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

library Constants {
    //arbitrum addresses

    address public constant SWAP_ROUTER =
        0xE592427A0AEce92De3Edee1F18E0157C05861564;

    address public constant ANY_TOKEN_ADDRESS =
        0x431402e8b9dE9aa016C743880e04E517074D8cEC;

    address public constant WETH_ADDRESS =
        0x82aF49447D8a07e3bd95BD0d56f35241523fBab1;

    address public constant RBOT_TOKEN =
        0x53ce5F2A18A623317357d6366eC59b47cbb0060D;

    address public constant ZERO_ADDRESS = address(0);

    uint24 public constant FEE_TIER_USDT_WETH = 500; // 0.05% fee

    // take the fee by finding pool from Uniswap
    // for heigic
    // https://app.uniswap.org/explore/pools/arbitrum/0x1284df89284492c08011e380db86462F6D17eAa8
    uint24 public constant FEE_TIER_WETH_ANY_TOKEN = 500; // 0.05% fee
    uint24 public constant FEE_TIER_RBOT_TOKEN = 3000; // 1% fee
}
