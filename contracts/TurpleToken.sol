// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract TurpleToken is ERC20 {
    constructor() ERC20("Turple Token", "TRP") {
        _mint(msg.sender, 1000000000000000000000000000);
    }
}
