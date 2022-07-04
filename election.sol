//SPDX-License-Identifier: MIT

pragma solidity >0.6.0;

contract election{
    struct Candidate{
        string name;
        uint voteCount; //how any votes the candidate has
    }
    struct Voter{
        bool authorized; //not everybody is allowed to vote
        bool voted; //wether or nor they are voted
        uint vote; //to track who has voted with numbers
    }
    Candidate[] public candidates; //array of candidates of the Candidate struct

    address public owner; //I want my address to be public
    string public electionName;
    uint public totalVotes;

    modifier onlyOwner(){
        require(msg.sender == owner); //require that the owner(msg.sender == to the owner)
        _; //represents the remaining body of our function
        //basically says that we are going to execute the require statement and then if its correct the rest of the function will execute, for that reasom we have the _;
       //if you pu the _; before the require then the function will execute first and then the rquiere
    }

    mapping(address => Voter)public voters; //is like a dictionary where they key is an address and we are going to track the voter

    constructor(string memory _name)public{ //in anterior versions, the constructor is a function with the same name as the contract like I did in Java
        owner = msg.sender;        //set a owner so the constructor is executed when the contract is deployed
        electionName = _name;    //para poner botones en el contrato es el constructor
    }
    function addCandidate(string memory _name) onlyOwner public{ //we only want the owner of the contract to add new candidates, use modifers for that
        candidates.push(Candidate(_name,0));              //add the modifier previously created to the function
        //push a new candidate into the arrat, by creating a new Candidate Struct with new name and the votes starting with 0.
    }
    function getNumberCandidates()public view returns(uint){ //view is the same as constant in previous versions
        return candidates.length;          //we put view beacuse its free, doesnt cost gas
    } //we returned the size of the candidates array
    
    function authorizeVoter(address _person) onlyOwner public{
        voters[_person].authorized = true;       //on the mapping voters, we are going to use the key _person
    }                                            //we are using the bool authorized from the struct Voter to authorize.
    function vote(uint _voteIndex)external{ //the _voteIndex will be use to index through the candidates array to retrieve the candidate
        require(!voters[msg.sender].voted);   //make sure that the person uis authorised to bote
        require(voters[msg.sender].authorized); //with the .votes we make sure that the voted field is flase so we can vote
        
        voters[msg.sender].vote = _voteIndex;
        voters[msg.sender].voted = true;  //so if we call the function again and we have votd, the function will not pass.
        
        candidates[_voteIndex].voteCount +=1 ;
        totalVotes += 1;
    }                                          //making sure that we are authorized to vote is true, if we dont put anything solidity understand that is true the require


    function end() onlyOwner external{
        //selfdestruct(owner); //selfdestruct destroys the contract so no furder state changes or no one can call methods etc.
    } //if the contract had still some ether remaining, the reamaining ether will be sent to the owner
}

