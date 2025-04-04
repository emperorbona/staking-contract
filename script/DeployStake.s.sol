// SPDX-License-Identifier:MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {Stake} from "../src/Stake.sol";
import {HelperConfig} from "./HelperConfig.s.sol";   

contract DeployStake is Script{
    
    Stake stake;
    HelperConfig config = new HelperConfig();
    address ethUSDPriceFeed = config.activeNetworkConfig();
    function run() external returns (Stake){
    vm.startBroadcast();
    stake = new Stake(ethUSDPriceFeed);
    vm.stopBroadcast();
    return stake;
    }
}