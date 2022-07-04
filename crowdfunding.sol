//SPDX-License-Identifier:MIT
pragma solidity ^0.8;

//automate a smart contract. Im Marc and I am going to send 10 eth to smart contrcat, that then will
//have 10Eth, but it is programed to send to another address 1eth of that 10. lets say it send a 10%

contract crowdFunding1{
    address internal destination = 0xC8E96ac5529Fe3D80f8cC3deA3B1e0a6b2329E17; //you dont have to declare an address as payable in solidity 0.8, you have to do it in the function etc
    
    fallback()payable external{
        payable(destination).transfer(msg.value/500); //make destination payable so you can receive the funds
    }

}