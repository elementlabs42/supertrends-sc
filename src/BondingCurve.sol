// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import { Ownable } from '@openzeppelin/contracts/access/Ownable.sol';
import { IERC20 } from '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import { SafeERC20 } from '@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol'; // Inherits Context

import { IBondingCurve } from './interfaces/IBondingCurve.sol';

contract BondingCurve is IBondingCurve, Ownable {
    using SafeERC20 for IERC20;

    IERC20 public trendToken;
    IERC20 public reserveToken;

    uint256 public accumulatedFees; // Fees tracked in terms of trend token

    address public ammPair;

    modifier notMigrated() {
        if (ammPair != address(0)) revert BondingCurve_AlreadyMigratedToAMM();
        _;
    }

    constructor() Ownable(_msgSender()) { }

    function initialize(address trendToken_, address reserveToken_) external override onlyOwner {
        trendToken = IERC20(trendToken_);
        reserveToken = IERC20(reserveToken_);
    }

    /**
     * ==================== Read-only functions ====================
     */
    function trendTokenBalance() public view returns (uint256) {
        return trendToken.balanceOf(address(this));
    }

    /**
     * @notice Returns the amount of reserve token that can be purchased for the given amount of trend token.
     */
    function getReserveAmount(uint256 trendTokenAmount) public view returns (uint256) {
        // TODO: Implement
        uint256 amount = trendTokenAmount;

        return amount;
    }

    /**
     * ===================== Mutating functions =====================
     */
    function buyTrendToken(uint256 amount, address receiver) external override notMigrated returns (uint256) {
        if (receiver != address(0)) revert BondingCurve_ReceiverCannotBeZero();

        uint256 maxBuyAmount = trendTokenBalance();
        if (amount > maxBuyAmount) {
            amount = maxBuyAmount;
        }

        uint256 reserveAmount = getReserveAmount(amount);
        reserveToken.safeTransferFrom(_msgSender(), address(this), reserveAmount);
        trendToken.safeTransfer(receiver, amount);

        // TODO: Update accumulatedFees

        return amount;
    }

    function sellTrendToken(uint256 amount, address receiver) external override notMigrated returns (uint256) {
        if (receiver != address(0)) revert BondingCurve_ReceiverCannotBeZero();

        // TODO: Implement

        return amount;
    }

    function migrateToAmm(address ammFactory) external override notMigrated returns (address pair) {
        // TODO: Implement
    }

    function claimFees() external override {
        trendToken.safeTransfer(owner(), accumulatedFees);
        accumulatedFees = 0;
    }
}
