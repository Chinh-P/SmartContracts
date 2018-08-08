pragma solidity ^0.4.4;

contract Process
{
    address[] public listSender;
    address[] public listContract;
    bytes[] public extraData;
    event logData(address _fromSender, address _fromContract, bytes _data);
    function log(address fromSender, address fromContract, bytes _extraData) public
    {
        listSender.push(fromSender);
        listContract.push(fromContract);
        extraData.push(_extraData);

        emit logData(fromSender, fromContract, _extraData);
    }
}