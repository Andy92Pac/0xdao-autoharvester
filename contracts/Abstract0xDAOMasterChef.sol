// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Abstract0xDAOMasterChef {
    // Deposit LP tokens to MasterChef for OXD allocation.
    function deposit(uint256 _pid, uint256 _amount) public;

    function harvestAll() public;
}
