// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "forge-std/Script.sol";
import {TechCrushToken} from "../src/TechCrushVoteToken.sol";
import {SimpleVoting} from "../src/SimpleVoting.sol";



contract Deploy is Script {
    function run() external {
        uint256 deployerKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerKey);



        TechCrushToken token = new TechCrushToken();
        new SimpleVoting(address(token));

        vm.stopBroadcast();
    }
}
