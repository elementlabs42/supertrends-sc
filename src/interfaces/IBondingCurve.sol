// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

interface IBondingCurve {
    error BondingCurve_ReceiverCannotBeZero();

    /**
     * @notice Initializes the contract. Can only be called by the owner.
     */
    function initialize(address trendToken, address reserveToken) external;

    /**
     * @notice Executes a transaction to buy trend token for reserve token.
     */
    function buyTrendToken(uint256 amount, address receiver) external returns (uint256);

    /**
     * @notice Executes a transaction to sell trend token for reserve token.
     */
    function sellTrendToken(uint256 amount, address receiver) external returns (uint256);
}
