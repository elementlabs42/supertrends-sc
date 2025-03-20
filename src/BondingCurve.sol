import {IBondingCurve} from "./Interfaces/iBondingCurve.sol";

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

    constructor() {
        owner = msg.sender;

        emit OwnerSet(msg.sender);
    }

    function initialize(address token, address superToken, uint256 _creationFee, uint256 _swapFee, uint256 _listingFee, uint256 _listingReward, uint256 _donationRate, address _ammFactory) external {
        token0 = token;
        token1 = superToken;
        creationFee = _creationFee;
        swapFee = _swapFee;
        listingFee = _listingFee;
        listingReward = _listingReward;
        donationRate = _donationRate;
        ammFactory = _ammFactory;
    }

    function setOwner(address _owner) external override {
        require(msg.sender == owner, 'TF00');
        require(_owner != owner, 'TF01');
        require(_owner != address(0), 'TF02');
        owner = _owner;
        emit OwnerSet(_owner);
    }
}