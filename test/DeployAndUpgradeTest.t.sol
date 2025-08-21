// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {Test} from "forge-std/Test.sol";
import {DeployBox} from "../script/DeployBox.s.sol";
import {UpgradeBox} from "../script/UpgradeBox.s.sol";
import {BoxV1} from "../src/BoxV1.sol";
import {BoxV2} from "../src/BoxV2.sol";

contract DeployAndUpgradeTest is Test {
    // This contract is used to test the deployment and upgrade of BoxV1 and BoxV2 contracts.
    // It includes functions to deploy the initial version and upgrade to the new version.

    // The actual deployment and upgrade logic is handled in the scripts: DeployBox.s.sol and UpgradeBox.s.sol.
    // The tests will ensure that the upgrade process works as expected.

    DeployBox public deployBox;
    UpgradeBox public upgradeBox;
    address public owner = makeAddr("owner");

    address public proxy;

    function setUp() public {
        deployBox = new DeployBox();
        upgradeBox = new UpgradeBox();

        proxy = deployBox.run();
    }

    function testProxyStartsAsBoxV1() public {
        string memory expectedVersion = "1.0";

        assertEq(expectedVersion, BoxV1(proxy).version(), "Version should be 1.0 on initial deployment");
        assertEq(0, BoxV1(proxy).getNumber(), "Initial number should be 0");

        vm.expectRevert();
        BoxV2(proxy).setNumber(7);
    }

    function testUpgrades() public {
        vm.prank(owner);
        BoxV2 box2 = new BoxV2();

        proxy = upgradeBox.upgradeBox(proxy, address(box2));

        string memory expectedVersion = "2.0";

        assertEq(expectedVersion, BoxV2(proxy).version(), "Version should be 2.0 after upgrade");

        BoxV2(proxy).setNumber(7);
        assertEq(7, BoxV2(proxy).getNumber(), "Number should be 7 after setting");
    }
}
