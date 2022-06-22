// SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Horus is ERC20, Ownable{

    event rewardRecive (address indexed staker, uint256 amount);
    uint256 public mintAmount = 100;
    mapping (address => mapping(uint256 => uint256)) lockTokens;
    mapping (address => bool) addressUse;
    address public stakingContract;
    
    constructor() ERC20("Horus", "HRS"){
        mint(msg.sender, 10000);
    }

    function mint(address account,uint256 amount) public onlyOwner{
        _mint(account,amount);
    }

    function burn(address , uint256 amount) public onlyOwner{
        _burn(msg.sender,amount);
    }

    function getRewards(uint256 amount) public {
        uint256 rewards = (block.timestamp-lockTokens[msg.sender][amount])/100;
        _mint(msg.sender, rewards);
        lockTokens[msg.sender][amount]=block.timestamp;

        emit rewardRecive(msg.sender, rewards);
    }
    
    function setStakingContract(address _stakingContract) public onlyOwner {
        stakingContract = _stakingContract; 
    }

    function oneMint(address recipient) public returns (bool) {
        require(!addressUse[msg.sender], "Address already is used");
        addressUse[msg.sender] = true;
        _mint(recipient, mintAmount);
        return true;
    }

    function mintForStaking(address recipient, uint256 amount) public returns (bool) {
        require(msg.sender == stakingContract, "only staking contract is allowed");
         _mint(recipient, amount);
         return true;
    }

    function deposit(uint256 amount) public{
        lockTokens[msg.sender][amount]=block.timestamp;
        _transfer(msg.sender, address(this), amount);
    }

    function retrive(uint256 amount) public{
        getRewards(amount);
        lockTokens[msg.sender][amount]=0;
        _transfer(address(this), msg.sender, amount);
    }

    function exit(uint256 amount) public{
        getRewards(amount);
        retrive(amount);
    }

    function approveAndCall(address spender, uint256 amount) public{
        require(approve(spender, amount)==true, "Transfer don't approve");
        transferFrom(address(this), spender, amount);
        _mint(spender, amount);
    }
}