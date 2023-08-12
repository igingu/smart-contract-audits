# M - Computation behind underlyingValue and staking is not consistent accross derivatives

I will put below all my concerns about [how underlyingValue is computed](https://github.com/code-423n4/2023-03-asymmetry/blob/main/contracts/SafEth/SafEth.sol#L72) and [how totalStakedEthValue is computed](https://github.com/code-423n4/2023-03-asymmetry/blob/main/contracts/SafEth/SafEth.sol#L95). I think this should amount to a medium vulnerability, as the behavior is not consistent and can lead to many different errors in calculating correct amount of shares to mint to users. Developers should settle on which calculation they want to use, and have it consistent accross the derivatives.

```underlyingValue``` is a number that represents how much Eth underlies all the derivatives in the system. 

```totalStakeValueEth``` is a number that represents how much Eth underlies the new derivatives that have resulted from user staking msg.value Eth.

Both ```underlyingValue``` and ```totalStakeValueEth``` are computed based on the ```ethPerDerivative``` function.

## Reth
For Reth, ```ethPerDerivative``` is either [the spot price of Uniswap V3 rEth/wEth pool](https://github.com/code-423n4/2023-03-asymmetry/blob/main/contracts/SafEth/derivatives/Reth.sol#L215), or [RocketToken Eth value per 1 REth token](https://github.com/code-423n4/2023-03-asymmetry/blob/main/contracts/SafEth/derivatives/Reth.sol#L214). 

### Why is this wrong?
When computing ```underlyingValue```, we want to see how much Eth underlies Reth in the system, we do not want to deposit any Eth yet, so we do not care if [poolCanDeposit(RethDerivative.balance())](https://github.com/code-423n4/2023-03-asymmetry/blob/main/contracts/SafEth/derivatives/Reth.sol#L212) => we can always take rEth/Eth price from Rocket Pool.

When computing ```totalStakeValueEth```, it would make more sense [to get the ethPerDerivative amount](https://github.com/code-423n4/2023-03-asymmetry/blob/main/contracts/SafEth/SafEth.sol#L92) before the deposit, or to change the ```ethPerDerivative``` function so that it goes on the same **if** branch: we deposit the Eth, and ```poolCanDeposit``` returns true, so we deposit using the conversion in ```RocketToken.getEthValue()```; we get the ```ethPerDerivative``` conversion rate now, to compute ```totalStakeValueEth```, and ```poolCanDeposit``` might return false, so we get the conversion in ```poolPrice()```, which is different than the conversion that was used when depositing. This will either mint less or more shares to staker.

### Recommendation:
If when depositing Eth in exchange for rEth, the ```RocketToken.getEthValue()``` computation was used, make sure that is also used to compute ```totalStakeValueEth```.

## WstEth and SfrxEth

WstEth and SfrxEth are similar tokens in regards to their relationships with stEth and frxEth, and Eth. 

1 stEth should currently be pegged to Eth (by arbitrage), and 1 wstEth is worth (X >= 1) stEth.

1 frxEth should currently be pegged to Eth (by arbitrage), and 1 sfrxEth is worth (X >= 1) frxEth.

### Why is this wrong?
However, the ```ethPerDerivative``` computation for these is different.

[For WstEth](https://github.com/code-423n4/2023-03-asymmetry/blob/main/contracts/SafEth/derivatives/WstEth.sol#L87), developers compute the amount of Eth by first getting the amount of stEth for 1 WstEth, and then returning that, assuming 1 stEth is equal to 1 Eth.

[For SfrxEth](https://github.com/code-423n4/2023-03-asymmetry/blob/main/contracts/SafEth/derivatives/SfrxEth.sol#L111), developers compute the amount of Eth by first getting the amount of frxEth for 1 SfrxEth, and then multiplying that by the frxEth/Eth Curve Liquidity pool price.

### Recommendation
I think both tokens should either do the algorithm for WstEth, or do the algorithm for SfrxEth, since the relations between them are the same (1 wstEth is many stEth, 1 stEth is 1 Eth -- 1 sfrxEth is many frxEth, 1 frxEth is 1 Eth).

Also, for all 3 derivatives, it would also be a possibility to just have the ```totalStakeValueEth``` as ```msg.value```, as the total amount of Eth that was staked is exactly ```msg.value```, irrespective of the derivatives now being exchangable for less, because of slippage and trading fees.