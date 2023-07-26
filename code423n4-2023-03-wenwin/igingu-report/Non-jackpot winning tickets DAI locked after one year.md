# [M-01] Non-jackpot lottery winnings blocked in contract after 1 year period

https://docs.wenwin.com/wenwin-lottery/the-game/prizes#claiming-prizes specifies **that all winning tickets have a
one-year deadline from the draw time to claim their prize by redeeming the winning NFT ticket.**

This is enforced
[when one tries to claim a ticket](https://github.com/code-423n4/2023-03-wenwin/blob/main/src/Lottery.sol#L164).

When a draw executes,
[unclaimed jackpot tickets from 1 year ago are returned to the pot](https://github.com/code-423n4/2023-03-wenwin/blob/main/src/Lottery.sol#L138),
so that they are not stuck in the contract but can now be redistributed as excess pot.

However, unclaimed non-jackpot tickets are not returned to the pot after 1 year, effectively becoming stuck in the smart
contract. Returning these tickets to the pot to be redistributed to the players would be an expensive, complicated
implementation, which might not be worth the effort and potential vulnerabilities.

## Recommendation:

Given that returning unclaimed non-jackpot prizes to the pot is not feasible, enforcing the 1-year rule would mean
blocking funds there, with the only effect of potentially reducing insolvency risk of the Lottery, since it now holds
additional funds as a buffer. I think the protocol should no longer revert the claiming of non-jackpot tickets after one
year, but still return the jackpot ones to the pot. This way, we are not "blocking" funds, while also redistributing the
most unclaimed amount of prizes one can redistribute.

```
src/Lottery.sol:164
    if (block.timestamp <= ticketRegistrationDeadline(ticketInfo.drawId + LotteryMath.DRAWS_PER_YEAR)) {
    ->
    if (winTier < selectionSize || (
            winTier == selectionSize && block.timestamp <= ticketRegistrationDeadline(ticketInfo.drawId + LotteryMath.DRAWS_PER_YEAR)
        )
    )
```
