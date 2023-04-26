// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

abstract contract PublisherNode is Context {
    using Counters for Counters.Counter;

    Counters.Counter private _appIdTracker;

    mapping(uint256 => App) public _apps;

    struct App {
        uint256 appId;
        uint16 format;
        uint16 category;
        uint256 claimedReward;
        string metadata;
        uint256 createdOn;
        address publisher;
    }

    event AppCreated(
        uint256 appId,
        uint16 format,
        uint16 category,
        uint256 claimedReward,
        string metadata,
        uint256 createdOn,
        address publisher
    );

    function createApp(
        uint16 category,
        uint16 format,
        string memory metadata
    ) external {
        address account = _msgSender();

        _appIdTracker.increment();
        uint256 appId = _appIdTracker.current();

        App storage app = _apps[appId];
        app.appId = appId;
        app.createdOn = block.timestamp;
        app.category = category;
        app.format = format;
        app.publisher = account;
        app.metadata = metadata;

        _emitApp(app);
    }

    function _claimAppReward(
        uint256 appId,
        uint256 amount
    ) internal virtual returns (address) {
        App memory app = _apps[appId];

        app.claimedReward += amount;

        _emitApp(app);

        return app.publisher;
    }

    function _emitApp(App memory app) private {
        emit AppCreated(
            app.appId,
            app.format,
            app.category,
            app.claimedReward,
            app.metadata,
            app.createdOn,
            app.publisher
        );
    }
}
