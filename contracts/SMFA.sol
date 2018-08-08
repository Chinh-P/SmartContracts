pragma solidity ^0.4.11;

contract SMFA {      
    mapping (address=>string) public authens;
 
    function requestAuthen() {
       
        authens[msg.sender] ="pending";
    }
 
    function getCurrentAuthStt(address addr) constant returns(string) {
        return authens[addr];
    }

    function responseAuthen(string status) {
          authens[msg.sender] = status;
    }

   
}