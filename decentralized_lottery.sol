//SPDX-License-Identifier:MIT
pragma solidity ^0.8.13;
//ESQUEMA: ADMIN & CONTESTANTS, functions
//ADMIN => CREATES CONTRACT, AUTHORITY, ADDRESS
//CONTESTANT => ENTERS FOR A CHANGE TO WIN, ARRAY OF ADDRESSES, CONTRIBUTES TO ETH POOL
//functions: lottery, enter, random, pickWinner, getContenstans
//lottery equals the admin address to msg.sender
//enter allows us to enter contestants by donating ether
//generate a random number
//pick winner only be called by the owner

contract DecentralizedLottery{
    address public admin;
    address payable[] public contestants;
    uint public Id; //identify the lotteries that are being played
    mapping(uint => address payable)public history; //records the winners

    modifier onlyOwner(){
        require(msg.sender==admin);
        _;
    }
    
    constructor(){
        admin = msg.sender;
        Id = 1; //first lottery that is being played is being associated to number 1
    } 

    function getBalance()public view returns(uint){
        return address(this).balance; //keyword this refers to the address contraft
    }

    function enter()public payable{
        require(msg.value >= 0.0000005 ether); //the value that a person has to dsend to access the lottery
        contestants.push(payable(msg.sender)); //push the address of the person that sent the ether into the contestants array
    }

    function random()public view returns (uint){
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, contestants))); //block.difficulty is the difficulty of this particlar time to solb=ve a block.

    }//block.timestamp is when the block is mined
    //abi.encode is used when u are dealing with more than one dynamic type

    function pickWinner()public onlyOwner{
        uint index = random() % contestants.length;

        contestants[index].transfer(address(this).balance); //automatically send the price to the winner
        history[Id] = contestants[index]; //my array of historical winners
        Id ++;

        contestants = new address payable[](0); //reset the contract
    }

    function getContestants() public view returns(address payable[] memory){
        return contestants;
    }


}