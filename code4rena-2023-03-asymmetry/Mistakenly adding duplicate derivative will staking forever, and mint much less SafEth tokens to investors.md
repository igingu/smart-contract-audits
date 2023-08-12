# M - Mistakenly adding duplicate derivative will staking forever, and mint much less SafEth tokens to investors

The owner of the SafEth contract can add a derivative through [the ```addDerivative``` function](https://github.com/code-423n4/2023-03-asymmetry/blob/main/contracts/SafEth/SafEth.sol#L182). This function doesn't require the ```_contractAddress``` to be unique, hence the same derivative address can be added twice. 

There is a way to "delete" a derivative, by setting it's weight to 0 using [the ```adjustWeight``` function](https://github.com/code-423n4/2023-03-asymmetry/blob/main/contracts/SafEth/SafEth.sol#L165), and then rebalance using [the ```rebalanceWeights``` function](https://github.com/code-423n4/2023-03-asymmetry/blob/main/contracts/SafEth/SafEth.sol#L138). This would make it that every time someone stakes, there will be [(msg.value * 0) / totalWeight](https://github.com/code-423n4/2023-03-asymmetry/blob/main/contracts/SafEth/SafEth.sol#L88) ETH deposited, so 0, which is correct, the duplicated entry of the derivative has been "deleted".

However, "deleting" a derivative doesn't guard from the fact that [the underlying value of the derivative will still be counted twice](https://github.com/code-423n4/2023-03-asymmetry/blob/main/contracts/SafEth/SafEth.sol#L73).

## Impact
When calculating the ETH underlying value of all the derivatives, the weight of each derivative is irrelevant. The calculation is only based on [the derivatives' Eth/derivative ratio, and its balance](https://github.com/code-423n4/2023-03-asymmetry/blob/main/contracts/SafEth/SafEth.sol#L73). Having a duplicated derivative in the ```derivatives``` array, even if the duplicate has weight 0, would still result in counting that derivative's underlying Eth value twice => ```underlyingValue``` will be considerably bigger than it was supposed to => [preDepositPrice will be considerably bigger](https://github.com/code-423n4/2023-03-asymmetry/blob/main/contracts/SafEth/SafEth.sol#L81) => [mintAmount will be considerably smaller](https://github.com/code-423n4/2023-03-asymmetry/blob/main/contracts/SafEth/SafEth.sol#L98).

## Proof of concept
* SafEth contract has 3 derivatives, each with weight 100; 2 investors have each staked 10 ETH => the underlying Eth of all derivatives in the contract is ~ 20 ETH. There are 20 SafEth tokens after the staking, each investor has 10
* assume ethPerDerivative is 1 for now, for each of the derivatives, for ease of calculation
* owner mistakenly adds Sfrx again
* now derivatives and weights arrays are [SfrxEth - 100, WstEth - 100, Reth - 100, Sfrx - 100]; 
* owner realizes mistake and sets 4th derivative's weight to 0, to "delete it" => [SfrxEth - 100, WstEth - 100, Reth - 100, SfrxEth - 0]
* owner calls ```rebalanceWeights```, which splits the underlying Eth into ~ 3 equal parts, for each of the derivatives
* SafEth has ~ 20 ETH underlying, ~6.66 ETH in each derivative (because each derivative has 100/300 weight), exactly like at the beginning

* third investor stakes 10 ETH => underlyingValue will be: (1 * 6.66) + (1 * 6.66) + (1 * 6.66) + (1 * 6.66), even though the 4th derivative (duplicated Sfrx) has been "deleted" => underlyingValue will be 26.64 ETH, even thought only 20 ETH have been deposited so far
* [preDepositPrice](https://github.com/code-423n4/2023-03-asymmetry/blob/main/contracts/SafEth/SafEth.sol#L81) will be 26.64ETH / 20, == 1.332 ETH.
* [totalStakeValueEth](https://github.com/code-423n4/2023-03-asymmetry/blob/main/contracts/SafEth/SafEth.sol#L95) will be ~ 10 ETH, let's assume 10
* [investor will be minted 10 / 1.332 = 7.507 shares](https://github.com/code-423n4/2023-03-asymmetry/blob/main/contracts/SafEth/SafEth.sol#L98)
* if investor was to unstake their share right away, [they will withdraw](https://github.com/code-423n4/2023-03-asymmetry/blob/main/contracts/SafEth/SafEth.sol#L115) (7.507 / 27.507) * 10 + (7.507 / 27.507) * 10 + (7.507 / 27.507) * 10, which is 8.18 ETH, moments after they have just staked 10 ETH

## Mitigation if it happens
The only potential way to fix staking after this happens would be to set weight to 0 for all entries of the duplicated derivative, not only for the copy, and then call ```rebalanceWeights```. This would fix the issue but would make it impossible to reuse that same derivative contract again, as adding it would break minting again.

Steps to mitigate in case this happens:
* owner pauses staking
* owner sets both weights of the duplicated derivative to 0
* owner rebalances weights
* owner deploys another version of the duplicated derivative contract
* owner adds the new derivative contract, with the new address
* owner unpauses staking

## Remediation
Add check for duplicated derivative contract address in ```addDerivative```
```solidity
contracts/SafEth/SafEth.sol#L186
    derivatives[derivativeCount] = IDerivative(_contractAddress);
    weights[derivativeCount] = _weight;

    -> 

    for (uint256 i; i < derivativeCount; i++) {
        require(address(derivatives[i]) != _contractAddress, "Can't add duplicated derivative.");
    }
    derivatives[derivativeCount] = IDerivative(_contractAddress);
    weights[derivativeCount] = _weight;
```