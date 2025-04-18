// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {PriceConverter} from "./PriceConverter.sol";
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
contract Stake {
    using PriceConverter for uint256;

    AggregatorV3Interface public s_priceFeed;
    error Not__Enough__Stake();
    error YouHaveNoStake();
    error StakingTimeNotYetPassed();
    error callFailed();

    constructor(address priceFeed){
        s_priceFeed =AggregatorV3Interface(priceFeed); 
    }

    struct StakeData{
        uint256 amountStaked;
        address stakerAddress;
        uint256 stakeTime;
    }
    mapping (address => uint256) public s_addressToAmountStaked;
    StakeData[] private s_stakers;
    uint256 private constant MINIMUM_STAKE_TIME = 5 minutes;
    uint256 private constant MINIMUM_USD = 1e18;

    function stakeFunds() public payable{
        // require(msg.value.getConversionRate(s_priceFeed) >= MINIMUM_USD, "You must stake above $1 worth of ETH");
        if(msg.value.getConversionRate(s_priceFeed) < MINIMUM_USD){
            revert Not__Enough__Stake();
        } 
        s_addressToAmountStaked[msg.sender] += msg.value;
        StakeData memory newStakeData = StakeData({
            amountStaked: msg.value,
            stakerAddress: msg.sender,
            stakeTime: block.timestamp

        });
        s_stakers.push(newStakeData);
    }
    function getVersion() public view returns (uint256) {
        return s_priceFeed.version();
    }
    
    function withdraw() public {
        // require(s_addressToAmountStaked[msg.sender] > 0, "You have no stake");
        if (s_addressToAmountStaked[msg.sender] < 0) {
            revert YouHaveNoStake(); 
        }
        uint256 stakersLength = s_stakers.length;
        for (uint256 i = 0; i < stakersLength; i++){
            if (s_stakers[i].stakerAddress == msg.sender) {
                StakeData memory userStake = s_stakers[i];

                // require(block.timestamp >= userStake.stakeTime + MINIMUM_STAKE_TIME,
                // "Staking time not yet passed"
                // );
                if (block.timestamp < userStake.stakeTime + MINIMUM_STAKE_TIME) {
                   revert StakingTimeNotYetPassed(); 
                }

                uint256 totalAmount = userStake.amountStaked;

                s_addressToAmountStaked[msg.sender] =0;

                userStake = s_stakers[stakersLength - 1];
                s_stakers.pop();

                (bool callSuccess,) = payable(msg.sender).call{value: totalAmount}("");
                  if(!callSuccess){
                    revert callFailed();
                 }
                 break;
            }
        }
    }
    function getStakers(uint256 index) external view returns(StakeData memory) {
            return s_stakers[index];
    }  
    function getAddressToAmountStaked(address stakerAddress) external view returns(uint256){
        return s_addressToAmountStaked[stakerAddress];
    }

    function getMinimumUSD() external pure returns(uint256){
        return MINIMUM_USD;
    }

     function getMinimumStakeTime() external pure returns(uint256){
        return MINIMUM_STAKE_TIME;
    }

   
   
}