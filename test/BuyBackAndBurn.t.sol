// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import "../lib/forge-std/src/Test.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import {BuyBackBurn} from "../src/BuyBackAndBurn.sol";

import {Constants} from "../src/Constants.sol";

contract BuyBackBurnTest is Test {
    BuyBackBurn public buyBackAndBurn;
    address public holderAddress = 0xd47Ef934e301E0ee3b1cE0e3EEbCb64De8b231BE;
    address public tokenAddress = 0x431402e8b9dE9aa016C743880e04E517074D8cEC;

    function setUp() public {
        buyBackAndBurn = new BuyBackBurn();
    }

    function testPaymentSentSingleSwap() public {
        uint256 amount = 10_000000000000000000; //
        vm.startPrank(holderAddress);
        IERC20(tokenAddress).approve(address(buyBackAndBurn), amount);

        buyBackAndBurn.payFeeSingleSwap(tokenAddress, amount);
        uint256 supplyAfter = IERC20(tokenAddress).totalSupply();

        vm.stopPrank();
    }

    function testPaymentSentMultiHop() public {
        uint256 amount = 10_000000000000000000; //
        vm.startPrank(holderAddress);
        IERC20(tokenAddress).approve(address(buyBackAndBurn), amount);
        uint256 supplyBefore = IERC20(Constants.RBOT_TOKEN).totalSupply();

        buyBackAndBurn.payFeeMultiHop(tokenAddress, amount);

        uint256 supplyAfter = IERC20(Constants.RBOT_TOKEN).totalSupply();
        console.log(
            "supplyBefore: %s, supplyAfter: %s",
            supplyBefore,
            supplyAfter
        );

        vm.stopPrank();
    }
}
