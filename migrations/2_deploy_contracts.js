 
var Jackpot = artifacts.require("./Jackpot.sol");
var JackpotEntry = artifacts.require("./JackpotEntry.sol");
 

module.exports = function(deployer) {
  deployer.deploy(Jackpot);
  deployer.link(Jackpot, JackpotEntry);
  deployer.deploy(JackpotEntry);
};
