// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

// Import OpenZeppelin contracts
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

contract WeightedVoting is ERC20 {
    using EnumerableSet for EnumerableSet.AddressSet;

    // Max supply of tokens
    uint256 public maxSupply = 1_000_000;

    // Custom errors
    error TokensClaimed();
    error AllTokensClaimed();
    error NoTokensHeld();
    error QuorumTooHigh(uint256 quorum);
    error AlreadyVoted();
    error VotingClosed();

    // Enum for voting options
    enum Vote { AGAINST, FOR, ABSTAIN }

    // Issue struct
    struct Issue {
        // The unit tests require this struct to be constructed with variables in this specific order
        EnumerableSet.AddressSet voters; // Must be first
        string issueDesc;
        uint256 votesFor;
        uint256 votesAgainst;
        uint256 votesAbstain;
        uint256 totalVotes;
        uint256 quorum;
        bool passed;
        bool closed;
    }

    // Array of issues (made private due to internal types)
    Issue[] private issues;

    // Mapping to track if an address has claimed tokens
    mapping(address => bool) private hasClaimed;

    // Constructor
    constructor() ERC20("WeightedVotingToken", "WVT") {
        // Burn the zeroeth element of issues by pushing an empty Issue
        issues.push();
    }

    // Claim function
    function claim() public {
        // Check if the caller has already claimed
        if (hasClaimed[msg.sender]) {
            revert TokensClaimed();
        }

        // Check if all tokens have been claimed
        if (totalSupply() + 100 > maxSupply) {
            revert AllTokensClaimed();
        }

        hasClaimed[msg.sender] = true;

        // Mint 100 tokens to the caller
        _mint(msg.sender, 100);
    }

    // Create Issue function
    function createIssue(string calldata _issueDesc, uint256 _quorum) external returns (uint256) {
        // Only token holders can create issues
        if (balanceOf(msg.sender) == 0) {
            revert NoTokensHeld();
        }

        // Issues cannot have a quorum greater than the total number of tokens minted
        if (_quorum > totalSupply()) {
            revert QuorumTooHigh(_quorum);
        }

        // Create a new issue
        Issue storage newIssue = issues.push();
        newIssue.issueDesc = _issueDesc;
        newIssue.quorum = _quorum;

        // Return the index of the newly created issue
        return issues.length - 1;
    }

    // Get Issue function
    struct IssueData {
        address[] voters;
        string issueDesc;
        uint256 votesFor;
        uint256 votesAgainst;
        uint256 votesAbstain;
        uint256 totalVotes;
        uint256 quorum;
        bool passed;
        bool closed;
    }

    function getIssue(uint256 _id) external view returns (IssueData memory) {
        // Check if the issue exists
        require(_id > 0 && _id < issues.length, "InvalidIssueId");

        Issue storage issue = issues[_id];

        // Convert the EnumerableSet to an address array
        address[] memory votersArray = new address[](issue.voters.length());
        for (uint256 i = 0; i < issue.voters.length(); i++) {
            votersArray[i] = issue.voters.at(i);
        }

        return IssueData({
            voters: votersArray,
            issueDesc: issue.issueDesc,
            votesFor: issue.votesFor,
            votesAgainst: issue.votesAgainst,
            votesAbstain: issue.votesAbstain,
            totalVotes: issue.totalVotes,
            quorum: issue.quorum,
            passed: issue.passed,
            closed: issue.closed
        });
    }

    // Function to get the total number of issues
    function getIssuesCount() external view returns (uint256) {
        return issues.length;
    }

    // Vote function
    function vote(uint256 _issueId, Vote _vote) public {
        // Check if the issue exists
        require(_issueId > 0 && _issueId < issues.length, "InvalidIssueId");

        Issue storage issue = issues[_issueId];

        // Check if the issue is closed
        if (issue.closed) {
            revert VotingClosed();
        }

        // Check if the voter has already voted on this issue
        if (issue.voters.contains(msg.sender)) {
            revert AlreadyVoted();
        }

        uint256 voterTokens = balanceOf(msg.sender);

        // Check if the voter holds any tokens
        if (voterTokens == 0) {
            revert NoTokensHeld();
        }

        // Add the voter to the set of voters
        issue.voters.add(msg.sender);

        // Update votes based on the voter's choice
        if (_vote == Vote.FOR) {
            issue.votesFor += voterTokens;
        } else if (_vote == Vote.AGAINST) {
            issue.votesAgainst += voterTokens;
        } else if (_vote == Vote.ABSTAIN) {
            issue.votesAbstain += voterTokens;
        }

        // Update total votes
        issue.totalVotes += voterTokens;

        // Check if the quorum has been reached
        if (issue.totalVotes >= issue.quorum) {
            issue.closed = true;
            // Determine if the issue has passed
            if (issue.votesFor > issue.votesAgainst) {
                issue.passed = true;
            }
        }
    }
}
