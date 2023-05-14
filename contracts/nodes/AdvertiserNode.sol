// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

abstract contract AdvertiserNode is Context {
    using Counters for Counters.Counter;

    Counters.Counter private _adIdTracker;

    mapping(uint256 => Ad) public _ads;

    event AdCreated(
        uint16 format,
        uint16 category,
        uint256 adId,
        uint256 balance,
        AdState state,
        string metadata,
        uint256 createdOn,
        address advertiser
    );

    enum AdState {
        DEFAULT,
        PROPOSED,
        PUBLISHED,
        PAUSED,
        ARCHIVED
    }

    struct Ad {
        uint256 adId;
        uint16 format;
        uint16 category;
        uint256 balance;
        AdState state;
        string metadata;
        address advertiser;
        uint256 createdOn;
    }

    function createAd(
        uint16 category,
        uint16 format,
        string memory metadata
    ) public virtual {
        address account = _msgSender();

        _adIdTracker.increment();
        uint256 adId = _adIdTracker.current();

        Ad storage ad = _ads[adId];
        ad.adId = adId;
        ad.state = AdState.DEFAULT;
        ad.advertiser = account;
        ad.createdOn = block.timestamp;
        ad.category = category;
        ad.format = format;
        ad.metadata = metadata;

        _emitAd(ad);
    }

    function pauseAd(uint256 adId) public virtual {
        address account = _msgSender();

        require(account == _ads[adId].advertiser);

        _ads[adId].state = AdState.PAUSED;

        _emitAd(_ads[adId]);
    }

    function _fundAd(uint256 adId, uint256 amount) internal virtual {
        address account = _msgSender();

        require(account == _ads[adId].advertiser);

        _ads[adId].balance += amount;

        _emitAd(_ads[adId]);
    }

    function _proposeAd(uint256 adId) public virtual {
        require(AdState.DEFAULT == _ads[adId].state);
        _ads[adId].state = AdState.PROPOSED;

        _emitAd(_ads[adId]);
    }

    function _publishAd(uint256 adId) internal virtual {
        require(AdState.PROPOSED == _ads[adId].state);
        _ads[adId].state = AdState.PUBLISHED;

        _emitAd(_ads[adId]);
    }

    function _emitAd(Ad memory ad) private {
        emit AdCreated(
            ad.format,
            ad.category,
            ad.adId,
            ad.balance,
            ad.state,
            ad.metadata,
            ad.createdOn,
            ad.advertiser
        );
    }
}
