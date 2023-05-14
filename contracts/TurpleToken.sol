// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract TurpleToken is ERC20 {

    event MintFaucet(uint256 mintAmount);

    constructor() ERC20("Turple Token", "TRP") {
        _mint(msg.sender, 100000000 * 1e18);
    }

    function mintFaucet(uint256 amount) external {
        _mint(msg.sender, amount);
        emit MintFaucet(amount);
    }
}
