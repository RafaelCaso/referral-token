// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import {RefToken} from "./RefToken.sol";

//@notice this is a demonstration of a referral contract. Users can refer other users and receive tokens as rewards. This contract has not been optimized or audited (or any serious consideration given to security). It is purely for demonstration
contract Referral is Ownable {
    // @notice refToken is a basic ERC20 used for rewards
    RefToken public refToken;

    // @notice mapping to track how many referrals an address has
    // @dev referralCount will be used to distribute rewards
    mapping(address => uint256) public referralCount;
    // @notice mapping to track who referred an address
    mapping(address => address) public referrerOf; // Tracks referrer for each user
    // @notice mapping to show if an address has already been referred
    // @dev this is used to prevent people from referring the same address
    mapping(address => bool) public hasBeenReferred;

    // Event emitted when address is referred
    event ReferralRegistered(address indexed user, address indexed referrer);
    // Event emitted when referrer collects rewards for referrals
    event RewardDistributed(address indexed referrer, uint256 amount);

    // @notice Owner currently set to deployer. Advisable to transfer ownership directly after deploying for easier testing
    constructor() Ownable(msg.sender) {
        // @dev RefToken takes two arguments; Owner and InitialSupply
        // we set this contract to be the owner so it can dispense tokens
        // and set 100,000,000 as initial supply (arbitrary number for testing)
        refToken = new RefToken(address(this), 100000000 * (10**18));
    }

    // @dev distribute rewards currently takes an argument _rewardAmount for testing purposes. This variable should be a hardcoded private variable or function should be set to onlyOwner for dynamic pricing 
    function distributeRewards(address _to, uint256 _rewardAmount) external {
        // @notice check for referrals ad multiply by reward amount before resetting to 0
        // so user is not rewarded twice for the same referrals
        require(referralCount[_to] > 0, "No referrals to reward");
        uint256 totalReward = referralCount[_to] * _rewardAmount;
        referralCount[_to] = 0;
        bool sent = refToken.mint(_to, totalReward);
        require(sent, "unable to send tokens. Please try again");
        emit RewardDistributed(_to, totalReward);   
    }


    function registerUser(address referredAddress) external {
        require(referredAddress != msg.sender, "Cannot refer yourself");
        require(!isContract(msg.sender), "Referrer is not a valid address");
        require(!isContract(referredAddress), "Cannot refer a contract");
        require(!hasBeenReferred[referredAddress], "User has already been referred");
        hasBeenReferred[referredAddress] = true;

        referrerOf[referredAddress] = msg.sender;
        referralCount[msg.sender] += 1;

        emit ReferralRegistered(referredAddress, msg.sender);
    }


  //@notice this is standard check for opcode but DOES NOT prevent someone from 
  // registering dummy accounts (for example, Hardhat dummy accounts can be registered)
  //@dev this method was included to fulfill a requirement for project but ONLY checks if argument is a contract. In production, there should be a check that the provided address exists inside of a mapping associated with parent company
  // if extcodesize is greater than zero, it is a contract
  function isContract(address _addr) private view returns (bool isContractAddress){
    uint32 size;
    assembly {
      size := extcodesize(_addr)
    }
    return (size > 0);
  }
}
