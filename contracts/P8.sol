pragma solidity ^0.4.4;

contract P8 {
    uint8 public decimals = 18;
    mapping (address => uint256) public balanceOf;
    
    function P8(
        uint256 initialSupply
        ) public {
        balanceOf[msg.sender] = initialSupply * 10 ** uint256(decimals);              
    }

    /* Send coins */
    function transfer(address _to, uint256 _value) public {
        require(balanceOf[msg.sender] >= _value);           
        require(balanceOf[_to] + _value >= balanceOf[_to]); 
        balanceOf[msg.sender] -= _value;                    
        balanceOf[_to] += _value;                           
    }

    function getBalanceOf(address src) constant returns (uint256) {
        return balanceOf[src];
    }
}