// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28


import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract BoxV2 is UUPSUpgradeable, Initializable, OwnableUpgradeable {
   uint256 internal number;

    constructor() {
         _disableInitializers();
    }

    function initialize() public initializer {
        __Ownable_init();
        __UUPSUpgradeable_init();
    }

   function setNumber(uint256 _number) external {
       number = _number;
   }

   function getNumber() external view returns (uint256) {
       return number;
   }

   function version() external pure returns (string memory) {
       return "2.0";
   }

   function _authorizeUpgrade(address newImplementation) internal override {
       require(msg.sender == owner(), "Only owner can upgrade");
   }
}