// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {Stake} from "../src/Stake.sol";
import {DeployStake} from "../script/DeployStake.s.sol";




contract StakeTest is Test{
    address USER = makeAddr("user");
    uint256  constant STARTING_BALANCE = 10 ether;
    uint256 public constant SEND_VALUE = 0.1 ether;
    address NOTUSER = makeAddr("notuser");

    Stake stake;
    function setUp() external{
        DeployStake deployStake = new DeployStake();
        stake = deployStake.run();
        vm.deal(USER, STARTING_BALANCE);

    }
    function testMinimumUSDIsOne() public view{
        assertEq(stake.MINIMUM_USD(), 1e18);
    }
    function testMinimumStakeTimeIsFive() public view{
        assertEq(stake.MINIMUM_STAKE_TIME(), 5 minutes);
    }
    function testPriceFeedVersionIsAccurate() public view{
         assertEq(stake.getVersion(), 4);  
     }

     function testFundFailsWithoutEnoughEth() public{
        vm.expectRevert();
        stake.stakeFunds();
     }

     modifier funded{
        vm.prank(USER);
        stake.stakeFunds{value:SEND_VALUE}();
        _;
     }

     function testStakeFundsUpdatesFundedDataStructure() public funded{
        uint256 amountStaked = stake.getAddressToAmountStaked(USER);
        assertEq(amountStaked, SEND_VALUE);

     }
     function testAddsStakerToArrayOfStakers() public funded{
        
        Stake.StakeData memory stakers = stake.getStakers(0);
        assertEq(stakers.amountStaked, SEND_VALUE);
        assertEq(stakers.stakerAddress, USER);
        assertEq(stakers.stakeTime, block.timestamp);

     }
      function testOnlyStakerCanWithdraw() public funded{

        vm.prank(USER);
        vm.expectRevert();
        stake.withdraw();
     }
     function testWithdrawWithASingleStaker() public funded {
 
    // fast forward time so stakeTime + 5 mins has passed
    vm.warp(block.timestamp + 5 minutes + 1);

    uint256 startingOwnerBalance = USER.balance;
    uint256 startingStakeBalance = address(stake).balance;

    vm.prank(USER); 
    stake.withdraw();

    uint256 endingOwnerBalance = USER.balance;
    uint256 endingStakeBalance = address(stake).balance;

    assertEq(endingStakeBalance, 0);
    assertEq(endingOwnerBalance, startingOwnerBalance + startingStakeBalance);
}


}