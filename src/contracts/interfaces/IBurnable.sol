// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

interface IBurnable {
    event BurnerSet(address indexed burner, bool isBurner);

    error BurnableSameValueAlreadySet();
    error BurnableInvalidTokenOwner(address tokenOwner);
    error BurnableUnauthorizedBurner(address burner);

    function canBurn(address burner) external view returns (bool isBurner);

    function burn(uint256 amount) external;

    function burnFrom(address from, uint256 amount) external;
}
