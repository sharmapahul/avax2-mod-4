// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract DegenToken is ERC20, Ownable,ERC20Burnable {
    address vault = 0xCA35b7d915458EF540aDe6068dFe2F44E8fa733c;  

  constructor(address payable initialOwner)
        ERC20("Degen", "DGN")
        Ownable(initialOwner)
    {}

        function mint(address to, uint256 amount) public onlyOwner {
            _mint(to, amount);
        }
        function decimals() override public pure returns (uint8) {
            return 0;
        }
        function getBalance() external view returns (uint256) {
            return this.balanceOf (msg. sender);
        }
        function transferTokens(address _receiver, uint256 _value) public  {
            require(msg.sender!=vault);
            require(balanceOf(msg .sender)>=_value,"You do not have enough Degen Tokens");
            approve(msg. sender,_value);
            transferFrom(msg.sender,_receiver,_value);
        }
        function StoreItem()public pure returns(string memory items)
        {
       
           return ( "1 : hat   \n  2 : shirt \n   3 : heart");
        }
        function RedeemToken(string memory choice)public payable 
        {
            
            if(keccak256(abi.encodePacked(choice))==(keccak256(abi.encodePacked('1'))))
            {
                transferTokens(vault, 200);
            }
            if(keccak256(abi.encodePacked(choice))==(keccak256(abi.encodePacked('2'))))
            {
                transferTokens(vault, 100);
            }
            if(keccak256(abi.encodePacked(choice))==(keccak256(abi.encodePacked('3'))))
            {
                transferTokens(vault, 50);
            }
        }
        
}
