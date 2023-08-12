# M - First staker can break minting of shares

The attack vector and impact is the same as [Trail of Bits Yearn Finance Audit - 3. Division rounding may affect issuance of shares](https://github.com/yearn/yearn-security/blob/master/audits/20210719_ToB_yearn_vaultsv2/ToB_-_Yearn_Vault_v_2_Smart_Contracts_Audit_Report.pdf), where users may not receive any shares when staking, if the total asset amount has been manipulated through a large “donation”.

## Impact
The first staker can make it so that a few units of SafeEth are worth 1Eth of underlying value, effectively making most subsequent stakings mint 0 units of SafeEth to victims.

This would not only make stakers sometimes completely use their funds (because they would be minted 0 SafEth units), but attacker could also withdraw the underlying value added by the victims, since the total number of SafEth shares didn't change and attacker holds all of them.

## Proof of Concept
- attacker stakes 3 WEI. Since it is the first stake, [preDepositPrice is 10 ** 18](https://github.com/code-423n4/2023-03-asymmetry/blob/main/contracts/SafEth/SafEth.sol#L95)
- [the 3 WEI are deposited in the staking pools](https://github.com/code-423n4/2023-03-asymmetry/blob/main/contracts/SafEth/SafEth.sol#L91), and now [the totalStakedValueEth](https://github.com/code-423n4/2023-03-asymmetry/blob/main/contracts/SafEth/SafEth.sol#L95) in the system is 3 WEI.
- [attacker is minted (3e18) / 1e18](https://github.com/code-423n4/2023-03-asymmetry/blob/main/contracts/SafEth/SafEth.sol#L98) shares, so 3 shares.
- attacker directly sends 1 REth to Assymetry's Reth derivative contract. Now [the underlying value in the system](https://github.com/code-423n4/2023-03-asymmetry/blob/main/contracts/SafEth/SafEth.sol#L72) will be 1 ETH and 3 WEI from before.
- victim stakes 0.3 ETH. ```preDepositPrice``` will be computed as: ```(1e18 * (1e18 + 3)) / 3```, which would be ~ ```0.33 ETH * 1e18 ```.
- ```totalStakeValue``` will be ~ ```0.3 ETH```
- ```mintAmount``` will be ```((~ 0.3 ETH * 1e18) / 0.33 ETH * 1e18 )```, which would round down to 0 units of SafEth.
- now there are still 3 units of SafEth minted, but which now underly 1Reth + 0.3 ETH (from victim). 
- if attacker unstakes their 3 units of shares, they will withdraw ~ 1.3 ETH, with an initial investment of 1 ETH.



## Recommended Mitigation Steps

If Assymetry Finance notices this attack happening, they can immediately pause staking, blocking users from becoming victims, and also pause unstaking, blocking the attacker from unstaking their shares and getting back their 1 Reth investment.

An easy way to mitigate the vulnerability would be to ```require(mintAmount != 0, "Can not mint 0 shares")```.

Another way would be taking Uniswap example: Uniswap V2 solved this problem by sending the first 1000 LP tokens to the zero address. The same can be done [in this case](https://github.com/code-423n4/2023-03-asymmetry/blob/main/contracts/SafEth/SafEth.sol#L79), send the first 1000 SafEth units to the zero address to enable share dilution.

