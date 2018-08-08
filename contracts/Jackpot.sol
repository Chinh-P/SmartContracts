pragma solidity ^0.4.4;

contract Jackpot {
    
    struct Game {
         Ticket winningTicket;
         Ticket[] bets;
         bool isEnable;
    }
    
    struct Ticket {
        address betAddr;
        uint8 firstNumber;
        uint8 secondNumber;
        uint8 thirdNumber;
        uint8 fourthNumber;
    }
    
    address public owner;
    Game[] games;
    Ticket[] winningTickets;
    mapping (uint=> Ticket[])  winner;
   
    function Jackpot() payable {
        owner = msg.sender;
        games.length = 1;
        games[0].isEnable = true;
        
    }
   
   function () payable {

   }
   uint public ticketPrice = 100000000000000000;
 
   function getPlayerAddr() constant returns (address[10] addr) {
        uint currentGameInd = games.length;
		require(currentGameInd > 0);
        var currentGame = games[currentGameInd-1];
        var bets = currentGame.bets;
        var len = bets.length;
		for (var index = 0; index < 10; index++) {
            if (len > index) {
                addr[index] = bets[len-index-1].betAddr;
            } else {
                addr[index] = address(0x0);
            }
        }
   }

    function getOne() constant returns(int) {
        return 1;
    }

   // get list player for current game
   function getPlayers() constant returns (address[10] addr,uint8[4][10] numbers ) {
	    uint currentGameInd = games.length;
		require(currentGameInd > 0);
        var currentGame = games[currentGameInd-1];
        var bets = currentGame.bets;
        var len = bets.length;
		for (var index = 0; index < 10; index++) {
            if (len > index) {
                addr[index] = bets[len-index-1].betAddr;
                numbers[index][0] = bets[len-index-1].firstNumber;
                numbers[index][1] = bets[len-index-1].secondNumber;
                numbers[index][2] = bets[len-index-1].thirdNumber;
                numbers[index][3] = bets[len-index-1].fourthNumber;
            }
            else {
                addr[index] = address(0x0);
                numbers[index][0] = 0;
                numbers[index][1] = 0;
                numbers[index][2] = 0;
                numbers[index][3] = 0;
            }
        }
   }
      
    // this method is for other smart contract to call to
    function bet(address betAddr, uint8 firstNumber, uint8 secondNumber, uint8 thirdNumber, uint8 fourthNumber) payable {
        require(msg.value == ticketPrice);
        uint currentGameInd = games.length-1;
        require(currentGameInd >= 0);
        var currentGame = games[currentGameInd];
        require(currentGame.isEnable);
        currentGame.bets.push(Ticket({
             betAddr : betAddr,
            firstNumber : firstNumber,
            secondNumber : secondNumber,
            thirdNumber : thirdNumber,
            fourthNumber : fourthNumber
 
        }));
    } 

     modifier OnlyOwner()
     {
         require(owner == msg.sender);
         _;
     }

    
    function draw(uint8[] resultNumbers) OnlyOwner 
    {
      // Create a random ticket, and find the winner
        // algorithm of randomness will be impliment later, now, let's hard code it
        require(resultNumbers.length == 4);
        var winningtk = Ticket({
            betAddr: address(0x0),
            firstNumber : resultNumbers[0],
            secondNumber : resultNumbers[1],
            thirdNumber : resultNumbers[2],
            fourthNumber : resultNumbers[3]
        });
        winningTickets.push(winningtk);
        var currentGameInd = games.length-1;
        require(currentGameInd >= 0);
        var currentGame = games[currentGameInd];
        require(currentGame.isEnable);
        currentGame.winningTicket = winningtk;
        for (var index = 0; index < currentGame.bets.length; index++) {
            var ticket = currentGame.bets[index];
             
            if (ticket.firstNumber == winningtk.firstNumber && 
            ticket.secondNumber == winningtk.secondNumber &&
            ticket.thirdNumber == winningtk.thirdNumber &&
            ticket.fourthNumber == winningtk.fourthNumber) {
                winner[currentGameInd].push(ticket);    
            }
        }

        // transfer money to winner.
        if (winner[currentGameInd].length > 0) {
          // it means: there is at least 1 winner:
          var numberOfWinner = winner[currentGameInd].length;
          var prize = this.balance * 9/10;
          var ownerFee = this.balance * 8/100;
          var eachWinnerPrize = prize / numberOfWinner;
          for (var ind = 0; ind < numberOfWinner; ind++) {
              winner[currentGameInd][ind].betAddr.transfer(eachWinnerPrize);
              owner.transfer(ownerFee);
          }
        }
        // whatever happen, just disable current game and create a new game
        currentGame.isEnable = false;

        games.length += 1;
        games[games.length - 1].isEnable = true;
    }  
}