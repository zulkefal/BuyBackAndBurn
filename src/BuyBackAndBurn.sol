//SPDX-License-Identifier: MIT
pragma solidity 0.8.28;
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {ERC20Burnable} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

import {ISwapRouter} from "@uniswap/v3-periphery/interfaces/ISwapRouter.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {TransferHelper} from "@uniswap/v3-periphery/libraries/TransferHelper.sol";

import {Constants} from "./Constants.sol";

contract BuyBackBurn {
    /// @dev Uses the SafeERC20 library for the IERC20 token operations.
    using SafeERC20 for IERC20;

    address public wethAddress = Constants.WETH_ADDRESS;

    constructor() {}

    event TokenReceived(uint256 tokenReceived);

    function payFeeMultiHop(address _tokenAddress, uint256 _amount) public {
        if (_amount == 0) {
            revert("Amount cannot be zero");
        }

        IERC20(_tokenAddress).approve(Constants.SWAP_ROUTER, _amount);

        IERC20(_tokenAddress).safeTransferFrom(
            msg.sender,
            address(this),
            _amount
        );

        // Encode path for multi-hop swap (Heige → WETH → GMX)
        bytes memory pathSwap = abi.encodePacked(
            address(_tokenAddress),
            Constants.FEE_TIER_USDT_WETH,
            Constants.WETH_ADDRESS,
            Constants.FEE_TIER_RBOT_TOKEN,
            Constants.RBOT_TOKEN
        );

        ISwapRouter.ExactInputParams memory swapParamsGMX = ISwapRouter
            .ExactInputParams({
                path: pathSwap,
                recipient: address(this),
                deadline: block.timestamp + 300,
                amountIn: _amount,
                amountOutMinimum: 0
            });

        uint256 tokenReceived = ISwapRouter(Constants.SWAP_ROUTER).exactInput(
            swapParamsGMX
        );

        uint256 contractBalance = IERC20(Constants.RBOT_TOKEN).balanceOf(
            address(this)
        );
        emit TokenReceived(contractBalance);

        ERC20Burnable(Constants.RBOT_TOKEN).burn(tokenReceived);
    }

    function payFeeSingleSwap(address _tokenAddress, uint256 _amount) public {
        if (_amount == 0) {
            revert("Amount cannot be zero");
        }

        IERC20(_tokenAddress).approve(Constants.SWAP_ROUTER, _amount);

        TransferHelper.safeTransferFrom(
            _tokenAddress,
            msg.sender,
            address(this),
            _amount
        );

        // Encode path for swap (AnyToken → WETH )
        bytes memory pathOfToken = abi.encodePacked(
            address(_tokenAddress),
            Constants.FEE_TIER_USDT_WETH,
            Constants.WETH_ADDRESS
        );

        ISwapRouter.ExactInputParams memory swapParamsToken = ISwapRouter
            .ExactInputParams({
                path: pathOfToken,
                recipient: address(this),
                deadline: block.timestamp + 300,
                amountIn: _amount,
                amountOutMinimum: 0
            });

        uint256 tokenReceived = ISwapRouter(Constants.SWAP_ROUTER).exactInput(
            swapParamsToken
        );

        uint256 contractBalance = IERC20(Constants.WETH_ADDRESS).balanceOf(
            address(this)
        );
        emit TokenReceived(contractBalance);

        emit TokenReceived(tokenReceived);
    }
}
