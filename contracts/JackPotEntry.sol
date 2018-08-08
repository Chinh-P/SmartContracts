pragma solidity ^0.4.4;

import "./Jackpot.sol";

contract JackPotEntry {
    uint8 firstNumber;
    uint8 secondNumber;
    uint8 thirdNumber;
    uint8 fourthNumber;

	uint8 status;
    Jackpot jackpot;
    uint public ticketPrice = 100000000000000000;

    constructor ( address jpAddr, uint8 _firstNumber, uint8 _secondNumber, uint8 _thirdNumber, uint8 _fourthNumber) public payable {
        // give it some money to pay for gas!
        firstNumber = _firstNumber;
        secondNumber = _secondNumber;
        thirdNumber = _thirdNumber;
        fourthNumber = _fourthNumber;
        jackpot = Jackpot(jpAddr);
        status = 0;
    }
    
    function () public payable {
        // handling send data to Main contract
        require(msg.value == ticketPrice);
        jackpot.bet.value(ticketPrice)(msg.sender,firstNumber, secondNumber,thirdNumber,fourthNumber);
		status = 1;
    }

    function GetStatus() view public returns (uint) {
        return status;
    } 
}