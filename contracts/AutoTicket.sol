pragma solidity ^0.4.4;

// We are gonna deploy 1 contract each time people want to play a game
contract AutoTicket {

    uint[] public selectedTicket; // ticket that send when they create a new game
    
    address gameOwner; // game owner is us
    uint public winningTicket;
	uint8 status;
    function createTicket (uint[] _selectedTicket) payable {
        for (var index = 0; index < _selectedTicket.length; index++) {
            selectedTicket.push(_selectedTicket[index]);
        }
        gameOwner = msg.sender; 
    }
    
    function GetWinningTicket() returns (uint) {
        return winningTicket;
    }
    
    event received(string message);
    event log(uint value);

    function () payable {
        status = 1;
        var bet = msg.value;
        received("bet received");
        var ticketAmount = selectedTicket.length;
        var price = bet / ticketAmount;
        var prize = price * 9;
        require(prize <= this.balance); //make sure you have enough money to pay.
         
        winningTicket = (uint(block.blockhash(block.number-1)) + now) % 10 + 1;
        bool isWin = false;
        for (var index = 0; index < selectedTicket.length; index++) {
          if (winningTicket == selectedTicket[index]) {
            isWin = true;
          }
        } 
        
        if (isWin) {
            log(prize);
            msg.sender.transfer(prize);    
			// Win = 2
			status = 2;
        }
        else {
            status = 3;
        }
        // selfdestruct(gameOwner);
        // fail = 3
		
    }
    // this function will be called every day to collect money back
    function getMoneyBack() {
        require(msg.sender == gameOwner);
        selfdestruct(gameOwner);
    }

   
    function GetStatus() returns (uint) {
        return status;
    } 
}