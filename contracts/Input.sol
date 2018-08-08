
pragma solidity ^0.4.4;

contract Input
{
    function callLog(address tokenAddress, bytes _extraData) public returns(bool)
    {
        if(!tokenAddress.call(bytes4(bytes32(sha3("log(address,address,bytes)"))), msg.sender, this, _extraData)) 
        {
            throw;
        }
        return true;
    }
}