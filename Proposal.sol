// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract ProposalContract{
    uint256 private counter; // keeps track of the ids of the proposals
    struct Proposal{
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

    function createProposal(string calldata _title,string calldata _description, uint256 _total_vote_to_end) external{
        counter++;
        proposal_history[counter] = Proposal(_title, _description, 0, 0, 0, _total_vote_to_end, false, true);
    }
}