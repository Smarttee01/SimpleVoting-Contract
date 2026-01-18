// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "forge-std/Test.sol";
import {TechCrushToken} from "../src/TechCrushVoteToken.sol";
import {SimpleVoting} from "../src/SimpleVoting.sol";


contract SimpleVotingTest is Test {
    TechCrushToken token;
    SimpleVoting voting;

    address alice = address(1);
    address bob = address(2);

    function setUp() public {
        token = new TechCrushToken();
        voting = new SimpleVoting(address(token));

        token.transfer(alice, 100e18);
        token.transfer(bob, 100e18);
    }

    function testCreateElection() public {
        string[] memory cands = new string[](2);
        cands[0] = "PDP";
        cands[1] = "APC";

        voting.createElection("Nigeria Votes", cands, 1 days);
        (,,bool active) = voting.election();
        assertTrue(active);
    }

    function testVote() public {
        string[] memory cands = new string[](2);
        cands[0] = "PDP";
        cands[1] = "APC";

        voting.createElection("Nigeria Votes", cands, 1 days);

        vm.prank(alice);
        voting.vote(0);

        assertEq(voting.getResults(0), 1);
    }

    function testCannotVoteTwice() public {
        string[] memory cands = new string[](2);
        cands[0] = "PDP";
        cands[1] = "APC";

        voting.createElection("Nigeria Votes", cands, 1 days);

        vm.startPrank(alice);
        voting.vote(0);
        vm.expectRevert();
        voting.vote(0);
        vm.stopPrank();
    }

    function testWinner() public {
        string[] memory cands = new string[](2);
        cands[0] = "PDP";
        cands[1] = "APC";

        voting.createElection("Nigeria Votes", cands, 1 days);

        vm.prank(alice);
        voting.vote(1);

        vm.prank(bob);
        voting.vote(1);

        assertEq(voting.getWinner(), "APC");
    }
}