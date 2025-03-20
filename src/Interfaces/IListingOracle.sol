// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.29;

interface IListingOracle {
  
  function meetsListingRequirements(address token0, address token1, uint256 amount0, uint256 amount1) external view returns (bool);
}