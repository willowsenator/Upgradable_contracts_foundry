// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {Script} from "forge-std/Script.sol";
import {BoxV2} from "../src/BoxV2.sol";
import {BoxV1} from "../src/BoxV1.sol";

import {DevOpsTools} from "foundry-devops/DevOpsTools.sol";

contract UpgradeBox is Script {
    function run() external returns (address) {
        address proxy = deployBox();
        return proxy;
    }

    function deployBox() public returns (address) {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("ERC1967Proxy", block.chainid);
        vm.startBroadcast();
        BoxV2 newBox = new BoxV2();
        vm.stopBroadcast();

        address proxy = upgradeBox(mostRecentlyDeployed, address(newBox));
        return proxy;
    }

    function upgradeBox(address proxy, address newImplementation) public returns (address) {
        vm.startBroadcast();
        BoxV1 proxyContract = BoxV1(proxy);
        proxyContract.upgradeToAndCall(newImplementation, ""); // proxy contract now points to newImplementation
        vm.stopBroadcast();
        return address(proxyContract);
    }
}
