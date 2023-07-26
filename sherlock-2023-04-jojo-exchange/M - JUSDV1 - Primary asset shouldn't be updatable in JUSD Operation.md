Summary
The JUSDV1 system is made so that it works with one, non-changeable primaryAsset, as the primaryAsset is immutable in JUSDExchange and is mentioned in the documentation as USDC.

Vulnerability Detail
However, primaryAsset is updateable inside JUSDBank, through JUSDOperation.

Impact
Having this functionality in the smart contract shows intention to use it. Changing the primaryAsset in JUSDBank would break the system, especially liquidation, as JUSDBank and JUSDExchange would work with two different tokens but act like they are the same. All liquidations would revert, which means users are free to get as many loans as possible with no risk of losing the collateral, making the protocol go bankrupt.

Code Snippet
https://github.com/sherlock-audit/2023-04-jojo/blob/main/JUSDV1/src/Impl/JUSDBank.sol#L158
https://github.com/sherlock-audit/2023-04-jojo/blob/main/JUSDV1/src/Impl/JUSDBank.sol#L161
https://github.com/sherlock-audit/2023-04-jojo/blob/main/JUSDV1/src/Impl/JUSDBank.sol#L194
https://github.com/sherlock-audit/2023-04-jojo/blob/main/JUSDV1/src/Impl/JUSDBank.sol#L200

Tool used
Manual Review

Recommendation
Remove updatePrimaryAsset functionality.