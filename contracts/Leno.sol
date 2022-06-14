// SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Leno is ERC721, Ownable {
    uint256 count;
    address public immutable paymentToken;
    uint256 tokenPrice = 10;
    uint256 rebate = 15;


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
        count += 1;
    }

    function numberTokens (address to, uint256 idToken, uint256 number) public {
        tokenPrice = tokenPrice-((tokenPrice*rebate)/100);
        for(uint256 i=0; number < i; i++){
            mintToken(to, idToken);
        }
        tokenPrice = 10;
    }    
    
}