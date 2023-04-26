// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./../libraries/Proposals.sol";

abstract contract ValidatorNode is Proposals {
    uint256 private _voteReward = 2 * 1e18;
    uint256 private _validatorFee = 1500 * 1e18;

    mapping(address => Validator) public _validators;

    event JoinValidatorNode(address account);
    event ExitValidatorNode(address account);
    event ClaimedValidator(address account, uint256 amount);

    struct Validator {
        uint256 createdOn;
        uint256 turpleStaked;
        uint256 unClaimedReward;
        uint256 claimedReward;
    }

    function _voteUp(uint256 adId) public virtual {
        approve(adId);

        address account = _msgSender();
        _validators[account].unClaimedReward += _voteReward;
    }

    function _voteDown(uint256 adId) public virtual {
        disapprove(adId);

        address account = _msgSender();
        _validators[account].unClaimedReward += _voteReward;
    }

    function _joinValidatorNode()
        public
        virtual
        notValidator
        returns (uint256)
    {
        address account = _msgSender();

        Validator storage validator = _validators[account];
        validator.createdOn = block.timestamp;
        validator.turpleStaked = _validatorFee;

        emit JoinValidatorNode(account);

        return _validatorFee;
    }

    function _claimValidatorReward() public virtual returns (uint256) {
        return __claimReward();
    }

    function _exitValidatorNode()
        public
        virtual
        onlyValidator
        returns (uint256, uint256)
    {
        address account = _msgSender();

        uint256 unclaimedReward = __claimReward();
        uint256 stakedAmount = _validators[account].turpleStaked;

        delete _validators[account];
        emit ExitValidatorNode(account);

        return (stakedAmount, unclaimedReward);
    }

    function __claimReward() private returns (uint256) {
        address account = _msgSender();

        uint256 unClaimedReward = _validators[account].unClaimedReward;

        _validators[account].claimedReward += unClaimedReward;
        _validators[account].unClaimedReward = 0;

        emit ClaimedValidator(account, unClaimedReward);

        return unClaimedReward;
    }

    modifier onlyValidator() {
        address account = _msgSender();
        if (_validators[account].createdOn == 0) {
            revert();
        }
        _;
    }

    modifier notValidator() {
        address account = _msgSender();
        if (_validators[account].createdOn != 0) {
            revert();
        }
        _;
    }
}
