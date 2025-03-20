// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

interface IFactory {
    event SuperTokenCreated(address indexed superToken, address indexed creator);
    event SubTokenCreated(address indexed subToken, address indexed superToken, address indexed creator);

    error FactoryMustBeSuperToken(address subToken);

    function getBondingCurve(address token) external view returns (address);
    function getSuperToken(address subToken) external view returns (address);
    function getSubTokens(address superToken) external view returns (address[] memory);
    function getAllTokens() external view returns (address[] memory);
    function getAllTokensLength() external view returns (uint256);
    function isSuperToken(address token) external view returns (bool);

    function createSuperToken(string memory name, string memory symbol) external returns (address);
    function createSubToken(address superToken, string memory name, string memory symbol) external returns (address);

    function setMintFee(address token, uint256 fee) external;
    function setTokenCreationFee(uint256 fee) external;

    function withdrawFees(address bondingCurve, address to, uint256 amount) external;
}
