// SPDX-License-Identifier: GPL-3.0
// Author: @annsDev

pragma solidity ^0.8.17;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
contract Ropstam is ERC20{
      address[]  public owners;
  constructor() ERC20("ROPSTEM", "ROP") {
      
  }
  modifier onlyOwner(){
        for(uint i ; i<owners.length ; i++){
            if(msg.sender == owners[i]){
                _;
            }
        }
        revert("you are not owner");
        
    }

function buy(uint256 amount) public payable {
        require(msg.value == ( amount * 100 wei), "Please provide the correct amount in wei.");
        _mint(msg.sender, amount);
    }

       function withdrawMoney() external onlyOwner {
        (bool success, bytes memory error) = msg.sender.call{
            value: address(this).balance
        }("");
        require(success, string(error));
    }

       /**
     * @dev contract can receive Ether.  msg.data is not empty
     */
    receive() external payable {}

    /**
     * @dev contract can receive Ether.
     */
    fallback() external payable {}

}