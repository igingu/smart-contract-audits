// @audit-ok - tx.origin can figure out tokenId, since Turnstile is ERC721 Enumerable: https://docs.canto.io/evm-development/contract-secured-revenue
ProfilePicture.constructor(address,string) (src/ProfilePicture.sol#57-68) ignores return value by turnstile.register(tx.origin) (src/ProfilePicture.sol#66)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#unused-return

// @audit-ok - not a problem
ICidNFT.addressRegistry().addressRegistry (interface/ICidNFT.sol#20) shadows:
        - ICidNFT.addressRegistry() (interface/ICidNFT.sol#20) (function)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#local-variable-shadowing

// @audit-ok - mentioned in automated findings
Pragma version>=0.8.0 (interface/IAddressRegistry.sol#2) allows old versions
Pragma version>=0.8.0 (interface/ICidNFT.sol#2) allows old versions
Pragma version>=0.8.0 (interface/IERC721.sol#2) allows old versions
Pragma version>=0.8.0 (interface/Turnstile.sol#2) allows old versions
Pragma version>=0.8.0 (src/ProfilePicture.sol#2) allows old versions
solc-0.8.19 is not recommended for deployment
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#incorrect-versions-of-solidity

// @audit-ok - mentioned
Parameter ProfilePicture.tokenURI(uint256)._id (src/ProfilePicture.sol#73) is not in mixedCase
Parameter ProfilePicture.mint(address,uint256)._nftContract (src/ProfilePicture.sol#82) is not in mixedCase
Parameter ProfilePicture.mint(address,uint256)._nftID (src/ProfilePicture.sol#82) is not in mixedCase
Parameter ProfilePicture.getPFP(uint256)._pfpID (src/ProfilePicture.sol#100) is not in mixedCase
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#conformance-to-solidity-naming-conventions

// @audit-ok - not in scope
Variable ICidNFT.getPrimaryCIDNFT(string,uint256)._subprotocolNFTID (interface/ICidNFT.sol#58) is too similar to ICidNFT.getActiveData(uint256,string).subprotocolNFTIDs (interface/ICidNFT.sol#66)
Variable ICidNFT.getActiveCIDNFT(string,uint256)._subprotocolNFTID (interface/ICidNFT.sol#74) is too similar to ICidNFT.getActiveData(uint256,string).subprotocolNFTIDs (interface/ICidNFT.sol#66)
Variable ICidNFT.getOrderedCIDNFT(string,uint256)._subprotocolNFTID (interface/ICidNFT.sol#48) is too similar to ICidNFT.getActiveData(uint256,string).subprotocolNFTIDs (interface/ICidNFT.sol#66)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#variable-names-too-similar
. analyzed (16 contracts with 81 detectors), 15 result(s) found