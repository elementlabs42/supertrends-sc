// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.29;

interface IFactory {
    event OwnerSet(address owner);

    event TokenCreated(address indexed token, address indexed superToken, address bondingCurve, uint256);

    event DefaultBondingCurveCreationFeeSet(uint256 fee);

    event DefaultBondingCurveSwapFeeSet(uint256 fee);

    event DefaultListingFeeSet(uint256 fee);

    event DefaultListingRewardSet(uint256 fee);

    event DefaultDonationRateSet(uint256 fee);

    event DefaultAmmFactorySet(address ammFactory);

    function owner() external view returns (address);

    function allTokens(uint256) external view returns (address superOrSubToken);

    function allTokensLength() external view returns (uint256);

    function getSuperToken(address subToken) external view returns (address superToken);

    function isSuperToken(address superToken) external view returns (bool);

    function getBondingCurve(address superOrSubToken) external view returns (address bondingCurve);

    function getAMM(address superOrSubToken) external view returns (address amm);

    function createSuperToken(string memory symbol, string memory name) external returns (address superToken, address bondingCurve);

    function createSubToken(string memory symbol, string memory name, address superToken) external returns (address subToken, address bondingCurve);

    function buyToken(address superOrSubToken, uint256 amount) external payable;

    function sellToken(address superOrSubToken, uint256 amount) external;

    function listToken(address superOrSubToken) external returns (address amm);

    function claimFees(address superOrSubToken, address to) external;

    function donate(address superOrSubToken, address to) external returns (address amount);

    function setOwner(address) external;

    function setDefaultBondingCurveCreationFee(uint256 fee) external;

    function setBondingCurveCreationFee(address superOrSubToken, uint256 fee) external;

    function setDefaultBondingCurveSwapFee(uint256 fee) external;

    function setBondingCurveSwapFee(address superOrSubToken, uint256 fee) external;

    function setDefaultListingFee(uint256 fee) external;

    function setListingFee(address superOrSubToken, uint256 fee) external;

    function setDefaultListingReward(uint256 fee) external;

    function setListingReward(address superOrSubToken, uint256 fee) external;

    function setDefaultDonationRate(uint256 fee) external;

    function setDonationRate(address superOrSubToken, uint256 fee) external;

    function setDefaultAmmFactory(address ammFactory) external;

    function setAmmFactory(address superOrSubToken, address ammFactory) external;
}
