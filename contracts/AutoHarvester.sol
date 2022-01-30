//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";

import "./I0xDAOMasterChef.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract AutoHarvester is Ownable {
    address public masterChef;
    address public oxd;
    uint256 public oxdPid;

    constructor(
        address _masterChef,
        address _oxd,
        uint256 _oxdPid
    ) {
        I0xDAOMasterChef.PoolInfo memory oxdPool = I0xDAOMasterChef(masterChef)
            .poolInfo(_oxdPid);

        require(
            address(oxdPool.lpToken) == _oxd,
            "oxd and pool lp token addresses don't match"
        );

        masterChef = _masterChef;
        oxd = _oxd;
        oxdPid = _oxdPid;
    }

    function deposit(
        address token,
        uint256 amount,
        uint256 pid
    ) public onlyOwner {
        // get the pool corresponding to pid
        I0xDAOMasterChef.PoolInfo memory pool = I0xDAOMasterChef(masterChef)
            .poolInfo(pid);

        // check that addresses match
        require(
            address(pool.lpToken) == token,
            "pool lp token and token don't match"
        );

        // transfer tokens from caller to contract
        IERC20(token).transferFrom(msg.sender, address(this), amount);

        // approve tokens sending to 0xDaoMasterChef
        IERC20(token).approve(masterChef, amount);

        // stake tokens in 0xDaoMasterChef
        I0xDAOMasterChef(masterChef).deposit(pid, amount);
    }

    function harvest() public onlyOwner {
        // harvest all 0xd tokens
        I0xDAOMasterChef(masterChef).harvestAll();

        uint256 balance = IERC20(oxd).balanceOf(address(this));

        IERC20(oxd).approve(masterChef, balance);

        I0xDAOMasterChef(masterChef).deposit(oxdPid, balance);
    }

    function withdraw(uint256[] calldata pids, uint256[] calldata amounts)
        public
        onlyOwner
    {
        require(pids.length == amounts.length, "lengths don't match");

        for (uint256 index = 0; index < pids.length; ++index) {
            I0xDAOMasterChef.PoolInfo memory pool = I0xDAOMasterChef(masterChef)
                .poolInfo(pids[index]);

            I0xDAOMasterChef(masterChef).withdraw(pids[index], amounts[index]);

            exit(address(pool.lpToken));
        }
    }

    function exit(address token) public onlyOwner {
        uint256 balance = IERC20(token).balanceOf(address(this));

        IERC20(token).transfer(msg.sender, balance);
    }
}
