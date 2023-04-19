Reentrancy in CidNFT.add(uint256,string,uint256,uint256,CidNFT.AssociationType) (src/CidNFT.sol#166-230):
        External calls:
        - nftToAdd.safeTransferFrom(msg.sender,address(this),_nftIDToAdd) (src/CidNFT.sol#188)
        - remove(_cidNFTID,_subprotocolName,_key,0,_type) (src/CidNFT.sol#200)
                - nftToRemove.safeTransferFrom(address(this),msg.sender,currNFTID) (src/CidNFT.sol#265)
                - nftToRemove.safeTransferFrom(address(this),msg.sender,currNFTID_scope_0) (src/CidNFT.sol#271)
                - nftToRemove.safeTransferFrom(address(this),msg.sender,_nftIDToRemove) (src/CidNFT.sol#286)
        State variables written after the call(s):
        - cidData[_cidNFTID][_subprotocolName].ordered[_key] = _nftIDToAdd (src/CidNFT.sol#202)
Reentrancy in CidNFT.add(uint256,string,uint256,uint256,CidNFT.AssociationType) (src/CidNFT.sol#166-230):
        External calls:
        - nftToAdd.safeTransferFrom(msg.sender,address(this),_nftIDToAdd) (src/CidNFT.sol#188)
        - remove(_cidNFTID,_subprotocolName,0,0,_type) (src/CidNFT.sol#208)
                - nftToRemove.safeTransferFrom(address(this),msg.sender,currNFTID) (src/CidNFT.sol#265)
                - nftToRemove.safeTransferFrom(address(this),msg.sender,currNFTID_scope_0) (src/CidNFT.sol#271)
                - nftToRemove.safeTransferFrom(address(this),msg.sender,_nftIDToRemove) (src/CidNFT.sol#286)
        State variables written after the call(s):
        - cidData[_cidNFTID][_subprotocolName].primary = _nftIDToAdd (src/CidNFT.sol#210)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#reentrancy-vulnerabilities-1
slither/wiki/Detector-Documentation#missing-zero-address-validation

Reentrancy in CidNFT.add(uint256,string,uint256,uint256,CidNFT.AssociationType) (src/CidNFT.sol#166-230):
        External calls:
        - nftToAdd.safeTransferFrom(msg.sender,address(this),_nftIDToAdd) (src/CidNFT.sol#188)
        State variables written after the call(s):
        - activeData.values = nftIDsToAdd (src/CidNFT.sol#219)
        - activeData.positions[_nftIDToAdd] = 1 (src/CidNFT.sol#220)
        - activeData.values.push(_nftIDToAdd) (src/CidNFT.sol#225)
        - activeData.positions[_nftIDToAdd] = lengthBeforeAddition + 1 (src/CidNFT.sol#226)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#reentrancy-vulnerabilities-2

Reentrancy in CidNFT.add(uint256,string,uint256,uint256,CidNFT.AssociationType) (src/CidNFT.sol#166-230):
        External calls:
        - nftToAdd.safeTransferFrom(msg.sender,address(this),_nftIDToAdd) (src/CidNFT.sol#188)
        - remove(_cidNFTID,_subprotocolName,_key,0,_type) (src/CidNFT.sol#200)
                - nftToRemove.safeTransferFrom(address(this),msg.sender,currNFTID) (src/CidNFT.sol#265)
                - nftToRemove.safeTransferFrom(address(this),msg.sender,currNFTID_scope_0) (src/CidNFT.sol#271)
                - nftToRemove.safeTransferFrom(address(this),msg.sender,_nftIDToRemove) (src/CidNFT.sol#286)
        Event emitted after the call(s):
        - ActiveDataRemoved(_cidNFTID,_subprotocolName,_nftIDToRemove) (src/CidNFT.sol#287)
                - remove(_cidNFTID,_subprotocolName,_key,0,_type) (src/CidNFT.sol#200)
        - OrderedDataAdded(_cidNFTID,_subprotocolName,_key,_nftIDToAdd) (src/CidNFT.sol#203)
        - OrderedDataRemoved(_cidNFTID,_subprotocolName,_key,_nftIDToRemove) (src/CidNFT.sol#266)
                - remove(_cidNFTID,_subprotocolName,_key,0,_type) (src/CidNFT.sol#200)
        - PrimaryDataRemoved(_cidNFTID,_subprotocolName,_nftIDToRemove) (src/CidNFT.sol#272)
                - remove(_cidNFTID,_subprotocolName,_key,0,_type) (src/CidNFT.sol#200)
Reentrancy in CidNFT.add(uint256,string,uint256,uint256,CidNFT.AssociationType) (src/CidNFT.sol#166-230):
        External calls:
        - nftToAdd.safeTransferFrom(msg.sender,address(this),_nftIDToAdd) (src/CidNFT.sol#188)
        - remove(_cidNFTID,_subprotocolName,0,0,_type) (src/CidNFT.sol#208)
                - nftToRemove.safeTransferFrom(address(this),msg.sender,currNFTID) (src/CidNFT.sol#265)
                - nftToRemove.safeTransferFrom(address(this),msg.sender,currNFTID_scope_0) (src/CidNFT.sol#271)
                - nftToRemove.safeTransferFrom(address(this),msg.sender,_nftIDToRemove) (src/CidNFT.sol#286)
        Event emitted after the call(s):
        - ActiveDataRemoved(_cidNFTID,_subprotocolName,_nftIDToRemove) (src/CidNFT.sol#287)
                - remove(_cidNFTID,_subprotocolName,0,0,_type) (src/CidNFT.sol#208)
        - OrderedDataRemoved(_cidNFTID,_subprotocolName,_key,_nftIDToRemove) (src/CidNFT.sol#266)
                - remove(_cidNFTID,_subprotocolName,0,0,_type) (src/CidNFT.sol#208)
        - PrimaryDataAdded(_cidNFTID,_subprotocolName,_nftIDToAdd) (src/CidNFT.sol#211)
        - PrimaryDataRemoved(_cidNFTID,_subprotocolName,_nftIDToRemove) (src/CidNFT.sol#272)
                - remove(_cidNFTID,_subprotocolName,0,0,_type) (src/CidNFT.sol#208)
Reentrancy in CidNFT.add(uint256,string,uint256,uint256,CidNFT.AssociationType) (src/CidNFT.sol#166-230):
        External calls:
        - nftToAdd.safeTransferFrom(msg.sender,address(this),_nftIDToAdd) (src/CidNFT.sol#188)
        Event emitted after the call(s):
        - ActiveDataAdded(_cidNFTID,_subprotocolName,_nftIDToAdd,lengthBeforeAddition) (src/CidNFT.sol#228)
Reentrancy in CidNFT.remove(uint256,string,uint256,uint256,CidNFT.AssociationType) (src/CidNFT.sol#238-289):
        External calls:
        - nftToRemove.safeTransferFrom(address(this),msg.sender,currNFTID) (src/CidNFT.sol#265)
        Event emitted after the call(s):
        - OrderedDataRemoved(_cidNFTID,_subprotocolName,_key,_nftIDToRemove) (src/CidNFT.sol#266)
Reentrancy in CidNFT.remove(uint256,string,uint256,uint256,CidNFT.AssociationType) (src/CidNFT.sol#238-289):
        External calls:
        - nftToRemove.safeTransferFrom(address(this),msg.sender,currNFTID_scope_0) (src/CidNFT.sol#271)
        Event emitted after the call(s):
        - PrimaryDataRemoved(_cidNFTID,_subprotocolName,_nftIDToRemove) (src/CidNFT.sol#272)
Reentrancy in CidNFT.remove(uint256,string,uint256,uint256,CidNFT.AssociationType) (src/CidNFT.sol#238-289):
        External calls:
        - nftToRemove.safeTransferFrom(address(this),msg.sender,_nftIDToRemove) (src/CidNFT.sol#286)
        Event emitted after the call(s):
        - ActiveDataRemoved(_cidNFTID,_subprotocolName,_nftIDToRemove) (src/CidNFT.sol#287)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#reentrancy-vulnerabilities-3

// @audit-ok
CidNFT.mint(bytes[]) (src/CidNFT.sol#148-158) has external calls inside a loop: (success) = address(this).delegatecall(abi.encodePacked(addSelector,_addList[i])) (src/CidNFT.sol#152-155)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation/#calls-inside-a-loop

Pragma version>=0.8.0 (src/AddressRegistry.sol#2) allows old versions
Pragma version>=0.8.0 (src/CidNFT.sol#2) allows old versions
Pragma version>=0.8.0 (src/SubprotocolRegistry.sol#2) allows old versions
solc-0.8.19 is not recommended for deployment
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#incorrect-versions-of-solidity

Low level call in CidNFT.mint(bytes[]) (src/CidNFT.sol#148-158):
        - (success) = address(this).delegatecall(abi.encodePacked(addSelector,_addList[i])) (src/CidNFT.sol#152-155)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#low-level-calls

// @audit-ok
Parameter AddressRegistry.register(uint256)._cidNFTID (src/AddressRegistry.sol#42) is not in mixedCase
Parameter AddressRegistry.getCID(address)._user (src/AddressRegistry.sol#62) is not in mixedCase
Parameter CidNFT.tokenURI(uint256)._id (src/CidNFT.sol#137) is not in mixedCase
Parameter CidNFT.mint(bytes[])._addList (src/CidNFT.sol#148) is not in mixedCase
Parameter CidNFT.add(uint256,string,uint256,uint256,CidNFT.AssociationType)._cidNFTID (src/CidNFT.sol#167) is not in mixedCase
Parameter CidNFT.add(uint256,string,uint256,uint256,CidNFT.AssociationType)._subprotocolName (src/CidNFT.sol#168) is not in mixedCase      
Parameter CidNFT.add(uint256,string,uint256,uint256,CidNFT.AssociationType)._key (src/CidNFT.sol#169) is not in mixedCase
Parameter CidNFT.add(uint256,string,uint256,uint256,CidNFT.AssociationType)._nftIDToAdd (src/CidNFT.sol#170) is not in mixedCase
Parameter CidNFT.add(uint256,string,uint256,uint256,CidNFT.AssociationType)._type (src/CidNFT.sol#171) is not in mixedCase
Parameter CidNFT.remove(uint256,string,uint256,uint256,CidNFT.AssociationType)._cidNFTID (src/CidNFT.sol#239) is not in mixedCase
Parameter CidNFT.remove(uint256,string,uint256,uint256,CidNFT.AssociationType)._subprotocolName (src/CidNFT.sol#240) is not in mixedCase   
Parameter CidNFT.remove(uint256,string,uint256,uint256,CidNFT.AssociationType)._key (src/CidNFT.sol#241) is not in mixedCase
Parameter CidNFT.remove(uint256,string,uint256,uint256,CidNFT.AssociationType)._nftIDToRemove (src/CidNFT.sol#242) is not in mixedCase     
Parameter CidNFT.remove(uint256,string,uint256,uint256,CidNFT.AssociationType)._type (src/CidNFT.sol#243) is not in mixedCase
Parameter CidNFT.getOrderedData(uint256,string,uint256)._cidNFTID (src/CidNFT.sol#297) is not in mixedCase
Parameter CidNFT.getOrderedData(uint256,string,uint256)._subprotocolName (src/CidNFT.sol#298) is not in mixedCase
Parameter CidNFT.getOrderedData(uint256,string,uint256)._key (src/CidNFT.sol#299) is not in mixedCase
Parameter CidNFT.getPrimaryData(uint256,string)._cidNFTID (src/CidNFT.sol#308) is not in mixedCase
Parameter CidNFT.getPrimaryData(uint256,string)._subprotocolName (src/CidNFT.sol#308) is not in mixedCase
Parameter CidNFT.getActiveData(uint256,string)._cidNFTID (src/CidNFT.sol#320) is not in mixedCase
Parameter CidNFT.getActiveData(uint256,string)._subprotocolName (src/CidNFT.sol#320) is not in mixedCase
Parameter CidNFT.activeDataIncludesNFT(uint256,string,uint256)._cidNFTID (src/CidNFT.sol#333) is not in mixedCase
Parameter CidNFT.activeDataIncludesNFT(uint256,string,uint256)._subprotocolName (src/CidNFT.sol#334) is not in mixedCase
Parameter CidNFT.activeDataIncludesNFT(uint256,string,uint256)._nftIDToCheck (src/CidNFT.sol#335) is not in mixedCase
Parameter SubprotocolRegistry.register(bool,bool,bool,address,string,uint96)._ordered (src/SubprotocolRegistry.sol#81) is not in mixedCase 
Parameter SubprotocolRegistry.register(bool,bool,bool,address,string,uint96)._primary (src/SubprotocolRegistry.sol#82) is not in mixedCase 
Parameter SubprotocolRegistry.register(bool,bool,bool,address,string,uint96)._active (src/SubprotocolRegistry.sol#83) is not in mixedCase  
Parameter SubprotocolRegistry.register(bool,bool,bool,address,string,uint96)._nftAddress (src/SubprotocolRegistry.sol#84) is not in mixedCase
Parameter SubprotocolRegistry.register(bool,bool,bool,address,string,uint96)._name (src/SubprotocolRegistry.sol#85) is not in mixedCase    
Parameter SubprotocolRegistry.register(bool,bool,bool,address,string,uint96)._fee (src/SubprotocolRegistry.sol#86) is not in mixedCase     
Parameter SubprotocolRegistry.getSubprotocol(string)._name (src/SubprotocolRegistry.sol#107) is not in mixedCase
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#conformance-to-solidity-naming-conventions

// @audit-ok
Variable CidNFT.add(uint256,string,uint256,uint256,CidNFT.AssociationType)._nftIDToAdd (src/CidNFT.sol#170) is too similar to CidNFT.add(uint256,string,uint256,uint256,CidNFT.AssociationType).nftIDsToAdd (src/CidNFT.sol#217)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#variable-names-too-similar