// @audit-ok
Function not found expectRevert
Impossible to generate IR for NamespaceTest.testFuseCharacterWithSkinToneModifier:
 'NoneType' object has no attribute 'type'

// @audit-ok it is intended like that
Utils.generateSVG(Tray.TileData[],bool) (src/Utils.sol#227-256) performs a multiplication on the result of a division:
        - dx = 400 / (_tiles.length + 1) (src/Utils.sol#229)
        - innerData = string.concat(innerData,<text dominant-baseline="middle" text-anchor="middle" y="100" x=",LibString.toString(dx * (i + 1)),">,string(characterToUnicodeBytes(_tiles[i].fontClass,_tiles[i].characterIndex,_tiles[i].characterModifier)),</text>) (src/Utils.sol#231-240)
Utils.generateSVG(Tray.TileData[],bool) (src/Utils.sol#227-256) performs a multiplication on the result of a division:
        - dx = 400 / (_tiles.length + 1) (src/Utils.sol#229)
        - innerData = string.concat(innerData,<rect width="34" height="60" y="70" x=",LibString.toString(dx * (i + 1) - 17)," stroke="black" stroke-width="1" fill="none"></rect>) (src/Utils.sol#242-247)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#divide-before-multiply

// @audit-ok - mentioned
Tray.tokenURI(uint256).i (src/Tray.sol#136) is a local variable never initialized
Tray.buy(uint256).i (src/Tray.sol#166) is a local variable never initialized
Utils.characterToUnicodeBytes(uint8,uint16,uint256).startingSequence (src/Utils.sol#180) is a local variable never initialized
Tray.buy(uint256).trayTiledata (src/Tray.sol#167) is a local variable never initialized
Utils.characterToUnicodeBytes(uint8,uint16,uint256).i_scope_2 (src/Utils.sol#150) is a local variable never initialized
Utils.characterToUnicodeBytes(uint8,uint16,uint256).i_scope_5 (src/Utils.sol#169) is a local variable never initialized
Utils.characterToUnicodeBytes(uint8,uint16,uint256).supportsSkinToneModifier (src/Utils.sol#82) is a local variable never initialized
Tray.buy(uint256).j (src/Tray.sol#168) is a local variable never initialized
Utils.characterToUnicodeBytes(uint8,uint16,uint256).i_scope_3 (src/Utils.sol#160) is a local variable never initialized
Utils.generateSVG(Tray.TileData[],bool).i (src/Utils.sol#230) is a local variable never initialized
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#uninitialized-local-variables

// @audit-ok not needed
Namespace.constructor(address,address,address) (src/Namespace.sol#73-89) ignores return value by turnstile.register(tx.origin) (src/Namespace.sol#87)
Tray.constructor(bytes32,uint256,address,address,address) (src/Tray.sol#102-122) ignores return value by turnstile.register(tx.origin) (src/Tray.sol#120)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#unused-return

// @audit-ok caught by automatic analyzer
Namespace.constructor(address,address,address)._revenueAddress (src/Namespace.sol#76) lacks a zero-check on :
                - revenueAddress = _revenueAddress (src/Namespace.sol#80)
Namespace.changeRevenueAddress(address)._newRevenueAddress (src/Namespace.sol#213) lacks a zero-check on :
                - revenueAddress = _newRevenueAddress (src/Namespace.sol#215)
Tray.changeRevenueAddress(address)._newRevenueAddress (src/Tray.sol#225) lacks a zero-check on :
                - revenueAddress = _newRevenueAddress (src/Tray.sol#227)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#missing-zero-address-validation

// @audit-ok intended
Namespace.fuse(Namespace.CharacterData[]) (src/Namespace.sol#113-189) has external calls inside a loop: tileData = tray.getTile(trayID,tileOffset) (src/Namespace.sol#139)
Namespace.fuse(Namespace.CharacterData[]) (src/Namespace.sol#113-189) has external calls inside a loop: trayOwner = tray.ownerOf(trayID) (src/Namespace.sol#164)
Namespace.fuse(Namespace.CharacterData[]) (src/Namespace.sol#113-189) has external calls inside a loop: trayOwner != msg.sender && tray.getApproved(trayID) != msg.sender && ! tray.isApprovedForAll(trayOwner,msg.sender) (src/Namespace.sol#166-168)
Namespace.fuse(Namespace.CharacterData[]) (src/Namespace.sol#113-189) has external calls inside a loop: tray.burn(uniqueTrays[i_scope_1]) (src/Namespace.sol#184)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation/#calls-inside-a-loop

// @audit-ok 
Namespace.fuse(Namespace.CharacterData[]) (src/Namespace.sol#113-189) uses assembly
        - INLINE ASM (src/Namespace.sol#174-176)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#assembly-usage

Tray.buy(uint256) (src/Tray.sol#157-175) has costly operations inside a loop:
        - lastHash = keccak256(bytes)(abi.encode(lastHash)) (src/Tray.sol#169)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#costly-operations-inside-a-loop

// @audit-ok in analyzer automatic
Pragma version>=0.8.0 (interface/Turnstile.sol#2) allows old versions
Pragma version>=0.8.0 (src/Namespace.sol#2) allows old versions
Pragma version>=0.8.0 (src/Tray.sol#2) allows old versions
Pragma version>=0.8.0 (src/Utils.sol#2) allows old versions
solc-0.8.19 is not recommended for deployment
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#incorrect-versions-of-solidity

// @audit-ok mentioned
Parameter Namespace.tokenURI(uint256)._id (src/Namespace.sol#93) is not in mixedCase
Parameter Namespace.fuse(Namespace.CharacterData[])._characterList (src/Namespace.sol#113) is not in mixedCase
Parameter Namespace.burn(uint256)._id (src/Namespace.sol#193) is not in mixedCase
Parameter Namespace.changeNoteAddress(address)._newNoteAddress (src/Namespace.sol#205) is not in mixedCase
Parameter Namespace.changeRevenueAddress(address)._newRevenueAddress (src/Namespace.sol#213) is not in mixedCase
Parameter Tray.tokenURI(uint256)._id (src/Tray.sol#126) is not in mixedCase
Parameter Tray.buy(uint256)._amount (src/Tray.sol#157) is not in mixedCase
Parameter Tray.burn(uint256)._id (src/Tray.sol#180) is not in mixedCase
Parameter Tray.getTile(uint256,uint8)._trayId (src/Tray.sol#202) is not in mixedCase
Parameter Tray.getTile(uint256,uint8)._tileOffset (src/Tray.sol#202) is not in mixedCase
Parameter Tray.getTiles(uint256)._trayId (src/Tray.sol#210) is not in mixedCase
Parameter Tray.changeNoteAddress(address)._newNoteAddress (src/Tray.sol#217) is not in mixedCase
Parameter Tray.changeRevenueAddress(address)._newRevenueAddress (src/Tray.sol#225) is not in mixedCase
Parameter Utils.characterToUnicodeBytes(uint8,uint16,uint256)._fontClass (src/Utils.sol#74) is not in mixedCase
Parameter Utils.characterToUnicodeBytes(uint8,uint16,uint256)._characterIndex (src/Utils.sol#75) is not in mixedCase
Parameter Utils.characterToUnicodeBytes(uint8,uint16,uint256)._characterModifier (src/Utils.sol#76) is not in mixedCase
Parameter Utils.generateSVG(Tray.TileData[],bool)._tiles (src/Utils.sol#227) is not in mixedCase
Parameter Utils.generateSVG(Tray.TileData[],bool)._isTray (src/Utils.sol#227) is not in mixedCase
Parameter Utils.iteratePRNG(uint256)._currState (src/Utils.sol#262) is not in mixedCase
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#conformance-to-solidity-naming-conventions

// @audit-ok
Variable Utils.characterToUnicodeBytes(uint8,uint16,uint256).characterIndex_scope_4 (src/Utils.sol#162) is too similar to Utils.characterToUnicodeBytes(uint8,uint16,uint256).characterIndex_scope_6 (src/Utils.sol#171)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#variable-names-too-similar
. analyzed (24 contracts with 81 detectors), 48 result(s) found