//SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {ERC20} from "../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract TechCrushToken is ERC20 {
    string public NAME;
    string public SYMBOL;
    uint8 public constant DECIMALS = 18;
    uint256 public constant MAXSUPPLY = 100000 * 1e18;

    constructor() ERC20("TechCrush Token", "TCH") {
        NAME = "TechCrush Token";
        SYMBOL = "TCH";
        //maxsupply already hardcoded
        _mint(msg.sender, MAXSUPPLY);
    }

    function name() public view override returns (string memory) {
        return NAME;
    }

    function symbol() public view override returns (string memory) {
        return SYMBOL;
    }

    function decimals() public pure override returns (uint8) {
        return DECIMALS;
    }
}
