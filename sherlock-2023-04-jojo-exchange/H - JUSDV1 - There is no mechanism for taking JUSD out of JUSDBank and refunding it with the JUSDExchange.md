Summary
JUSD can be minted/burned by JUSD token's owner. JoJo team plans to mint JUSD and send it to JUSDBank, for users to take loans by depositing collateral. Each JUSD loan has an interest rate, such that the user needs to pay back more than they borrowed, making a profit for the platform's owners as well.

Vulnerability Detail
Every time someone repays a loan, or a positions gets liquidated, JUSD is sent to the JUSDBank contract. There is no functionality to take out JUSD from the bank, or to refund excess JUSD in the JUSDExchange.

Impact
JUSD will keep piling up in JUSDExchange, and interest gained from lending will be stuck there as well. There should be a mechanism for platform team to take the interest out of the JUSDExchange, or at least burn the JUSD from time to time, when it is not needed.

JUSDExchange should also have a way to send JUSD to it, and receive back the primary asset.

I discussed this with the platform team (@joscelyn), and this was their response: "Hi after internal discussion, the interface for refundJusD is missing. And we will add it, you could submit it"

Code Snippet
https://github.com/sherlock-audit/2023-04-jojo/blob/main/JUSDV1/src/Impl/JUSDExchange.sol#L41

Tool used
Manual Review

Recommendation
Mentioned above.