pragma solidity ^0.4.4;

contract LuckyDraw {
    
    string public name;
    string public desc;
    address public owner;
    address public creator;
    bool public isLocked;

    uint public stopReceivingBet;
    uint public startReceivingResult;

    Player[] private playerList;

    PlayerMapping[] private MappingList;

    Rule[] private ruleList;

    struct PlayerMapping
    {
        address contractId;
        Player from;
        Player to;
        uint amount;

        // this below 2 number should be the same, else, we say there is a conflict between them
        int fromConfirm; // -1 or 1. -1 mean A win, 1 mean B win
        int toConfirm; // -1 or 1. -1 mean A win, 1 mean B win
    }

    struct Player {
        address playerAddress;
        uint amount;
        int8 side; // -1 or 1: -1 mean side A, 1 site B
    }

    // 
    struct Rule 
    {
        string ruleDescription;

        // can be negative or possitive 
        // 50% meaning: A win 50%
        // -100% mean A lose 100%
        int receivingRatio; 
    }

    modifier onlyOwner() {
        require (msg.sender == owner);
        _;
    }

    modifier onlyCreator() {
        require (msg.sender == owner);
        _;
    }

    constructor (string _name, string _desc, address _owner ) public {
        name = _name;
        desc = _desc;
        creator = msg.sender;
        isLocked = false;
        owner = _owner;
    }

    function addRule(string desc, int ratio) onlyCreator public
    {
        Rule memory rule = Rule(desc,ratio);
        ruleList.push(rule);
    }

    function lock() onlyCreator public
    {
        isLocked = true;
    }

    function bet(int8 side) payable public
    {
        Player memory player = Player(msg.sender,msg.value,side);

        playerList.push(player);
        // todo: find a mapping for her/him

    } 

    function confirmResult() public
    {
        
    }

    function receiveMoney() public 
    {
        //call this function in order to get your money back! 
    }
}