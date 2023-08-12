# M - Underlying value of Reth in Eth should be determined using Uniswap's TWAP, not Spot price

The ```ethPerDerivative``` function is used to compute the underlying value of all the derivatives currently in the system. A staker will receive an amount of shares equal to the percentage of their staked ether, over the whole underlying value in the system:
* [As rEth/wEth price becomes smaller, underlyingValue becomes smaller](https://github.com/code-423n4/2023-03-asymmetry/blob/main/contracts/SafEth/SafEth.sol#L73)
* [As underlyingValue becomes smaller, preDepositPrice becomes smaller](https://github.com/code-423n4/2023-03-asymmetry/blob/main/contracts/SafEth/SafEth.sol#L81)
* [As preDepositPrice becomes smaller, number of minted shares becomes bigger](https://github.com/code-423n4/2023-03-asymmetry/blob/main/contracts/SafEth/SafEth.sol#L98)

[Reth.sol's ethPerDerivative function](https://github.com/code-423n4/2023-03-asymmetry/blob/main/contracts/SafEth/derivatives/Reth.sol#L211) computes ```rEth/wEth price``` by querying Uniswap V3, but instead of getting the time-weighted-average-price over say, the last 30 minutes, [it gets the spot price (the last observed price)](https://github.com/code-423n4/2023-03-asymmetry/blob/main/contracts/SafEth/derivatives/Reth.sol#L241), which is much easier to manipulate and has been a vulnerability in many DeFi systems.

## Impact
If Uniswap V3 rEth/wEth price can be manipulated, the underlying value of all the derivatives will be smaller, which will result in an attacking staker receiving more shares by depositing the same amount of Eth. 

## Proof of Concept
* attacker swaps a considerable amount of rEth in the rEth/wEth Uniswap V3 pool, causing the rEth price to drop
* attacker stakes a considerable amount of Eth
* during ```SafEth.stake()``` function, the system will report a smaller ```underlyingValue```, as it is based on rEth/wEth Uniswap V3 pool spot price, and attacker will receive more ```SafEth``` shares than they were supposed to
* as spot price is arbitraged back up, to the non-manipulated value, attacker can unstake their shares to be left with more Eth than before

## Recommended Mitigation Steps
An attacker manipulating price will not be able to make the oracle report a bad price for a long time, and since TWAP is weighted on time buckets, it won't impact TWAP in a significant way.

[Uniswap article computing necessary value to significantly impact TWAP price](https://blog.uniswap.org/uniswap-v3-oracles)

Compute ```Reth poolPrice()``` by using TWAP calculation from Uniswap V3, which greatly increases the required value for an attacking swap, as compared to spot price. 

[An article explaining more about what TWAP is, why it is better, with code example showing how to get it from Uniswap Oracle on-chain](https://tienshaoku.medium.com/a-guide-on-uniswap-v3-twap-oracle-2aa74a4a97c5)

