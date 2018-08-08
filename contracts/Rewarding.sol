pragma solidity ^0.4.4;

contract Rewarding {
   
    uint public startingTime;
    uint public endingTime;
    uint public totalRewardingToken;
    mapping(address=>bool) public verifiers;
    uint public availableToken;
    address public owner;
    // there are 2 type of rewarding: Fixed amount for all participants and shared amount, devided by how many participants
    // with fixed amount type: fixrewardingAmount will be greater than 0
    uint public fixRewardingAmount;
    mapping(address => Participant) public participants;
    Participant[] public participantArr;
    struct Participant {
        address participantAddress;
        uint rewardingPoint;
        
    }

    modifier onlyBefore(uint _time) {require(now < _time); _;}
    modifier onlyAfter(uint _time) {require(now > _time); _;}
    modifier onlyOwner() {require(msg.sender == owner);_;}

    // constructor 
    function Rewarding(
        uint _duration,
        address[] _verifiers,
        uint _fixRewardingAmount
    ) public payable {
        startingTime = now;
        endingTime = now + _duration;
        totalRewardingToken = msg.value;
        availableToken = msg.value;
        owner = msg.sender;
        fixRewardingAmount = _fixRewardingAmount;
        for (var i = 0; i < _verifiers.length; i++) {
            verifiers[_verifiers[i]] = true;
        }
    }

    // after verifying offchain, approver will public the result in blockchain.
    function approve (address participantAddress) public onlyBefore(endingTime)
    {
        //only verifier can add participant
        if (verifiers[msg.sender]) {
            // for fix amount rewarding point
            if (fixRewardingAmount > 0 && availableToken > fixRewardingAmount) {
                if (participants[participantAddress].rewardingPoint > 0) {
                        availableToken -= fixRewardingAmount;
                        participants[participantAddress].rewardingPoint += fixRewardingAmount;
                    } else {
                        availableToken -= fixRewardingAmount;
                        participants[participantAddress].rewardingPoint = fixRewardingAmount;
                    } 
            } else {
                participants[participantAddress].rewardingPoint = 0; // calculation will be done after campaign is over     
            }

            if (fixRewardingAmount == 0) {
                participantArr.push(Participant({
                participantAddress:participantAddress,
                rewardingPoint : 0
            }));  
            } 
         
        } 
    }

    // this function will be used at type shared rewarding token
    function rewardCalculation() public onlyOwner onlyBefore(endingTime) {
        if (fixRewardingAmount == 0) {
            uint rewardingValue = totalRewardingToken / participantArr.length;
            for (var index = 0; index < participantArr.length; index++) {
                participants[participantArr[index].participantAddress].participantAddress = participantArr[index].participantAddress;
                participants[participantArr[index].participantAddress].rewardingPoint = rewardingValue;
            }
        }
    }

    // participant must withdraw after campaign is over
    function withdraw() public onlyBefore(endingTime) {
        uint amount = participants[msg.sender].rewardingPoint;
        if (amount > 0) {
          
            participants[msg.sender].rewardingPoint = 0;

            msg.sender.transfer(amount);
        }
    }
}