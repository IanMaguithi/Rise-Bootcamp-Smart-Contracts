// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract ProposalContract{
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
}