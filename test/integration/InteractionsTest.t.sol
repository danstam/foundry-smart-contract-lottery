// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {DeployRaffle} from "../../script/DeployRaffle.s.sol";
import {Raffle} from "../../src/Raffle.sol";
import {HelperConfig} from "../../script/HelperConfig.s.sol";

contract DeployRaffleTest is Test {
    DeployRaffle deployer;
    Raffle raffle;
    HelperConfig helperConfig;

    function setUp() public {
        deployer = new DeployRaffle();
        (raffle, helperConfig) = deployer.run();
    }

    function testContractsDeployment() public view {
        assert(address(raffle) != address(0));
        assert(address(helperConfig) != address(0));
    }
}
