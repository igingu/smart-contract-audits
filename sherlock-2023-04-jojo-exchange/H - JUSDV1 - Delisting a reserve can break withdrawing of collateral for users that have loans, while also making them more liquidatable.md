Summary
Delisting a reserve can break withdrawing of collateral for users that have loans. It also abruptly increases their risk of liquidation, as a delisted reserve is no longer considered for valid collateral during _isStartLiquidation check.

Vulnerability Detail
When delisting a reserve, users can no longer deposit or borrow against that reserve, which makes sense. However, setting isBorrowAllowed to false also has the effect of reducing the safety margin that users have, because of how _isAccountSafe is computed:

If isBorrowAllowed is false for a reserve, user's collateral for that reserve is not considered
The above makes this inequality less likely to return true
Which can make users not able to withdraw their collateral anymore, especially since it was delisted and they want it back

Impact
Computing the safety of an account for withdrawal should take into account delisted reserves, as long as users still have collateral in those reserves. Otherwise, owner delisting a reserve might make users' positions unsafe, which makes them unable to withdraw the delisted collateral and also more liquidatable.

Code Snippet
https://github.com/sherlock-audit/2023-04-jojo/blob/main/JUSDV1/src/Impl/JUSDView.sol#L147
https://github.com/sherlock-audit/2023-04-jojo/blob/main/JUSDV1/src/Impl/JUSDView.sol#L167
https://github.com/sherlock-audit/2023-04-jojo/blob/main/JUSDV1/src/Impl/JUSDView.sol#L194

Tool used
Manual Review

Recommendation
If smart contract no longer considers the delisted reserves as valid collateral, users should be able to withdraw that collateral without any additional checks on account safety. Owner should not be able to delist a reserve so abruptly, more safeguards should be added like:

would any position become unsafe/liquidatable because of this