//SPDX: License-Identifier-MIT

pragma solidity ^0.8.10;

contract multiSig{
    event Deposit(address indexed sender, uint amount);
    event Submit(address indexed txId);
    event Approve(address indexed owner, uint indexed txId);
    event Revoke(address indexed owner, uint indexed txId);
    event Execute(uint indexed txId);

    struct Transaction{
        address to;
        uint value;
        bytes data;
        bool executed;
    }
    
    address [] public owners;
    //check whether the msg.sender is the owner
    mapping(address => bool) public isOwner;
    //number of approvals required before a transaction can be executed
    uint public required;

    Transaction[] public transactions;
    //approval of each transaction by its owner in a mapping(the uint is the index of the transaction)
    mapping(uint => mapping(address => bool)) public approved;
    
    modifier onlyOwner(){
        require(isOwner[msg.sender], "not the owner");
        _;
    }
    //to know if the tx exists, we kow that the index is less than the array length
    modifier txExitst(uint _txId){
        require(_txId < transactions.length, "tx does not exist");
        _;
    }
    //we can know if a transaction is not yet approved by checking the mapping approved
    modifier notApproved(unit _txId){
        require(!approved[_txId][msg.sender], "the transaction has alredy benn aproved");
        _;
    }

    modifier notExecuted(uint _txId){
        require(!transactions[_txId].executed, "The transaction has alredy been executed");
        _;
    }
    
    constructor(address[] memory _owners, uint _required){
        require(_owners.length > 0, "owners required");
        require(
            _required > 0 && _required <= _owners.length,
             "invalid required number of owners"
        );
        //loop to save the owners to the state variable and we will make sure that owners is not equal to address 0 and its unique
        for (uint i; i < _owners.length; i ++){
            address owner = _owners[i];
            require(owner != address(0), "invalid owner")
            //the owner has to be unique
            require(!isOwner[owner], "owner is not unique");
            //insert the new owner into the mapping
            isOwner[owner] = true;
            owners.push(owner)
        }

        required = _required
    }
    //enable the multi-sig to be able to receive ether
    receive() external payable{
        emit Deposit(msg.sender, msg.value);
    }
//we use calldata because the function is external and calldata is cheaper than memory in gas
    function submit(address _to, uint value, bytes calldata _data)
        external 
        onlyOwner{
        transactions.push(Transaction({
            to: = _to,
            value: _value,
            data = _data,
            executed = false
        }));
        emit Submit(transactions.length -1);
    }

    function approve(uint _txId)
        external
        onlyOwner
        txExists(_txId)
        notApproved(_txId)
        notExecuted(_txId)
        {
            approved[_txId][msg.sender] = true;
            emit Approve(msg.sender, _txId);
        }
        //function name with _ beacuse it is private
        function _getApprovalCount(uint _txId) private view returns (uint count){
            for (uint i; i < owner.length; i++){
                if (approved[_txId][owners[i]]){
                    count ++;
                }
            }
        }
        function Execute(uint _txId) external txExists(_txId) notExecuted(_txId){
            //check that the count of approvals is greater or equal to required
            require(_getApprovalCount(_txId) >= required, "approvals is less tha required");
            Transaction storage transaction = transactions[_txId];
            transaction.executed = true;
            (bool success, ) = transaction.to.call{value: transaction.value}(
                transaction.data
            );
            require(success, "tx failed");

            emit Execute(_txId);
        }

        function Revoke(uint _txId)
            external 
            onlyOwner
            txExists(_txId)
            notExecuted(_txId)
        {
            require(approved[_txId][msg.sender], "tx not approved");
            approved[_txId][msg.sender] = false;
            emit Revoke(msg.sender, _txId);
        }
}

