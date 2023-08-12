# M - WstEth minOut is not computed correctly for the given maxSlippage

Withdrawing wstEth [incorrectly computes the minAmount given the maxSlippage](https://github.com/code-423n4/2023-03-asymmetry/blob/main/contracts/SafEth/derivatives/WstEth.sol#L60). It assumes a 1-1 stEth to Eth conversion, while for SfrxEth and Reth, [it computes the minAmount using the ethPerDerivative price that will be used during the exchange](https://github.com/code-423n4/2023-03-asymmetry/blob/main/contracts/SafEth/derivatives/SfrxEth.sol#L74).

## Impact
The more subunitary stEth/Eth is, the more unstaking calls will revert since ```minOut``` would be over the exchange price even without including the maxSlippage into the calculation. This would block user funds.

### Example
Imagine ```stEth/Eth = 99e16```. Assuming ```maxSlippage``` of 1%, and ```stEthBalance of 1```, ```minOut``` would be 99e16 as well, which is exactly the ```stEth/Eth``` price, allowing for no actual slippage in the Curve Pool.

If ```minOut``` would have been calculated using actual exchange price (99e16), it would have been 9.801e+17, actually allowing for 1% slippage.

## Recommended Mitigation Steps
```solidity
contracts/SafEth/derivatives/WstEth.sol#L60
    uint256 minOut = (stEthBal * (10 ** 18 - maxSlippage)) / 10 ** 18;
    -> 
    uint256 minOut = ((stEthBal * (ethPerDerivative(stEthBal)) / 10 ** 18) *
            (10 ** 18 - maxSlippage)) / 10 ** 18;
```