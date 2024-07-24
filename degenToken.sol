// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract DegenToken is ERC20, Ownable, ERC20Burnable {
    address public vault = 0xCA35b7d915458EF540aDe6068dFe2F44E8fa733c;

    mapping(address => string[]) private accountRedeemedItems;

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
        return balanceOf(msg.sender);
    }

    function transferTokens(address _receiver, uint256 _value) public {
        require(msg.sender != vault, "Transfer not allowed from vault");
        require(balanceOf(msg.sender) >= _value, "Insufficient balance");

        // Transfer tokens
        approve(msg.sender, _value);
        transferFrom(msg.sender, _receiver, _value);
    }

    function StoreItem() public pure returns (string memory items) {
        return "1 : hat   \n  2 : shirt \n   3 : heart";
    }

    function RedeemToken(string memory choice) public payable {
        string memory item;

        if (keccak256(abi.encodePacked(choice)) == keccak256(abi.encodePacked('1'))) {
            item = "hat";
            transferTokens(vault, 200);
        } else if (keccak256(abi.encodePacked(choice)) == keccak256(abi.encodePacked('2'))) {
            item = "shirt";
            transferTokens(vault, 100);
        } else if (keccak256(abi.encodePacked(choice)) == keccak256(abi.encodePacked('3'))) {
            item = "heart";
            transferTokens(vault, 50);
        } else {
            revert("Invalid choice");
        }

        accountRedeemedItems[msg.sender].push(item);
        emit ItemRedeemed(msg.sender, item);
    }

    event ItemRedeemed(address indexed player, string item);

    // Function to get redeemed items for a specific account
    function getRedeemedItemsForAccount(address account) external view returns (string[] memory) {
        return accountRedeemedItems[account];
    }
}
