Summary
In JUSDOperation, owner has the ability to update the initialMortgageRate, liquidationMortgageRate and borrowFeeRate.

Vulnerability Detail
When a person enters a loan, it enters into a contract which specifies a level of risk and interest they are comfortable with. These parameters shouldn't be able to be changed mid-loan, as it could force borrowers into uncomfortable positions they didn't sign up for.

Impact
Owner changes initialMortgageRate to a smaller one -> some users' positions might become unsafe, which makes a previously perfectly safe position become impossible to flashloan or withdraw from. Users can also no longer borrow as much
Owner changes liquidationMortgageRate to a smaller one -> some users' positions might become liquidatable. This is not right as the user might have not been expecting it, since they thought the terms of the loan are set in stone.
Owner changes borrowFeeRate to a bigger one -> every user starts paying more interest, and become unsafe/liquidatable faster

Code Snippet
https://github.com/sherlock-audit/2023-04-jojo/blob/main/JUSDV1/src/Impl/JUSDView.sol#L139
https://github.com/sherlock-audit/2023-04-jojo/blob/main/JUSDV1/src/Impl/JUSDView.sol#L159

https://github.com/sherlock-audit/2023-04-jojo/blob/main/JUSDV1/src/Impl/JUSDOperation.sol#L178
https://github.com/sherlock-audit/2023-04-jojo/blob/main/JUSDV1/src/Impl/JUSDOperation.sol#L205
https://github.com/sherlock-audit/2023-04-jojo/blob/main/JUSDV1/src/Impl/JUSDOperation.sol#L168

Tool used
Manual Review

Recommendation
Owner should not be able to change these while there are loans still outstanding.