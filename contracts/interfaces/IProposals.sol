// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

interface IProposals {
    function approve(uint256 proposalId) external;

    function disapprove(uint256 proposalId) external;
}
