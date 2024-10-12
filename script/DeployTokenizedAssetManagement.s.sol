// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import {TokenizedAssetManagement} from "../src/TokenizedAssetManagement.sol";
import {Script, console} from "forge-std/Script.sol";

contract DeployTokenizedAssetManagement is Script {
    function run() external returns (TokenizedAssetManagement) {
        vm.startBroadcast();
        TokenizedAssetManagement tokenizedAssetManagement = new TokenizedAssetManagement();
        console.log("Deployed at: ", address(tokenizedAssetManagement));
        vm.stopBroadcast();
        return tokenizedAssetManagement;
    }
}