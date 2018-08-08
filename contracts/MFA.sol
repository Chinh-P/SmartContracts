pragma solidity ^0.4.11;

contract MFA {      
    struct LoginSession {
        string status;
        uint nounce;
        string requestorIp;
        uint sessionEnd;
    }
    mapping (address=>mapping(address => LoginSession[]) ) public authens;
      
    event received(string message);
    event log(uint value);

    // function requestAuthen(address functionGuid, uint nounce) {
    //     var length = authens[msg.sender][functionGuid].length;
    //     authens[msg.sender][functionGuid].length++;
    //     authens[msg.sender][functionGuid][length].status = "pending";
    //     authens[msg.sender][functionGuid][length].sessionEnd = now + 1200; // set session to 20 min!
    //     authens[msg.sender][functionGuid][length].nounce = nounce;
    // }

    function getAuthStt(address adr, address functionGuid, uint nounce ) constant returns(string) {
        var length = authens[adr][functionGuid].length;
        if (authens[adr][functionGuid][length-1].sessionEnd > now && authens[adr][functionGuid][length-1].nounce == nounce) {
            return authens[adr][functionGuid][length-1].status;
        } else {
            "-";
        }
    }

    function responseAuthen(address functionGuid, string status,uint nounce) {
        //    var index = authens[msg.sender][functionGuid].length; 
        //    if (index > 0 && authens[msg.sender][functionGuid][index-1].nounce == nounce) {
        //        authens[msg.sender][functionGuid][index-1].status = status;
        //    }
        var length = authens[msg.sender][functionGuid].length;
        authens[msg.sender][functionGuid].length++;
        authens[msg.sender][functionGuid][length].status = status;
        authens[msg.sender][functionGuid][length].sessionEnd = now + 1200; // set session to 20 min!
        authens[msg.sender][functionGuid][length].nounce = nounce;  
    }

    function getOne() constant returns(string){
        return "1";
    }
}