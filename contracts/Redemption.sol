pragma solidity ^0.4.4;

contract Redemption {
   
    uint public endingTime;
    address public owner;
    // approver is the one who approve the redemption and send item to users, mark the redemption as completed
    mapping (address =>bool) approvers; 
    mapping (address =>mapping(address=>RedemptionItem)) redemptions; 
    mapping (address =>Item) public items;
    struct Item {
        address itemAddress;
        uint itemValue;
        uint availableAmount;
    }
    struct RedemptionItem {
        address itemAddress;
        uint amount;
        string[] logMessages;
    }

    modifier onlyOwner() {require(msg.sender == owner);_;}
    modifier onlyApprover() {require(approvers[msg.sender]);_;}

    // constructor 
    function Redemption(address[]  _approvers) public {
        owner = msg.sender;
          for (var i = 0; i < _approvers.length; i++) {
            approvers[_approvers[i]] = true;
        }
    }
    // any user can send point to make a redemption
    function redeem (address _itemAddress) public payable {
          // check if amount he send is fulfill
         if (items[_itemAddress].itemValue == msg.value && items[_itemAddress].availableAmount > 0) {
             items[_itemAddress].availableAmount -= 1;
             if (redemptions[msg.sender][_itemAddress].itemAddress == address(0x0)) {
                 redemptions[msg.sender][_itemAddress].itemAddress = _itemAddress;
                 redemptions[msg.sender][_itemAddress].amount = 1;
             } else {
                 redemptions[msg.sender][_itemAddress].amount += 1;
             } 

          } else {
              revert();
          } 
    }

    // owner can add item to itemlist for redemption
    function addItem(address _itemAddress, uint _itemValue, uint _amount) public onlyOwner {
        if (items[_itemAddress].itemAddress == address(0x0)) {
            items[_itemAddress].itemAddress = _itemAddress;
            items[_itemAddress].itemValue = _itemValue;
            items[_itemAddress].availableAmount = _amount;
        } else {
            items[_itemAddress].availableAmount += _amount;
        }
    }

    // approver can send or cancel redemption offchain and record it onchain
    function completeRedemption(address _userAddress, address _itemAdress, uint _effectedAmount, string _message) public onlyApprover {
        require (redemptions[_userAddress][_itemAdress].amount > 0 && redemptions[_userAddress][_itemAdress].amount <= _effectedAmount);
        redemptions[_userAddress][_itemAdress].amount -= _effectedAmount;
        redemptions[_userAddress][_itemAdress].logMessages.push(_message);
    }
}