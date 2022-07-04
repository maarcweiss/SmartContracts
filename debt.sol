//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Loan{
    //The loan can have 5 stages, that's why we are going to use an enum
    //{Created, Funded, Taken, Repayed, Liquidated}
    enum LOANSTATE{CREATED, FUNDED, TAKEN}
    LOANSTATE public state;

    //modifier to check that we are in the expected state
    modifier onlyState(LOANSTATE expectedState){
        require(state == expectedState, "not allowe in this state!");
        _;
    }

    //state variables
    address payable public lender;
    address payable public borrower;
    address payable daiAddress;
    string public terms;

    constructor (string memory _terms, address memory _daiAddress){
        terms = _terms;
        daiAddress = _daiAddress;
        lender = msg.sender;
        state = LOANSTATE.CREATED;
    }

    function FundLoan() public onlyState(LOANSTATE.CREATED){
        //Transfers DAI from the lender to the contract so that we can later transfer it to the borrower.
        //This requires that the lender has to allow us to do so before, and if he doesnt, it will fail.
        //when something goes wrong with the transaction, the transaction will fail and the state will be reverted
        state = LOANSTATE.FUNDED;
        DAI(daiAddress).transferFrom(
            msg.sender, 
            address(this),
            terms.loanDaiAmount
        );
    }

    function takeAloanAndAcceptTerms()public payable onlyState(LOANSTATE.FUNDED){
        //payable because the collateral should be sent by calling the function
        
        //check that the exact amount of collateral is transferes. 
        //It will be kept in the contract till the loan is repayed or liquidated. 
        require( msg.value = terms.ethCollateralAmount, "The amount of the collateral was not valid");

        //record the borrower address so that only can him/she can repay the loan and unlock the collateral
        borrower = msg.sender;
        state = LOANSTATE.TAKEN;

        //Transfer the actual tokens that are being loaned
        DAI(daiAddress).transfer(borrower, terms.loanDaiAmount);
        
    }
    
    //function to repay the loan. It can be repayed early with no fees. Borrower should be able 
    //to allow this contract to pull the tokesn before calling this.
    function repay() public onlyState(LOANSTATE.TAKEN){
        //Allowing anyone to repay will allow anyone to unlock the collateral, so we have to secure this
        require(msg.sender = borrower, "Only the borrower can repay the loan");
        //Pull the tokens, the inital amount and the fee. I fthere is nto enough it will fail
        DAI(daiAddress).transferFrom(
            borrower,
            lender,
            terms.loanDaiAmount + terms.feeDaiAmmount
        );
        //send the collater back to the borrower and destroy the contract
        selfdestruct(borrower); //it will transfer all ether back to the borrower
    }

    //function called by rthe lender in case the loan has not been payed on time
    //It will transfer the collateral to the lender
    //the collateral has to be more valueble than the loan so the lenser doesn't lose money in this case.
    function liquidate() public onlyState(LOANSTATE.TAKEN){
        require(msg.sender == lender, "only the lender can liquidate the loan");
        require(
            block.timestamp >= terms.repayByTimestamp, 
            "Cannot liquidate before the loan is due"
        );

        //send the collateral to the lender and destroy the contract
        selfdestruct(lender);

    }
    


}