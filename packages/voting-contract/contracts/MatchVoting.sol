//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

import "hardhat/console.sol";
import "./Certificate.sol";

contract MatchVoting is Ownable {
    /// Certificate minting contract address
    address public certificateContractAddress;

    address[] public workers;

    uint256 public numberOfWorkers;

    mapping(address => uint256) public workerToIndex;

    string[] public matchInputs;

    struct Voting {
        /// Input match
        string matchInput;
        /// List of all match results with at least one vote
        string[] matches;
        /// Worker address to match result
        mapping(address => string) workerToMatchResult;
        /// Worker address to voted flag
        mapping(address => bool) workerToVoted;
        /// Match result to total vote count
        mapping(string => uint256) matchResultToVoteCount;
        /// Disables voting option after voting end
        bool ended;
        /// Winning match result
        string winningMatch;
        /// Number of votes for winning match
        uint256 winningMatchVoteCount;
        /// If none of the match results gets more votes then the others
        bool noConsensus;
        /// Number of votes in this voting
        uint256 numberOfVotes;
    }

    /// Worker address to match result
    mapping(string => Voting) public matchInputToVoting;

    /// Event emitted after voting ended
    event WinningMatch(
        string indexed matchInput,
        string indexed matchResult,
        uint256 indexed voteCount
    );

    /// Winning match result did not reach more than a half of total votes
    event VotingRestarted(string matchInput);

    /// Worker had already voted for a match result
    error AlreadyVoted();

    /// Sender is not whitelisted
    error NotWhitelisted();

    /// Voting ended, winner is chosen - workers cannot vote anymore
    error VotingAlreadyEnded();

    /// Worker has been added already
    error WorkerAlreadyAdded();

    /// Worker has not been added yet
    error WorkerWasNotAdded();

    constructor(address _certificateContractAddress) {
        certificateContractAddress = _certificateContractAddress;
    }

    function vote(string memory matchInput, string memory matchResult)
        external
    {
        if (!isWorker(msg.sender)) {
            revert NotWhitelisted();
        }

        Voting storage voting = matchInputToVoting[matchInput];
        if (bytes(voting.matchInput).length == 0) {
            voting.matchInput = matchInput;
            matchInputs.push(matchInput);
        }

        if (voting.ended) {
            revert VotingAlreadyEnded();
        }

        if (voting.workerToVoted[msg.sender]) {
            revert AlreadyVoted();
        }

        voting.workerToMatchResult[msg.sender] = matchResult;
        voting.workerToVoted[msg.sender] = true;
        voting.numberOfVotes += 1;

        if (voting.matchResultToVoteCount[matchResult] == 0) {
            voting.matches.push(matchResult);
        }

        voting.matchResultToVoteCount[matchResult] += 1;

        if (
            voting.matchResultToVoteCount[matchResult] ==
            voting.winningMatchVoteCount
        ) {
            voting.noConsensus = true;
        } else if (
            voting.matchResultToVoteCount[matchResult] >
            voting.winningMatchVoteCount
        ) {
            voting.winningMatchVoteCount = voting.matchResultToVoteCount[
                matchResult
            ];
            voting.winningMatch = matchResult;
            voting.noConsensus = false;

            if (voting.winningMatchVoteCount >= majority()) {
                completeVoting(voting);
            }
        }

        if (voting.numberOfVotes == numberOfWorkers) {
            completeVoting(voting);
        }
    }

    function getWinningMatch(string memory matchInput)
        public
        view
        returns (string memory)
    {
        return matchInputToVoting[matchInput].winningMatch;
    }

    function numberOfMatchInputs() public view returns (uint256) {
        return matchInputs.length;
    }

    function addWorker(address workerAddress) external onlyOwner {
        if (isWorker(workerAddress)) {
            revert WorkerAlreadyAdded();
        }
        workerToIndex[workerAddress] = workers.length;
        workers.push(workerAddress);
        numberOfWorkers = workers.length;
    }

    function removeWorker(address workerAddress) external onlyOwner {
        if (!isWorker(workerAddress)) {
            revert WorkerWasNotAdded();
        }
        uint256 workerIndex = workerToIndex[workerAddress];
        // Delete the worker
        delete workers[workerIndex];
        // @todo change index of this worker
        // Copy last element to fill the missing place in array
        workers[workerIndex] = workers[workers.length - 1];
        // Delete last element
        delete workers[workers.length - 1];
        numberOfWorkers = numberOfWorkers - 1;
    }

    function getWorkerVote(string memory matchInput, address workerAddress)
        external
        view
        returns (string memory matchResult)
    {
        return
            matchInputToVoting[matchInput].workerToMatchResult[workerAddress];
    }

    function completeVoting(Voting storage voting) private {
        if (voting.noConsensus) {
            restartVoting(voting);
            return;
        }

        if (certificateContractAddress != address(0)) {
            ICertificate(certificateContractAddress).mint(
                voting.matchInput,
                voting.winningMatch
            );
        }

        emit WinningMatch(
            voting.matchInput,
            voting.winningMatch,
            voting.winningMatchVoteCount
        );
        voting.ended = true;
    }

    /// @notice Check if this account allowed to vote
    function isWorker(address workerAddress) public view returns (bool) {
        return
            workerToIndex[workerAddress] != 0 ||
            (workers.length > 0 && workers[0] == workerAddress);
    }

    /// @notice Number of votes sufficient to determine match winner
    function majority() public view returns (uint256) {
        return (workers.length / 2) + 1;
    }

    /// @notice When consensus is not reached voting is restarted
    function restartVoting(Voting storage voting) private {
        delete voting.matches;
        for (uint256 i = 0; i < workers.length; i++) {
            voting.matchResultToVoteCount[
                voting.workerToMatchResult[workers[i]]
            ] = 0;
            voting.workerToVoted[workers[i]] = false;
            voting.workerToMatchResult[workers[i]] = "";
        }
        voting.ended = false;
        voting.winningMatch = "";
        voting.winningMatchVoteCount = 0;
        voting.noConsensus = false;
        voting.numberOfVotes = 0;

        emit VotingRestarted(voting.matchInput);
    }
}
