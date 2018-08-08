pragma solidity ^0.4.4;

contract Nothing {
     function getAddr() constant returns (address[2]) {
         
        return ([address(0x0),address(0x68dff740f7af1923da08501c92d58bf4737a0e97)]);
    }

    function getOne() constant returns(int) {
        return 1;
    }
}