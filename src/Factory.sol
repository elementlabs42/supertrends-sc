// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.29;

import {IFactory} from "./Interfaces/IFactory.sol";
import {Token} from "./Token.sol";
import {BondingCurve} from "./BondingCurve.sol";
import {IListingOracle} from "./Interfaces/IListingOracle.sol";

contract Factory is IFactory, IListingOracle {
    uint256 private constant DEFAULT_ERC20_SUPPLY = 1e27;

    address public override owner;
    address public override nativeToken;
    mapping(address superOrSubToken => address bondingCurve) public override getBondingCurve;
    mapping(address subToken => address superToken) public override getSuperToken;
    mapping(address superToken=> address[] subTokens) public override getSubTokens;
    address[] public override allTokens;
    uint256 public override defaultBondingCurveCreationFee;
    uint256 public override defaultBondingCurveSwapFee;
    uint256 public override defaultListingFee;
    uint256 public override defaultListingReward;
    uint256 public override defaultDonationRate;
    address public override defaultAmmFactory;
    uint256 public override listingThreshold;

    constructor(address _nativeToken, uint256 _defaultBondingCurveCreationFee, uint256 _defaultBondingCurveSwapFee, uint256 _defaultListingFee, uint256 _defaultListingReward, uint256 _defaultDonationRate, address _defaultAmmFactory, uint256 _listingThreshold) {
        owner = msg.sender;
        nativeToken = _nativeToken;
        defaultBondingCurveCreationFee = _defaultBondingCurveCreationFee;
        defaultBondingCurveSwapFee = _defaultBondingCurveSwapFee;
        defaultListingFee = _defaultListingFee;
        defaultListingReward = _defaultListingReward;
        defaultDonationRate = _defaultDonationRate;
        defaultAmmFactory = _defaultAmmFactory;
        listingThreshold = _listingThreshold;

        emit OwnerSet(msg.sender);
        emit DefaultBondingCurveCreationFeeSet(_defaultBondingCurveCreationFee);
        emit DefaultBondingCurveSwapFeeSet(_defaultBondingCurveSwapFee);
        emit DefaultListingFeeSet(_defaultListingFee);
        emit DefaultListingRewardSet(_defaultListingReward);
        emit DefaultDonationRateSet(_defaultDonationRate);
        emit DefaultAmmFactorySet(_defaultAmmFactory);
        emit ListingThresholdSet(_listingThreshold);
    }

    function createSuperToken(
        string memory symbol,
        string memory name
    ) external override returns (address superToken, address bondingCurve) {
        return createToken(symbol, name, address(0));
    }

    function createSubToken(
        string memory symbol,
        string memory name,
        address superToken
    ) external override returns (address subToken, address bondingCurve) {
        return createToken(symbol, name, superToken);
    } 

    function createToken(
        string memory symbol,
        string memory name,
        address superToken
    ) private override returns (address token, address bondingCurve) {
        require(msg.sender == owner, 'TF00');
        bool isCreatingSuperToken = superToken == address(0);
        require(isCreatingSuperToken || isSuperToken(superToken), 'TF3B');

        bondingCurve = address(new BondingCurve());
        Token token = new Token(symbol, name, DEFAULT_ERC20_SUPPLY, bondingCurve);
        IBondingCurve(bondingCurve).initialize(address(this), token, isCreatingSuperToken ? nativeToken : superToken, defaultCreationFee, defaultSwapFee, defaultListingFee, defaultListingReward, defaultDonationRate, defaultAmmFactory);

        getBondingCurve[token] = bondingCurve;
        if (isCreatingSuperToken) {
          getSuperToken[token] = token; // Self-reference to mark super token
        } else {
          getSuperToken[token] = superToken;
          getSubTokens[superToken].push(token);
        }
        allTokens.push(pair);

        emit TokenCreated(token, superToken, bondingCurve, allTokens.length);
    }

    function isToken(address superOrSubToken) external view override returns (bool) {
        return getSuperToken[superOrSubToken] != address(0);
    }

    function isSuperToken(address superToken) external view override returns (bool) {
        return superToken != address(0) && getSuperToken[superToken] == superToken;
    }

    function isSubToken(address subToken) external view override returns (bool) {
        address superToken = getSuperToken[subToken];
        return superToken != address(0) && subToken != superToken;
    }

    function meetsListingRequirements(address token0, address token1, uint256 amount0, uint256 amount1) external view override returns (bool) {
      // derive price from amounts only
      if (isSubToken(token0)) {
        // find value of sub token TVL based on super token price
      }

      uint256 tvl = amount1; // amount 1 is always the native token in a super token pairing

      return tvl >= listingThreshold;
    }

    function setOwner(address _owner) external override {
        require(msg.sender == owner, 'TF00');
        require(_owner != owner, 'TF01');
        require(_owner != address(0), 'TF02');
        owner = _owner;

        emit OwnerSet(_owner);
    }

    function setDefaultBondingCurveCreationFee(uint256 _defaultBondingCurveCreationFee) external override {
      require(msg.sender == owner, 'TF00');
      require(_defaultBondingCurveCreationFee != defaultBondingCurveCreationFee, 'TF01');
      defaultBondingCurveCreationFee = _defaultBondingCurveCreationFee;

      emit DefaultBondingCurveCreationFeeSet(_defaultBondingCurveCreationFee);
    }

    function setDefaultBondingCurveSwapFee(uint256 _defaultBondingCurveSwapFee) external override {
      require(msg.sender == owner, 'TF00');
      require(_defaultBondingCurveSwapFee != defaultBondingCurveSwapFee, 'TF01');
      defaultBondingCurveSwapFee = _defaultBondingCurveSwapFee;

      emit DefaultBondingCurveSwapFeeSet(_defaultBondingCurveSwapFee);
    }

    function setDefaultListingFee(uint256 _defaultListingFee) external override {
      require(msg.sender == owner, 'TF00');
      require(_defaultListingFee != defaultListingFee, 'TF01');
      defaultListingFee = _defaultListingFee;

      emit DefaultListingFeeSet(_defaultListingFee);
    } 

    function setDefaultListingReward(uint256 _defaultListingReward) external override {
      require(msg.sender == owner, 'TF00');
      require(_defaultListingReward != defaultListingReward, 'TF01');
      defaultListingReward = _defaultListingReward;

      emit DefaultListingRewardSet(_defaultListingReward);
    }   

    function setDefaultDonationRate(uint256 _defaultDonationRate) external override {
      require(msg.sender == owner, 'TF00');
      require(_defaultDonationRate != defaultDonationRate, 'TF01');
      defaultDonationRate = _defaultDonationRate;

      emit DefaultDonationRateSet(_defaultDonationRate);
    }   

    function setDefaultAmmFactory(address _defaultAmmFactory) external override {
      require(msg.sender == owner, 'TF00');
      require(_defaultAmmFactory != defaultAmmFactory, 'TF01');
      defaultAmmFactory = _defaultAmmFactory;

      emit DefaultAmmFactorySet(_defaultAmmFactory);
    }       
    
    function setBondingCurveCreationFee(address superOrSubToken, uint256 _bondingCurveCreationFee) external override {
      require(msg.sender == owner, 'TF00');
      require(isToken(superOrSubToken), 'TF01');
      getBondingCurve(superOrSubToken).setCreationFee(_bondingCurveCreationFee);
    }
    
    function setBondingCurveSwapFee(address superOrSubToken, uint256 _bondingCurveSwapFee) external override {
      require(msg.sender == owner, 'TF00');
      require(isToken(superOrSubToken), 'TF01');
      getBondingCurve(superOrSubToken).setSwapFee(_bondingCurveSwapFee);
    }
    
    function setListingFee(address superOrSubToken, uint256 _listingFee) external override {
      require(msg.sender == owner, 'TF00');
      require(isToken(superOrSubToken), 'TF01');
      getBondingCurve(superOrSubToken).setListingFee(_listingFee);
    }
    
    function setListingReward(address superOrSubToken, uint256 _listingReward) external override {
      require(msg.sender == owner, 'TF00');
      require(isToken(superOrSubToken), 'TF01');
      getBondingCurve(superOrSubToken).setListingReward(_listingReward);
    }
    
    function setDonationRate(address superOrSubToken, uint256 _donationRate) external override {
      require(msg.sender == owner, 'TF00');
      require(isToken(superOrSubToken), 'TF01');
      getBondingCurve(superOrSubToken).setDonationRate(_donationRate);
    }
    
    function setAmmFactory(address superOrSubToken, address _ammFactory) external override {
      require(msg.sender == owner, 'TF00');
      require(isToken(superOrSubToken), 'TF01');
      require(_ammFactory != address(0), 'TF02');
      getBondingCurve(superOrSubToken).setAmmFactory(_ammFactory);
    }

    function setListingOracle(address superOrSubToken, address listingOracle) external override {
      require(msg.sender == owner, 'TF00');
      require(isToken(superOrSubToken), 'TF01');
      require(listingOracle != address(0), 'TF02');
      getBondingCurve[superOrSubToken].setListingOracle(listingOracle);
    }

    function setListingThreshold(uint256 _listingThreshold) external override {
        require(msg.sender == owner, 'TF00');
        require(_listingThreshold != listingThreshold, 'TF01');
        listingThreshold = _listingThreshold;
    }
}
