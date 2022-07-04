//SPDX-Licnse-Identifier:MIT
//This lending pool will be a smart contract were 
//you are going to be able to lend and borrow to and from the system
//you can borrow at any time and any amount depending on teh liquidity
//lenders don't know borrowers and don't need to trust them

pragma solidity ^0.8.0;
//We are going to use a target utilization ratio(20 % of the funds and the following 80% stay tere as reserve)
//We are going to use interest rates, so if the target utilization ration goes up, the interest will also go up.
//Which means that is more expensive to borrow, so people that borrowed before,
//will start to return the loans which will bring teh utilization ratio down./
//All the way aroud, uf the utilization ratio is low, the interest will go down and more people will borrow.
//even if there was a huge lender taht would like to withdraw the funds, he would have to wait but the interest would be very high,
//so it would not be a major problem


contract LendingPool{

}