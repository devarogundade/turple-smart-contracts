// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./../interfaces/IProposals.sol";
import "@openzeppelin/contracts/utils/Context.sol";

abstract contract Proposals is IProposals, Context {
    uint256 private constant VOTE_DENOMINATOR = 100;

    /** @dev 70 percent */
    uint56 private _minVoteRatio = 700;
    uint56 private _minVotes = 2; // for testing

    mapping(uint256 => Proposal) public _proposals;

    enum ProposalState {
        ONGOING,
        APPROVED,
        DISAPPROVED
    }

    struct Proposal {
        bool status;
        address[] approves;
        address[] disapproves;
    }

    function setMinVotes(uint56 newValue) internal virtual {
        _minVotes = newValue;
    }

    event ProposalStatus(uint256 adId, bool newState);

    event ProposalApproved(uint256 adId, address validator);

    event ProposalDisApproved(uint256 adId, address validator);

    function setState(uint256 adId, bool newState) internal virtual {
        _proposals[adId].status = newState;

        emit ProposalStatus(adId, newState);
    }

    /** @dev function to vote up an ads campaign proposal */
    function approve(
        uint256 adId
    ) public virtual override canVote(adId) allowed(adId) {
        address validator = _msgSender();
        _proposals[adId].approves.push(validator);

        emit ProposalApproved(adId, validator);
    }

    /** @dev function to vote down an ads campaign proposal */
    function disapprove(
        uint256 adId
    ) public virtual override canVote(adId) allowed(adId) {
        address validator = _msgSender();
        _proposals[adId].disapproves.push(validator);

        emit ProposalDisApproved(adId, validator);
    }

    /** @dev true means campaign proposal was approved by validators or vice versa */
    function state(uint256 adId) public view virtual returns (ProposalState) {
        uint256 approvesCount = _proposals[adId].approves.length;
        uint256 disApprovesCount = _proposals[adId].disapproves.length;

        if ((approvesCount + disApprovesCount) < _minVotes)
            return ProposalState.ONGOING;

        uint256 voteRatio = ((approvesCount * VOTE_DENOMINATOR) /
            disApprovesCount);

        if (voteRatio >= _minVoteRatio) {
            return ProposalState.APPROVED;
        }

        return ProposalState.DISAPPROVED;
    }

    modifier canVote(uint256 adId) {
        address validator = _msgSender();

        for (
            uint256 index = 0;
            index < _proposals[adId].approves.length;
            index++
        ) {
            if (_proposals[adId].approves[index] == validator) {
                revert();
            }
        }

        for (
            uint256 index = 0;
            index < _proposals[adId].disapproves.length;
            index++
        ) {
            if (_proposals[adId].disapproves[index] == validator) {
                revert();
            }
        }
        _;
    }

    modifier allowed(uint256 adId) {
        if (!_proposals[adId].status) {
            revert();
        }
        _;
    }
}
