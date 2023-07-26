Summary
In JUSDV1's liquidate function, a liquidator is allowed to specify the expectPrice, which is the highest price they are comfortable to pay for a unit of collateral. This is enforced by this require statement.

Vulnerability Detail
However, the price used for the computations is taken from Chainlink, not Uniswap, while the trade is done in Uniswap.

Impact
Chainlink and Uniswap prices can differ. Not only that, trading on Uniswap might also return less than expected tokens, as big volumes tend to move the price I am trading at, on top of slippage. It is not guaranteed that the liquidator will actually get a unit of collateral at price <= expectPrice.

Code Snippet
https://github.com/sherlock-audit/2023-04-jojo/blob/main/JUSDV1/src/Impl/JUSDBank.sol#L171

Tool used
Manual Review

Recommendation
Use the same entity in the swap, to getAssetPrice. Add another require statement making user that liquidator has actually traded at the expected price.