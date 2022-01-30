// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

abstract contract I0xDAOMasterChef {
    // Info of each pool.
    struct PoolInfo {
        IERC20 lpToken; // Address of LP token contract.
        uint256 allocPoint; // How many allocation points assigned to this pool. OXDs to distribute per block.
        uint256 lastRewardTime; // Last block time that OXDs distribution occurs.
        uint256 accOXDPerShare; // Accumulated OXDs per share, times 1e12. See below.
    }

    // Info of each user.
    struct UserInfo {
        uint256 amount; // How many LP tokens the user has provided.
        uint256 rewardDebt; // Reward debt. See explanation below.
        //
        // We do some fancy math here. Basically, any point in time, the amount of OXD
        // entitled to a user but is pending to be distributed is:
        //
        //   pending reward = (user.amount * pool.accOXDPerShare) - user.rewardDebt
        //
        // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
        //   1. The pool's `accOXDPerShare` (and `lastRewardBlock`) gets updated.
        //   2. User receives the pending reward sent to his/her address.
        //   3. User's `amount` gets updated.
        //   4. User's `rewardDebt` gets updated.
    }

    function poolInfo(uint256 _pid)
        external
        view
        virtual
        returns (PoolInfo calldata);

    function userInfo(uint256 _pid, address _account)
        external
        view
        virtual
        returns (UserInfo calldata);

    // Deposit LP tokens to MasterChef for OXD allocation.
    function deposit(uint256 _pid, uint256 _amount) public virtual;

    // Withdraw LP tokens from MasterChef.
    function withdraw(uint256 _pid, uint256 _amount) public virtual;

    function harvestAll() public virtual;
}
