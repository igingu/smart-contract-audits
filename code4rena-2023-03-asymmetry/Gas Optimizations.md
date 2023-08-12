# [G-01] Should use ```require(!variable)``` for booleans, instead of ```require(variable == false)``` 

https://github.com/code-423n4/2023-03-asymmetry/blob/main/contracts/SafEth/SafEth.sol#L64
https://github.com/code-423n4/2023-03-asymmetry/blob/main/contracts/SafEth/SafEth.sol#L109

## PoC:
In Remix, the below spends 23327 gas for deployment, and 2275 for execution.
```solidity
pragma solidity ^0.8.0;

contract A {
    bool private paused;

    function testGasOptimization() external {
        require(!paused, "a");
    }
}
```

```require(paused == false, "a")``` would have spent 23342 gas for deployment, and 2290 for execution.

## Remediation:
```solidity
contracts/SafEth/SafEth.sol#L64
    require(pauseStaking == false, "staking is paused");
    ->
    require(!pauseStaking, "staking is paused");
```

Per instance, saves 15 gas at deployment (because of less bytecode), and 15 gas each execution.

# [G-02] Redundant multiplication and subsequent division by 10 ** 18

## Remediation:
```solidity
contracts/SafEth/derivatives/Reth.sol#L215
    else return (poolPrice() * 10 ** 18) / (10 ** 18);
    -> 
    else return poolPrice();
```

# [G-03] Should use ```rethAddress()``` instead of duplicating code

Code at the following lines is the same as the one inside ```rethAddress()```, should be refactored to use ```rethAddress()``` function call. This would reduce gas cost at deployment, while making the code cleaner

https://github.com/code-423n4/2023-03-asymmetry/blob/main/contracts/SafEth/derivatives/Reth.sol#L187
https://github.com/code-423n4/2023-03-asymmetry/blob/main/contracts/SafEth/derivatives/Reth.sol#L229

## Remediation:
```solidity
contracts/SafEth/derivatives/Reth.sol#L187
    address rocketTokenRETHAddress = RocketStorageInterface(
                ROCKET_STORAGE_ADDRESS
    ).getAddress(
            keccak256(
                abi.encodePacked("contract.address", "rocketTokenRETH")
            )
        );
    RocketTokenRETHInterface rocketTokenRETH = RocketTokenRETHInterface(
        rocketTokenRETHAddress
    );
    ->
    RocketTokenRETHInterface rocketTokenRETH = RocketTokenRETHInterface(
        rethAddress()
    );
```

Making the above changes reduced ```Reth.sol``` bytecode size by 0.43 kb, to 6.109, so 7% decrease.

# [G-04] Some functions can be refactored to save gas


## Remediation - ```rebalanceToWeights``` (without optimizations included in automated findings report):
* copying storage variables used multiple times to memory, instead of doing a storage read multiple times
* only run ```for loop``` if ```ethAmountToRebalance``` is not 0
* ```unchecked``` block for subtraction that can not underflow
```
 function rebalanceToWeights() external onlyOwner {
    uint256 ethAmountBefore = address(this).balance;
    uint256 _derivativeCount = derivativeCount;
    for (uint i = 0; i < _derivativeCount; i++) {
        IDerivative derivative = derivatives[i];
        uint256 derivativeBalance = derivative.balance();
        if (derivativeBalance > 0)
            derivative.withdraw(derivativeBalance);
    }
    uint256 ethAmountAfter = address(this).balance;

    uint256 ethAmountToRebalance;
    unchecked {
        ethAmountToRebalance = ethAmountAfter - ethAmountBefore;
    }

    if (ethAmountToRebalance != 0) {
        for (uint i = 0; i < _derivativeCount; i++) {
            uint256 weight = weights[i];
            if (weight == 0) continue;
            uint256 ethAmount = (ethAmountToRebalance * weight) /
                totalWeight;
            // Price will change due to slippage
            derivatives[i].deposit{value: ethAmount}();
        }
    }

    emit Rebalanced();
}
```

## Remediation - ```addDerivative``` (without optimizations included in automated findings report):
* modifying ```totalWeight``` directly since there is no need to iterate through all derivatives
* ```unchecked``` block for addition that can not overflow
```solidity
function addDerivative(
    address _contractAddress,
    uint256 _weight
) external onlyOwner {
    // @note - Store derivative
    uint256 _derivativeCount = derivativeCount;
    derivatives[_derivativeCount] = IDerivative(_contractAddress);
    weights[_derivativeCount] = _weight;
    unchecked{
        _derivativeCount++;
    }

    totalWeight = totalWeight + _weight;
    derivativeCount = _derivativeCount;
    emit DerivativeAdded(_contractAddress, _weight, _derivativeCount);
}
```

## Remediation - ```adjustWeight``` (without optimizations included in automated findings report):
* modifying ```totalWeight``` directly since there is no need to iterate through all derivatives
```solidity
function adjustWeight(
    uint256 _derivativeIndex,
    uint256 _weight
) external onlyOwner {
    // @note - Change derivative's weight
    // L - should have specific error message here for index out of bounds
    weights[_derivativeIndex] = _weight;

    // @note - Recompute total weight
    totalWeight = totalWeight - weights[_derivativeIndex] + _weight;
    emit WeightChange(_derivativeIndex, _weight);
}
```
