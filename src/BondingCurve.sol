// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.29;

import {IBondingCurve} from "./Interfaces/iBondingCurve.sol";
import {IERC20} from "./Interfaces/IERC20.sol";
import {IListingOracle} from "./Interfaces/IListingOracle.sol";

contract BondingCurve is IBondingCurve {

    address public override owner;
    address public override listingOracle;
    address public override token0;
    address public override token1;
    uint256 public override creationFee;
    uint256 public override swapFee;
    uint256 public override listingFee;
    uint256 public override listingReward;
    uint256 public override donationRate;
    address public override ammFactory;
    address public override amm;
    uint256 public override accumulatedFees0;
    uint256 public override accumulatedFees1;

    constructor() {
        owner = msg.sender;

        emit OwnerSet(msg.sender);
    }

    function initialize(address _listingOracle, address _token, address _quoteToken, uint256 _creationFee, uint256 _swapFee, uint256 _listingFee, uint256 _listingReward, uint256 _donationRate, address _ammFactory) external {
        require(msg.sender == owner, 'TF00');

        listingOracle = _listingOracle;
        token0 = _token;
        token1 = _quoteToken;
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

    function reserve0() public view override returns (uint256) {
        return IERC20(token0).balanceOf(address(this)) - accumulatedFees0;
    }

    function reserve1() public view override returns (uint256) {
        return IERC20(token1).balanceOf(address(this)) - accumulatedFees1;
    }

    function listed() public view override returns (bool) {
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
        require(IListingOracle(listingOracle).meetsListingRequirements(token0, token1, reserve0(), reserve1()), 'TF02');

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

    function setListingOracle(address _listingOracle) external override {
        require(msg.sender == owner, 'TF00');
        require(_listingOracle != listingOracle, 'TF01');
        require(_listingOracle != address(0), 'TF02');
        listingOracle = _listingOracle;

        emit ListingOracleSet(_listingOracle);
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