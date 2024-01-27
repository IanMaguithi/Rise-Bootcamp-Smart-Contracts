// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract ProposalContract {
    address public owner; // owner of the contract
    uint256 private counter; // keeps track of the ids of the proposals

    constructor() {
        owner = msg.sender;
        voted_addresses.push(msg.sender);
    }

    /**
    modifier to ensure that only the owner of the contract can call the function
     */
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    /**
    modifier o check if the proposal is active
     */
    modifier active() {
        require(
            proposal_history[counter].is_active == true,
            "The proposal is not active"
        );
        _;
    }

    /**
    modifier to check if an address has already voted
     */
    modifier newVoter(address _address) {
        require(!isVoted(_address), "The address has already voted");
        _;
    }

    struct Proposal {
        string title; // brief title of the proposal
        string description; // short description of the proposal
        uint256 approve; // number of approvals for the proposal
        uint256 reject; // number of rejections for the proposal
        uint256 pass; // number of pass votes
        uint256 total_vote_to_end; // when the total votes in the proposal reaches this limit, proposal ends
        bool current_state; // shows if the proposal passes or fails
        bool is_active; // shows if the proposal is active, others can vote, or not
    }

    mapping(uint256 => Proposal) public proposal_history; // Recordings of all proposals

    address[] public voted_addresses; // list of all voters

    /** 
    Function to create the proposal
    */
    function createProposal(
        string calldata _title,
        string calldata _description,
        uint256 _total_vote_to_end
    ) external onlyOwner {
        counter++;
        proposal_history[counter] = Proposal(
            _title,
            _description,
            0,
            0,
            0,
            _total_vote_to_end,
            false,
            true
        );
    }

    /**
    Function to transfer ownership of the contract
     */
    function setOwner(address _newOwner) external onlyOwner {
        owner = _newOwner;
    }

    /**
    Function to vote on the proposal

    params:
    choice: 0 for pass, 1 for approve, 2 for reject
     */
    function vote(uint8 choice) external active newVoter(msg.sender){
        Proposal storage proposal = proposal_history[counter];
        uint256 total_votes = proposal.approve +
            proposal.reject +
            proposal.pass;

        voted_addresses.push(msg.sender); // add the address to the list of voters

        if (choice == 1) {
            proposal.approve++;
            proposal.current_state = calculateCurrentState();
        } else if (choice == 2) {
            proposal.reject++;
            proposal.current_state = calculateCurrentState();
        } else if (choice == 0) {
            proposal.pass++;
            proposal.current_state = calculateCurrentState();
        }

        if (
            (proposal.total_vote_to_end - total_votes == 1) &&
            (choice == 1 || choice == 2 || choice == 0)
        ) {
            proposal.is_active = false;
            voted_addresses = [owner];
        }
    }

    function calculateCurrentState() private view returns(bool){
        Proposal storage proposal = proposal_history[counter];
        uint256 total_votes = proposal.approve +
            proposal.reject +
            proposal.pass;
        uint256 total_approve = proposal.approve + proposal.pass;
        uint256 total_reject = proposal.reject + proposal.pass;

        if (total_votes >= proposal.total_vote_to_end) {
            if (total_approve > total_reject) {
                return true;
            } else {
                return false;
            }
        } else {
            return proposal.current_state;
        }
    }

    function terminateProposal() external onlyOwner active {
        proposal_history[counter].is_active = false;
    }

    function isVoted(address _address) public view returns (bool) {
        for (uint i=0; i<voted_addresses.length; i++) {
            if (voted_addresses[i] == _address) {
                return true;
            }
        }
        return false;
    }

    function getCurrentProposal() external view returns (Proposal memory) {
        return proposal_history[counter];
    }

    function getProposal(uint256 number) external view returns(Proposal memory){
        return proposal_history[number];
    }
}
