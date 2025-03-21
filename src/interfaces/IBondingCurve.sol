// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

/**
 * @title Bonding curve used to sell a trend token.
 * @notice After creation, a trend token can only be bought from a bonding curve. This takes place until it reaches
 * a predefined market cap. After that, the liquidity can be migrated to an AMM and trading continues there.
 */
interface IBondingCurve {
    error BondingCurve_ReceiverCannotBeZero();
    error BondingCurve_AlreadyMigratedToAMM();

    /**
     * ==================== Getters ====================
     */
    function amm() external returns (address);

    /**
     * =============== Mutating functions ==============
     */

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

    /**
     * @notice Migrate liquidity to an AMM.
     */
    function migrateToAmm(address amm) external;
}
