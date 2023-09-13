// SPDX-License-Identifier: MIT

// Solidity version
pragma solidity ^0.8.18;

// Importing required contracts and libraries
import {DeployRaffle} from "../../script/DeployRaffle.s.sol"; // Contract to deploy Raffle
import {Raffle} from "../../src/Raffle.sol"; // Raffle contract
import {Test, console} from "../../lib/forge-std/src/Test.sol";
import {Vm} from "../../lib/forge-std/src/Vm.sol";
import {VRFCoordinatorV2Mock} from "../../lib/chainlink-brownie-contracts/contracts/src/v0.8/mocks/VRFCoordinatorV2Mock.sol";
import {StdCheats} from "../../lib/forge-std/src/StdCheats.sol";
import {HelperConfig} from "../../script/HelperConfig.s.sol"; // HelperConfig contract
import {CreateSubscription} from "../../script/interactions.s.sol";

// RaffleTest contract inheriting from Test contract
contract RaffleTest is StdCheats, Test {
    // events
    event EnteredRaffle(address indexed player);

    Raffle public raffle;
    HelperConfig public helperConfig;

    // State variables
    uint64 subscriptionId;
    bytes32 gasLane;
    uint256 automationUpdateInterval;
    uint256 raffleEntranceFee;
    uint32 callbackGasLimit;
    address vrfCoordinatorV2;
    // not in original below
    address link;
    uint256 deployerKey;

    address public PLAYER = makeAddr("player");
    uint256 public constant STARTING_USER_BALANCE = 10 ether;

    function setUp() external {
        DeployRaffle deployer = new DeployRaffle();
        (raffle, helperConfig) = deployer.run();
        vm.deal(PLAYER, STARTING_USER_BALANCE);

        (
            subscriptionId,
            gasLane,
            automationUpdateInterval,
            raffleEntranceFee,
            callbackGasLimit,
            vrfCoordinatorV2,
            link,
            deployerKey
        ) = helperConfig.activeNetworkConfig();
    }

    function testRaffleInitializesInOpenState() public view {
        assert(raffle.getRaffleState() == Raffle.RaffleState.OPEN);
    }

    //////////////////////
    // enterRaffle      //
    //////////////////////
    function testRaffleRevertsWhenYouDontPayEnough() public {
        vm.prank(PLAYER);
        vm.expectRevert(Raffle.Raffle_NotEnoughEthSent.selector);
        raffle.enterRaffle();
    }

    function testRaffleRecordsPlayerWhenTheyEnter() public {
        // Arrange
        vm.prank(PLAYER);
        raffle.enterRaffle{value: raffleEntranceFee}();
        // Assert
        address playerRecorded = raffle.getPlayer(0);
        assert(playerRecorded == PLAYER);
    }

    function testEmitsEventOnEntrance() public {
        vm.prank(PLAYER);
        vm.expectEmit(true, false, false, false, address(raffle));
        emit EnteredRaffle(PLAYER);
        raffle.enterRaffle{value: raffleEntranceFee}();
    }
}
