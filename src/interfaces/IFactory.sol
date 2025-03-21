// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

interface IFactory {
    event SuperTokenCreated(address indexed superToken, address indexed creator);
    event SubTokenCreated(address indexed subToken, address indexed superToken, address indexed creator);
    event TokenTradeFeeSet(uint256 fee);
    event TokenCreationFeeSet(uint256 fee);
    event ListingFeeSet(uint256 fee);
    event CreatorRewardSet(uint256 reward);
    event ListingRateSet(uint256 rate);
    event DonationRateSet(uint256 rate);

    error FactoryMustBeSuperToken(address token);
    error FactorySameValueAlreadySet();

    function getBondingCurve(address token) external view returns (address);
    function getSuperToken(address subToken) external view returns (address);
    function getSubTokens(address superToken) external view returns (address[] memory);
    function getAllTokens() external view returns (address[] memory);
    function getAllTokensLength() external view returns (uint256);
    function isSuperToken(address token) external view returns (bool);

    function createToken(string memory name, string memory symbol, address superToken) external returns (address);

    function setTokenCreationFee(uint256 fee) external;
    function setTokenTradeFee(uint256 fee) external;

    function withdrawFees(address bondingCurve, address to, uint256 amount) external;
}
