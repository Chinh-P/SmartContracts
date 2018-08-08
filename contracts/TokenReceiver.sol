pragma solidity ^0.4.4;


contract Token {

    function totalSupply() constant returns (uint256 supply) {}
    function balanceOf(address _owner) constant returns (uint256 balance) {}
    function transfer(address _to, uint256 _value) returns (bool success) {}
    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
    function approve(address _spender, uint256 _value) returns (bool success) {}
    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
    
}

// This contract is designed to collect ERC20 token, writing transaction detail to log.
// Contract owner can receive token whenever he want through withdraw function.
// Precon: ERC20 token has approveAndCall function implemented. 
// Limitation: Currently, It supports collect 1 kind of token only. (address of the token is defined in constructor) 
contract TokenReceiver {
    
    address public owner;
    mapping(address =>uint) public balances ;
    address public tokenContract ;
    uint public totalHoldToken;
    
    event ReceiveToken (address fromAdd, uint256 amount, bytes receiveFor);

    constructor (address _tokenContract) public {
        owner = msg.sender;
        tokenContract = _tokenContract;
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }
    // this function will be call by ERC20.    
    function receiveApproval(address _sender,uint256 _amount,address _tokenContract,bytes _extraData) public {
        //1. check if the token is valid
        require(tokenContract == _tokenContract);
         //2. call function receive money
        Token t = Token(_tokenContract);
        require(t.transferFrom(_sender, address(this), _amount));
        balances[owner] += _amount;
        //uint256 payloadSize;
        //uint256 payload;
        //assembly {
        //    payloadSize := mload(_extraData)
       //     payload := mload(add(_extraData, 0x20))
       // }
       // payload = payload >> 8*(32 - payloadSize);
        emit ReceiveToken(_sender,_amount,_extraData);
       
        //3. add log
    }

    // this function is design for anyone can withdraw money.
    // however, as we can see, only owner have money in this smart contract, so, basically, only owner can call this method.
    function withdraw() public {
        Token(tokenContract).transfer(msg.sender, balances[msg.sender]);
        totalHoldToken -= balances[msg.sender];
        balances[msg.sender] = 0;
        
    }
     
    function withdraw(address toAdd, uint256 amount) onlyOwner public{
        Token(tokenContract).transfer(toAdd, amount);
        balances[msg.sender] -= amount;
    }
}
