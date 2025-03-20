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

    event CreationFeeSet(uint256 fee);

    event SwapFeeSet(uint256 fee);

    event ListingFeeSet(uint256 fee);

    event ListingRewardSet(uint256 fee);

    event DonationRateSet(uint256 fee);

    event AmmFactorySet(address ammFactory);

    function initialize(address token, address quoteToken, uint256 creationFee, uint256 swapFee, uint256 listingFee, uint256 listingReward, uint256 donationRate, address ammFactory) external;

    function owner() external view returns (address);

    function token0() external view returns (address);

    function token1() external view returns (address);

    function creationFee() external view returns (uint256);

    function swapFee() external view returns (uint256);

    function listingFee() external view returns (uint256);
    
    function listingReward() external view returns (uint256);

    function donationRate() external view returns (uint256);

    function ammFactory() external view returns (address);

    function amm() external view returns (address);

    function listed() external view returns (bool);

    function swap(uint256 amount0Out, uint256 amount1Out, address to) external;

    function listToken() external returns (address amm);

    function claimFees(address to) external;

    function donate(address to) external returns (uint256 amount);

    function setOwner(address) external;

    function setCreationFee(uint256 fee) external;

    function setSwapFee(uint256 fee) external;

    function setListingFee(uint256 fee) external;

    function setListingReward(uint256 fee) external;

    function setDonationRate(uint256 fee) external;

    function setAmmFactory(address ammFactory) external;
}
