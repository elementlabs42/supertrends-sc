// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.29;

interface IBondingCurve {
    event OwnerSet(address owner);

    event Swap(
        address indexed sender,
        uint256 amount0In,
        uint256 amount1In,
        uint256 amount0Out,
        uint256 amount1Out,
        uint256 fee0,
        uint256 fee1,
        address indexed to
    );

    event FeesClaimed(uint256 amount0, uint256 amount1);

    event Listed(address ammFactory, address ammPool);

    event Donated(address to, uint256 amount);

    event BondingCurveCreationFeeSet(uint256 fee);

    event BondingCurveSwapFeeSet(uint256 fee);

    event ListingFeeSet(uint256 fee);

    event ListingRewardSet(uint256 fee);

    event DonationRateSet(uint256 fee);

    event AmmFactorySet(address ammFactory);

    function initialize(address token, address superToken, uint256 creationFee, uint256 swapFee, uint256 listingFee, uint256 listingReward, uint256 donationRate, address ammFactory) external;

    function owner() external view returns (address);

    function tokens() external view returns (address token0, address token1);

    function fees() external view returns (uint256 amount0, uint256 amount1);    

    function listed() external view returns (bool);

    function amm() external view returns (address ammFactory, address ammPool);

    function donated() external view returns (bool);

    function swap(uint256 amount0Out, uint256 amount1Out, address to) external;

    function listToken() external returns (address amm);

    function claimFees(address to) external;

    function donate(address to) external returns (uint256 amount);

    function setOwner(address) external;

    function setBondingCurveCreationFee(uint256 fee) external;

    function setBondingCurveSwapFee(uint256 fee) external;

    function setListingFee(uint256 fee) external;

    function setListingReward(uint256 fee) external;

    function setDonationRate(uint256 fee) external;

    function setAmmFactory(address ammFactory) external;
}
