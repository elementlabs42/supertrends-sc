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

    /**
     * @notice Returns the address of the AMM pair the liquidity was migrated to.
     */
    function ammPair() external returns (address);

    /**
     * @notice Returns the amount of accumulated fees expressed in trend token.
     */
    function accumulatedFees() external returns (uint256);

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
    function buyTrendToken(uint256 amount, address receiver) external returns (uint256 amountBought);

    /**
     * @notice Executes a transaction to sell trend token for reserve token.
     */
    function sellTrendToken(uint256 amount, address receiver) external returns (uint256 amountSold);

    /**
     * @notice Migrates liquidity to an AMM.
     * @return pair Address of the created AMM pair.
     */
    function migrateToAmm(address ammFactory) external returns (address pair);

    /**
     * @notice Claim trading fees in trend token. Can only be called by the owner.
     */
    function claimFees() external;
}
