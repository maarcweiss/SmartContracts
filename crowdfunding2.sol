//SPDX-License-Identifier:MIT
pragma solidity ^0.8;

//automate a smart contract. Im Marc and I am going to send 10 eth to smart contrcat, that then will
//have 10Eth, but it is programed to send to another address 1eth of that 10. lets say it send a 10%

contract crowdFunding2{
    address public destination = 0xC8E96ac5529Fe3D80f8cC3deA3B1e0a6b2329E17;

    mapping(address => uint)public balanceOf;
    uint public totalSuppy;
    string public name;
    string public symbol;
    uint8 public decimals;

    constructor(uint _totalSupply)public{
        name = "Hydro";
        symbol = "DRO";
        decimals = 18;
        totalSuppy = _totalSupply;
        balanceOf[msg.sender] = totalSuppy;

    }
    function transfer(address _to, uint amount) public{
        uint portionfordestination = amount/100;
        uint senderBalance = balanceOf[msg.sender];
        require(senderBalance >= amount, "not enough funds");
        balanceOf[msg.sender] -= amount;
        uint receiverBalance = balanceOf[_to];
        balanceOf[_to] += amount - portionfordestination;
        balanceOf[destination]+= amount - portionfordestination;
        assert(balanceOf[msg.sender] + balanceOf[_to] + portionfordestination == senderBalance +receiverBalance);
    }


}