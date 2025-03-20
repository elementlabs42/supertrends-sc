// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.29;

import {IBondingCurve} from "./Interfaces/iBondingCurve.sol";
import {IERC20} from "./Interfaces/IERC20.sol";

contract BondingCurve is IBondingCurve {

    address public override owner;
    address public token0;
    address public token1;
    uint256 public creationFee;
    uint256 public swapFee;
    uint256 public listingFee;
    uint256 public listingReward;
    uint256 public donationRate;
    address public ammFactory;
    address public amm;
    uint256 public accumulatedFees0;
    uint256 public accumulatedFees1;

    constructor() {
        owner = msg.sender;

        emit OwnerSet(msg.sender);
    }

    function initialize(address token, address quoteToken, uint256 _creationFee, uint256 _swapFee, uint256 _listingFee, uint256 _listingReward, uint256 _donationRate, address _ammFactory) external {
        token0 = token;
        token1 = quoteToken;
        creationFee = _creationFee;
        swapFee = _swapFee;
        listingFee = _listingFee;
        listingReward = _listingReward;
        donationRate = _donationRate;
        ammFactory = _ammFactory;

        emit CreationFeeSet(_creationFee);
        emit SwapFeeSet(_swapFee);
        emit ListingFeeSet(_listingFee);
        emit ListingRewardSet(_listingReward);
        emit DonationRateSet(_donationRate);
        emit AmmFactorySet(_ammFactory);
    }

    function accumulatedFees() external view returns (uint256 amount0, uint256 amount1) {
        return (0, 0);
    }

    function listed() public view returns (bool) {
        return amm != address(0);
    }

    function swap(uint256 amount0Out, uint256 amount1Out, address to) external override {
        // require(msg.sender == owner, 'TF00');
        // require(amount0Out > 0 || amount1Out > 0, 'TF01');
        // require(amount0Out < balanceOf(token0), 'TF02');
        // require(amount1Out < balanceOf(token1), 'TF03');
        // require(to != address(0), 'TF04');
    }

    function listToken() external override {
        require(!listed(), 'TF01');
        // require(token0 != address(0) && token1 != address(0), 'TF02');
        // require(token0 != token1, 'TF03');
    }

    function claimFees(address to) external override {
        require(msg.sender == owner, 'TF00');
        require(to != address(0), 'TF01');
        require(accumulatedFees0 > 0 || accumulatedFees1 > 0, 'TF02');

        emit FeesClaimed(accumulatedFees0, accumulatedFees1);

        if (accumulatedFees0 > 0) {
            IERC20(token0).transfer(to, accumulatedFees0);
            accumulatedFees0 = 0;
        }
        if (accumulatedFees1 > 0) {
            IERC20(token1).transfer(to, accumulatedFees1);
            accumulatedFees1 = 0;
        }
    }

    function donate(address to) external override {
        // require(msg.sender == owner, 'TF00');
        // require(to != address(0), 'TF01');
        // // TODO
    }

    function setOwner(address _owner) external override {
        require(msg.sender == owner, 'TF00');
        require(_owner != owner, 'TF01');
        require(_owner != address(0), 'TF02');
        owner = _owner;

        emit OwnerSet(_owner);
    }

    function setCreationFee(uint256 _creationFee) external override {
        require(msg.sender == owner, 'TF00');
        require(_creationFee != creationFee, 'TF01');
        creationFee = _creationFee;

        emit CreationFeeSet(_creationFee);
    }

    function setSwapFee(uint256 _swapFee) external override {
        require(msg.sender == owner, 'TF00');
        require(_swapFee != swapFee, 'TF01');
        swapFee = _swapFee;
        emit SwapFeeSet(_swapFee);
    }
    
    function setListingFee(uint256 _listingFee) external override {
        require(msg.sender == owner, 'TF00');
        require(_listingFee != listingFee, 'TF01');
        listingFee = _listingFee;

        emit ListingFeeSet(_listingFee);
    }
    
    function setListingReward(uint256 _listingReward) external override {
        require(msg.sender == owner, 'TF00');
        require(_listingReward != listingReward, 'TF01');
        listingReward = _listingReward;

        emit ListingRewardSet(_listingReward);
    }

    function setAmmFactory(address _ammFactory) external override {
        require(msg.sender == owner, 'TF00');
        require(_ammFactory != ammFactory, 'TF01');
        require(_ammFactory != address(0), 'TF02');
        ammFactory = _ammFactory;
        
        emit AmmFactorySet(_ammFactory);
    }
    
}