// @audit-ok - tx.origin can figure out tokenId, since Turnstile is ERC721 Enumerable: https://docs.canto.io/evm-development/contract-secured-revenue
Bio.constructor() (src/Bio.sol#33-42) ignores return value by turnstile.register(tx.origin) (src/Bio.sol#40)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#unused-return

// @audit-ok
Bio.tokenURI(uint256) (src/Bio.sol#48-133) uses assembly
        - INLINE ASM (src/Bio.sol#102-105)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#assembly-usage

// @audit-ok - mentioned in automated findings
Pragma version>=0.8.0 (interface/Turnstile.sol#2) allows old versions
Pragma version>=0.8.0 (src/Bio.sol#2) allows old versions
solc-0.8.19 is not recommended for deployment
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#incorrect-versions-of-solidity

// @audit-ok - mentioned
Parameter Bio.tokenURI(uint256)._id (src/Bio.sol#48) is not in mixedCase
Parameter Bio.mint(string)._bio (src/Bio.sol#139) is not in mixedCase
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#conformance-to-solidity-naming-conventions
. analyzed (30 contracts with 81 detectors), 7 result(s) found