// SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Leno is ERC721, Ownable {
   
    address public immutable paymentToken;
    uint256 public tokenPrice = 10;
    uint256 public rebate = 15;

    constructor(address _paymentToken) ERC721("Leno", "LEN"){
        paymentToken = _paymentToken;
    }

    function newTokenPrice(uint256 newPrice) public onlyOwner{
        tokenPrice=newPrice;
    }

    function newRebate(uint256 newRebateToken) public onlyOwner{
        rebate=newRebateToken;
    }

    function mintToken(address to, uint256 idToken) public {
        require(IERC20(paymentToken).transferFrom(msg.sender, address(this), tokenPrice),"Fail transfer");
        _mint(to, idToken);
    }

    function numberTokens (address to, uint256 idToken, uint256 number) public {
        uint256 totalTokenPrice = number*(tokenPrice);
        totalTokenPrice = totalTokenPrice-(totalTokenPrice*rebate)/100;
        require(IERC20(paymentToken).transferFrom(msg.sender, address(this), totalTokenPrice),"Fail transfer");
        for(uint256 i=0; number < i; i++){
            _mint(to, idToken);
            idToken += 1;
        }
    }    
}