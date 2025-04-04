// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {Stake} from "../src/Stake.sol";
import {DeployStake} from "../script/DeployStake.s.sol";

contract StakeTest is Test{
    Stake stake;
    function setUp() external{
        DeployStake deployStake = new DeployStake();
        stake = deployStake.run();

    }
}