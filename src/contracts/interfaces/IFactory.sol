// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

interface IFactory {
    event SuperTokenCreated(address indexed superToken, address indexed creator);
    event SubTokenCreated(address indexed subToken, address indexed creator);

    function createSuperToken(string memory name, string memory symbol) external returns (address);
    function createSubToken(address superToken, string memory name, string memory symbol) external returns (address);

    function setMintFee(address token, uint256 fee) external;
    function setTokenCreationFee(uint256 fee) external;

    function withdrawFees(address bondingCurve, address to, uint256 amount) external;
}
