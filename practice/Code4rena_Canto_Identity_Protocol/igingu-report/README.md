# https://code4rena.com/contests/2023-01-canto-identity-protocol-contest

SolidityLang conventions: parameters not in mixed case, imports should be ordered

Slither variable name is too close Variable CidNFT.add(uint256,string,uint256,uint256,CidNFT.AssociationType)._nftIDToAdd (src/CidNFT.sol#170) is too similar to CidNFT.add(uint256,string,uint256,uint256,CidNFT.AssociationType).nftIDsToAdd (src/CidNFT.sol#217)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#variable-names-too-similar

Should emit events before handing execution to other contracts

Cleaner code: just return         cidNFTID = cidNFTs[_user];

Events spend gas to print msg.sender

Incorrect comment:     /// @dev Data types are chosen such that all data fits in one slot - uses 2 slots

baseURI could be immutable in CidNFT.sol

.json should be constant

pragmas should be locked
