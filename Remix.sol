// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract RemixToken is ERC20, ERC20Burnable, Ownable {
    constructor(
        uint256 initialSupply,
        string memory name,
        string memory symbol,
        address initialOwner
    ) ERC20(name, symbol) Ownable(initialOwner) {
        _mint(initialOwner, initialSupply * 10**decimals());
    }

    //Only contract owner can be able to mint tokens
    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    //Any user can burn tokens
    function burnFrom(address account, uint256 amount) public override onlyOwner {
        uint256 currentAllowance = allowance(account, _msgSender());
        require(currentAllowance >= amount, "ERC20: burn amount exceeds allowance");
        _approve(account, _msgSender(), currentAllowance - amount);
        _burn(account, amount);
    }

    //Any user can transfer tokens
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public override returns (bool) {
        _spendAllowance(sender, address(this), amount);
        _transfer(sender, recipient, amount);
        return true;
    }
}
