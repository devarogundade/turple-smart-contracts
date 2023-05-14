// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./TurpleToken.sol";

import "./nodes/ValidatorNode.sol";
import "./nodes/PublisherNode.sol";
import "./nodes/AdvertiserNode.sol";

import "@openzeppelin/contracts/access/Ownable2Step.sol";

contract TurpleCore is
    ValidatorNode,
    PublisherNode,
    AdvertiserNode,
    Ownable2Step
{
    TurpleToken private _turpleTorken;

    constructor(address turfleTorken) Ownable2Step() {
        _turpleTorken = TurpleToken(turfleTorken);
    }

    // ========== Advertisers Functions =========== //

    function fundAd(uint256 adId, uint256 amount) external {
        _fundAd(adId, amount);

        address account = _msgSender();
        _turpleTorken.transferFrom(account, address(this), amount);
    }

    function proposeAd(uint256 adId) external {
        _proposeAd(adId);
        setState(adId, true);
    }

    function publishAd(uint256 adId) external {
        require(state(adId) == ProposalState.APPROVED);
        setState(adId, false);
        _publishAd(adId);
    }

    // ========== Publishers Functions =========== //

    function claimAppReward(uint256 appId, uint256 amount) external {
        address publisher = _claimAppReward(appId, amount);

        _turpleTorken.transfer(publisher, amount);
    }

    // ========== Validators Functions =========== //

    function voteAdUp(uint256 adId) external {
        require(_ads[adId].state == AdState.PROPOSED);
        _voteUp(adId);
    }

    function voteAdDown(uint256 adId) external {
        require(_ads[adId].state == AdState.PROPOSED);
        _voteDown(adId);
    }

    function joinValidator() external {
        uint256 amount = _joinValidatorNode();

        address account = _msgSender();
        _turpleTorken.transferFrom(account, address(this), amount);
    }

    function claimValidatorReward() external {
        _claimValidatorReward();
    }

    function exitValidator() external {
        (uint256 amount, uint256 unClaimedReward) = _exitValidatorNode();

        address account = _msgSender();
        _turpleTorken.transfer(account, (amount + unClaimedReward));
    }
}
