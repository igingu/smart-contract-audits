# H - User funds are locked: unstaking and rebalanceWeights revert when RocketPool doesn't have enough leftover eth for burn

When unstaking SafEth shares, Reth, SfrxEth and respectively WstEth are transformed back into Eth. For sfrxEth and wstEth, this transformation is done by first unwrapping the tokens (sfrxEth to frxEth, wstEth to stEth), and then trading frxEth and stEth to Eth, using a liquidity pool. 

The above is done because actually unstaking Eth from a validator is not currently possible, so the only way to recover your Eth is by trading your staking tokens for Eth, on markets like curve or Uniswap.

Rocket Pool does implement such functionality, where a user can burn their rEth and receive Eth back. However, this is only possible when [there is Eth that other stakers have deposited, which hasn't been used by a node operator to create a validator, or Eth was returned by a node operator after they exited one of their validators](https://docs.rocketpool.net/guides/staking/overview.html#the-reth-token):

```
NOTE (from the RocketPool Staking documentation)

Trading rETH back for ETH directly with Rocket Pool 
is only possible when the staking pool has enough ETH in it to handle your trade. 
ETH in this pool comes from two sources:

ETH that other stakers have deposited, which hasn't 
been used by a node operator to create a new validator yet

ETH that was returned by a node operator after they exited one 
of their validators and received their rewards from the 
Beacon Chain (note that this is not possible until after the 
ETH1-ETH2 Merge occurs and withdrawals are enabled)

It's possible that if node operators have put all of the staking pool 
to work on the Beacon chain, then the liquidity pool won't have enough 
balance to cover your unstaking. In this scenario, you may find other 
ways to trade your rETH back to ETH (such as a decentralized exchange 
like Uniswap (opens new window)) - though they will likely come with a small premium.
```

The above means that you might only be able to burn a certain portion of rEth, sometimes, and other times it will revert, as there will be no unused Eth waiting to be staked in the Rocket Pool, or the unused Eth will not be enough.

## Impact

### ```Unstaking DoS```
Unstaking SafEth tokens is guaranteed to often revert and block user funds, since most of the time there will not be enough leftover Eth in the Rocket Pool to account for burning the rEth in the Reth derivatives contract. 

This would mean blocking user funds (not only rEth, but also sfrxEth and wstEth holdings), until each user has the luck of unstaking just enough amount of SafEth tokens, regularly, until they manage to get out all their underlying Eth. Not needed to say, the above would be a very tedious process, which could go on for weeks or months, depending of how fast leftover Eth is used to create new validators.

### ```rebalanceToWeights DoS```

Aside from staking, the ```rebalanceToWeights``` function could forever be DoS, since it doesn't only withdraw funds of one user (like unstake), but withdraws all Reth there is, from the RocketPool => it is more likely that Rocket Pool will not have enough leftover Eth to cover such big withdrawal. This in turn would DoS the removal of a derivative (changing weight to 0): one could change the weight to 0, but wouldn't be able to pull all funds from Reth and redistribute them to other two derivatives.

## Proof of Concept
[Reth.withdraw() function](https://github.com/code-423n4/2023-03-asymmetry/blob/main/contracts/SafEth/derivatives/Reth.sol#L108)

[RocketTokenRETH.burn() function](https://github.com/rocket-pool/rocketpool/blob/master/contracts/contract/token/RocketTokenRETH.sol#L114)

[Rocket Pool Staking documentation](https://docs.rocketpool.net/guides/staking/overview.html#the-reth-token)

## Recommended Mitigation Steps
Steps should be taken so that in case ```RocketTokenRETHInterface(rethAddress()).burn(amount);``` reverts, Reth smart contract would trade the rEth against wEth on Uniswap or directly Eth on Curve, instead of trying to unstake it with the Rocket Pool.
