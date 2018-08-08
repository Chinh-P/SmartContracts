pragma solidity ^0.4.11;

contract FileAuthenV2 {      
    
    struct AuthenSession {
        uint nounce;
        string requestorIp;
        uint sessionEnd;
        uint approverCounting;
        uint rejecterCounting;
        mapping(address => bool) approvers;
    }
    struct FileInformation {
        string fileName;
        uint minimumConfirmation;
        uint totalOwner;
        bool byMajority;
        mapping(address => bool) owners;
        mapping(address => bool) viewers;
    }
    mapping (address => FileInformation) public files;
    mapping(address => AuthenSession[]) public authens;
      
    // event received(string message);
    // event log(uint value);

    function registerFileInfo(address fileId, string fileName, bool byMajority, uint minimumConfirmation, address[] owners,address[] viewers) {
        // check permission before allow to call to prevent overwrite!
        files[fileId].fileName = fileName;
        files[fileId].minimumConfirmation = minimumConfirmation;
        files[fileId].byMajority = byMajority;
        files[fileId].totalOwner = 0;
        for (uint index = 0; index < owners.length; index++) {
            files[fileId].owners[owners[index]] = true;
            files[fileId].totalOwner++;
        }

        for (uint i = 0; i < viewers.length; i++) {
            files[fileId].viewers[viewers[i]] = true;
        }
    }

// note that this design is not suitable for multi thread 
     function getAuthStt(address fileId, uint nounce ) constant returns(string) {
         if (files[fileId].minimumConfirmation == 0 && !files[fileId].byMajority)
            return "File Not yet registered"; // not yet registered file or sender dont have permission to view.
        //  else if( !files[fileId].owners[msg.sender] || !files[fileId].viewers[msg.sender])
        //     return "permission denied";
         else if (authens[fileId].length > 0 ) {
            AuthenSession ss = authens[fileId][authens[fileId].length-1];
            if (ss.nounce == nounce) {
               if (files[fileId].byMajority) {
                   if (ss.approverCounting * 2 > files[fileId].totalOwner) {
                       return "Y";
                   } else if (ss.rejecterCounting * 2 >= files[fileId].totalOwner) {
                       return "N";
                   } else {
                       return "waiting for confirmation by majority";
                   }
               } else {
                   uint minimumConfirm = files[fileId].minimumConfirmation;
                uint currentConfirm = ss.approverCounting;
                if (minimumConfirm <= currentConfirm )
                    return "Y";
                else if (minimumConfirm < files[fileId].totalOwner - ss.rejecterCounting)
                    return "N";
                else 
                    return "waiting for confirmation by noc";
               }
                
            }
         }
    }

    function countAppr(address fileId) returns(uint) {
        uint length = authens[fileId].length;
        if (length > 0) {
            return authens[fileId][length-1].approverCounting;
        }
        return 0;
    }

    function countRejecter(address fileId) returns(uint) {
        uint length = authens[fileId].length;
        if (length > 0) {
            return authens[fileId][length-1].rejecterCounting;
        }
        return 0;
    }
    
    function countAuth(address fileId) returns(uint) {
        return authens[fileId].length;
    }

    function responseAuthen(address fileId,uint stt, uint nounce) {
        // there is a security bug right here, but for demo purpose, we ignore it for now.
        if ((files[fileId].minimumConfirmation == 0 && !files[fileId].byMajority) || !files[fileId].owners[msg.sender])
            return;
        
        var length = authens[fileId].length;
          
        if (length > 0 && authens[fileId][length-1].nounce == nounce) {
            // not yet vote
            if (!authens[fileId][length-1].approvers[msg.sender]) {
                if (stt == 1) {
                    authens[fileId][length-1].approvers[msg.sender] = true;
                    authens[fileId][length-1].approverCounting++;
                } else {
                    authens[fileId][length-1].approvers[msg.sender] = false;
                    authens[fileId][length-1].rejecterCounting++;
                }
            }
        } else {
            // totally new authen session
            authens[fileId].length++;
            authens[fileId][length].nounce = nounce;
             if (stt == 1) {
                    authens[fileId][length].approvers[msg.sender] = true;
                    authens[fileId][length].approverCounting++;
                } else {
                    authens[fileId][length].approvers[msg.sender] = false;
                    authens[fileId][length].rejecterCounting++;
                }
        }
    }

    function getOne() constant returns(string) {
        return "1";
    }
}