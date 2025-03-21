// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

interface IERC20Capped {
    /**
     * @dev Total supply cap has been exceeded.
     */
    error ERC20ExceededCap(uint256 increasedSupply, uint256 cap);

    /**
     * @dev The supplied cap is not a valid cap.
     */
    error ERC20InvalidCap(uint256 cap);

    /**
     * @dev Returns the cap on the token's total supply.
     */
    function cap() external view returns (uint256);
}
