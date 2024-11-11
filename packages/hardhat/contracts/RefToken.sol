// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract RefToken is ERC20, Ownable {
  
  uint256 MAX_INT = 2**256 - 1;


  constructor(address _owner, uint256 _initialSupply) ERC20("Referral Token", "REF") Ownable(_owner) {
    _mint(_owner, _initialSupply);
    approve(_owner, MAX_INT);
  }

  function mint(address to, uint256 amount) external onlyOwner returns (bool) {
    _mint(to, amount);
    return true;
  }

}