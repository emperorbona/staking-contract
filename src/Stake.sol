// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {PriceConverter} from "./PriceConverter.sol";
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
contract Stake {
    using PriceConverter for uint256;

    AggregatorV3Interface public s_priceFeed;

    constructor(address priceFeed){
        s_priceFeed =AggregatorV3Interface(priceFeed); 
    }

    struct StakeData{
        uint256 amountStaked;
        address stakerAddress;
        uint256 stakeTime;
    }
    mapping (address => uint256) public addressToAmountStaked;
    StakeData[] public stakers;
    uint256 constant MINIMUM_STAKE_TIME = 5 minutes;

    function stakeFunds() public payable{
        require(msg.value.getConversionRate(s_priceFeed) >= 1e18, "You must stake above $1 worth of ETH");
        addressToAmountStaked[msg.sender] += msg.value;
        StakeData memory newStakeData = StakeData({
            amountStaked: msg.value,
            stakerAddress: msg.sender,
            stakeTime: block.timestamp

        });
        stakers.push(newStakeData);
    }
    
    function withdraw() public {
        require(addressToAmountStaked[msg.sender] > 0, "You have no stake");
        uint256 stakersLength = stakers.length;
        for (uint256 i = 0; i < stakersLength; i++){
            if (stakers[i].stakerAddress == msg.sender) {
                StakeData memory userStake = stakers[i];

                require(block.timestamp >= userStake.stakeTime + MINIMUM_STAKE_TIME,
                "Staking time not yet passed"
                );

                uint256 totalAmount = userStake.amountStaked;

                addressToAmountStaked[msg.sender] =0;

                userStake = stakers[stakersLength - 1];
                stakers.pop();

                (bool callSuccess,) = payable(msg.sender).call{value: totalAmount}("");
                 require(callSuccess, "Call failed");
                 break;
            }
        }
    }
        
   
}