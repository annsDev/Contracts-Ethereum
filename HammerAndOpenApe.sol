// SPDX-License-Identifier: MIT
// Author: @annsDev

pragma solidity 0.8.17;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "hardhat/console.sol";
contract HammerAndOpenApe is ERC1155{
    // Fungible Token (Ropstem)
    IERC20 private ropstem;
    // Non-Fungible Token (Open Ape)
    ERC1155 private tokens;
    // Owners of the smart contract
    address[] private owners;
    bool private isOpenApeMinted = false;
    uint256 private constant HAMMAR = 0;
    uint256 private constant OPENAPES = 1;

    constructor(IERC20 _ropstemIntance) ERC1155("https://nft.example/api/item/id.json") {
        // Initialize Hammer token
        ropstem = IERC20(_ropstemIntance);
        // Initialize Open Apes token
        // Add msg.sender as an owner on contract deployment
        owners.push(msg.sender);
    }

    modifier onlyOwner(){
        for(uint i ; i<owners.length ; i++){
            if(msg.sender == owners[i]){
                _;
            }
        }
        revert("you are not owner");
        
    }

    // Function to add new owners
    function addOwner(address newOwner) onlyOwner public {
        owners.push(newOwner);
    }

    // Function to mint new Hammer tokens
    function mintHammer(uint256 tokenId , uint256 _tokenAmount)  public {
        require(tokenId == HAMMAR , "please provide token id for hammar");
        require(_tokenAmount >= 100, "you have to provide 100 token");
        require(balanceOf(msg.sender, OPENAPES) <= 0 , "you can not have both Hammar and Open ape token");
        ropstem.transferFrom(msg.sender, address(this), _tokenAmount);
        _mint(msg.sender, HAMMAR , (_tokenAmount / 100) , "");
    }

    // Function to mint new OpenApes tokens
    // user are only able to mint one token at time
    function mintOpenApes(uint256 tokenId , uint256 _tokenAmount)  public {
        require(tokenId == OPENAPES , "please provide token id for hammar");
        require(_tokenAmount >= 100, "you have to provide 100 token");  
        require(balanceOf(msg.sender, HAMMAR) <=0 , "you can not have both Hammar and Open ape token");
        require(!isOpenApeMinted , "Ape is already minted");
        isOpenApeMinted = true;
        _mint(msg.sender, OPENAPES , 1 , "");
    }
  
    // Function to withdraw funds
    function withdraw() onlyOwner public {
        ropstem.transfer(msg.sender , ropstem.balanceOf(address(this)));
    }

}