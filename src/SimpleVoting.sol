// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "openzeppelin-contracts/contracts/access/Ownable.sol";
import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

contract SimpleVoting is Ownable {
    IERC20 public voteToken;

    struct Election {
        string title;
        string[] candidates;
        uint256 endTime;
        bool active;
    }

    Election public election;

    mapping(uint256 => uint256) public votes;
    mapping(address => bool) public hasVoted;
    uint256 public electionId;

    event ElectionCreated(string title, uint256 endTime);
    event Voted(address voter, uint256 candidate);
    event ElectionClosed();

    constructor(address _token) Ownable(msg.sender) {
        require(_token != address(0), "Invalid token");
        voteToken = IERC20(_token);
    }

    // ---------------- OWNER ----------------

    function createElection(string memory _title, string[] memory _candidates, uint256 _duration) external onlyOwner {
        require(!election.active, "Election running");
        require(_candidates.length > 0, "Need candidates");

        delete election.candidates;
        electionId++;

        for (uint256 i = 0; i < _candidates.length; i++) {
            election.candidates.push(_candidates[i]);
        }

        election.title = _title;
        election.endTime = block.timestamp + _duration;
        election.active = true;

        emit ElectionCreated(_title, election.endTime);
    }

    // ---------------- USER ----------------

    function vote(uint256 candidateIndex) external {
        require(election.active, "No election");
        require(block.timestamp < election.endTime, "Voting ended");
        require(!hasVoted[msg.sender], "Already voted");
        require(candidateIndex < election.candidates.length, "Bad index");
        require(voteToken.balanceOf(msg.sender) > 0, "Need tokens");

        hasVoted[msg.sender] = true;
        votes[candidateIndex]++;

        emit Voted(msg.sender, candidateIndex);
    }

    // ---------------- VIEW ----------------

    function getResults(uint256 index) external view returns (uint256) {
        return votes[index];
    }

    function getWinner() external view returns (string memory winnerName) {
        require(election.candidates.length > 0, "No candidates");

        uint256 highest;
        uint256 winnerIndex;

        for (uint256 i = 0; i < election.candidates.length; i++) {
            if (votes[i] > highest) {
                highest = votes[i];
                winnerIndex = i;
            }
        }

        return election.candidates[winnerIndex];
    }

    function hasUserVoted(address user) external view returns (bool) {
        return hasVoted[user];
    }

    function closeElection() external onlyOwner {
        require(election.active, "Not active");
        election.active = false;
        emit ElectionClosed();
    }
}
