# [H-02] Namespace: Fusing will only result in namespaces containing font class 0, irrelevant of fused tiles

After minting trays, a user can fuse tiles from multiple trays into a namespace. A tray tile specifies a character font class, the character's index and the character modifier. There are 10 font classes, [starting from most common EMOJI (font class = 0 and probability 32/109) to most uncommon BLOCKS INVERTED (font class = 9 and probability 1/109)](https://github.com/code-423n4/2023-03-canto-identity/blob/main/canto-namespace-protocol/README.md#tile). 

Current implementation [fuses ALL CHARACTERS using hardcoded fontClass 0](https://github.com/code-423n4/2023-03-canto-identity/blob/main/canto-namespace-protocol/src/Namespace.sol#L144).

## Impact
Irrelevant of how rare the fused character tile is, it is always fused from the most common font class (0 = EMOJIs), effectively burning Tray NFTs of any rarity and turning them into the most common characters. This means that irrespective of how rare your Tray NFT characters are, everyone will always have names composed of only EMOJIs.

Font classes 1-9 [account for (77/109)% of minted character Trays](https://github.com/code-423n4/2023-03-canto-identity/blob/main/canto-namespace-protocol/README.md#tile) (77  = 109 (sum of all shares), minus 32 (shares for font class 0)), which means that when fusing, 77 out of 109 times you will not get the character you should have gotten, but something else, of the most common occurence and the least scarcity. 

## Remediation
```
canto-namespace-protocol/src/Namespace.sol#L144
  bytes memory charAsBytes = Utils.characterToUnicodeBytes(0, tileData.characterIndex, characterModifier);
  ->
  bytes memory charAsBytes = Utils.characterToUnicodeBytes(tileData.fontClass, tileData.characterIndex, characterModifier);
```

Add a Forge unit test for every font class, making sure that fusing results in the expected Namespace string.
