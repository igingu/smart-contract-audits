// SPDX-License-Identifier: UNLICENSED
// slither-disable-next-line solc-version
pragma solidity 0.8.19;

import "src/interfaces/ILottery.sol";
import "src/PercentageMath.sol";

/// @dev Implementation of lottery jackpot and fees calculations
library LotteryMath {
    using PercentageMath for uint256;
    using PercentageMath for int256;

    /// @dev percentage of ticket price being paid for staking reward
    // @note - rewarded in rewards token (DAI)
    // @note - as per https://docs.wenwin.com/wenwin-lottery/the-game/tickets
    uint256 public constant STAKING_REWARD = 20 * PercentageMath.ONE_PERCENT;

    /// @dev percentage of ticket price being paid to frontend operator
    // @note - rewarded in rewards token (DAI)
    // @note - as per https://docs.wenwin.com/wenwin-lottery/the-game/tickets
    uint256 public constant FRONTEND_REWARD = 10 * PercentageMath.ONE_PERCENT;

    /// @dev Percentage of the ticket price that goes to the pot
    // @note - rewarded in rewards token (DAI)
    // @note - as per https://docs.wenwin.com/wenwin-lottery/the-game/tickets
    uint256 public constant TICKET_PRICE_TO_POT = PercentageMath.PERCENTAGE_BASE - STAKING_REWARD - FRONTEND_REWARD;

    /// @dev safety margin used to calculate excess pot, in percentage
    uint256 public constant SAFETY_MARGIN = 67 * PercentageMath.ONE_PERCENT;

    /// @dev Percentage of excess pot reserved for bonus
    // @note - rewarded in rewards token (DAI)
    // @note - https://docs.wenwin.com/wenwin-lottery/the-game/prizes/bonuses
    uint256 public constant EXCESS_BONUS_ALLOCATION = 50 * PercentageMath.ONE_PERCENT;

    // @note - one draw every week
    /// @dev Number of lottery draws per year
    uint128 public constant DRAWS_PER_YEAR = 52;

    /// @dev Calculates new cumulative net profit and excess pot
    /// To be called when the draw is finalized
    /// @param oldProfit Current cumulative net profit, calculated when previous draw was finalized
    /// @param ticketsSold Number of tickets sold for the draw that is currently finalized
    /// @param ticketPrice One ticket price expressed in reward token
    /// @param jackpotWon True if jackpot is won in this round
    /// @param fixedJackpotSize Fixed jackpot price
    /// @param expectedPayout Expected payout to players per ticket, expressed in `rewardToken`
    /// @return newProfit New value for the cumulative net profit after the draw is finalised
    // @note - expectedPayout is calculated off-chain, using expected value math
    // @note - Cumulative Net Profit is the amount of revenues generated by ticket sales minus all
    //         prizes paid to winners since inception. It does not reset after every draw.
    function calculateNewProfit(
        int256 oldProfit,
        uint256 ticketsSold,
        uint256 ticketPrice,
        bool jackpotWon,
        uint256 fixedJackpotSize,
        uint256 expectedPayout
    )
        internal
        pure
        returns (int256 newProfit)
    {
        // @note - number of tickets * price * percentage to pot (100% - staking and frontend rewards)
        uint256 ticketsSalesToPot = (ticketsSold * ticketPrice).getPercentage(TICKET_PRICE_TO_POT);
        newProfit = oldProfit + int256(ticketsSalesToPot);

        // @note - https://docs.wenwin.com/wenwin-lottery/the-game/prizes/bonuses
        // @note - if jackpot, => fixedJackpotSize + BonusAllocation
        // @note - else, => BonusMultiplier * ticketsSold * expectedPayout
        uint256 expectedRewardsOut = jackpotWon
            ? calculateReward(oldProfit, fixedJackpotSize, fixedJackpotSize, ticketsSold, true, expectedPayout)
            : calculateMultiplier(calculateExcessPot(oldProfit, fixedJackpotSize), ticketsSold, expectedPayout)
                * ticketsSold * expectedPayout;

        // @note - new CNP = oldProfit - expectedRewardsForDraw
        newProfit -= int256(expectedRewardsOut);
    }

    /// @dev Calculates excess pot based on netProfit
    /// @param netProfit Current net profit of the lottery
    /// @param fixedJackpotSize Fixed portion of the jackpot
    /// @return excessPot Resulting excess pot
    function calculateExcessPot(int256 netProfit, uint256 fixedJackpotSize) internal pure returns (uint256 excessPot) {
        // @note - https://docs.wenwin.com/wenwin-lottery/the-game/prizes/bonuses
        // @note - ExcessPot = CNP * (1 - SAFETY_MARGIN) - JackpotPrize
        int256 excessPotInt = netProfit.getPercentageInt(SAFETY_MARGIN);
        excessPotInt -= int256(fixedJackpotSize);
        excessPot = excessPotInt > 0 ? uint256(excessPotInt) : 0;
    }

    /// @dev Calculates multiplier to be used when calculating non jackpot rewards
    /// @param excessPot Excess pot, calculated when previous draw was finalized
    /// @param ticketsSold Number of tickets sold in the current draw
    /// @param expectedPayout Expected payout to players per ticket, expressed in `rewardToken`
    /// @return bonusMulti Multiplier to be used when calculating rewards, with `PERCENTAGE_BASE` precision
    function calculateMultiplier(
        uint256 excessPot,
        uint256 ticketsSold,
        uint256 expectedPayout
    )
        internal
        pure
        returns (uint256 bonusMulti)
    {
        // @note - https://docs.wenwin.com/wenwin-lottery/the-game/prizes/bonuses
        //         BonusMultiplier = 1 (PERCENTAGE_BASE) + BonusAllocation (excessPot * EXCESS_BONUS_ALLOCATION) /
        //         TicketSales(currentDraw) * ExpectedPayout (ticketsSold * expectedPayout)
        bonusMulti = PercentageMath.PERCENTAGE_BASE;
        if (excessPot > 0 && ticketsSold > 0) {
            bonusMulti += (excessPot * EXCESS_BONUS_ALLOCATION) / (ticketsSold * expectedPayout);
        }
    }

    /// @dev Calculates reward for the winning ticket
    /// @param netProfit Current cumulative net profit, calculated when previous draw was finalized
    /// @param fixedReward Fixed reward for particular tier of the winning ticket
    /// @param fixedJackpot Fixed portion of the jackpot
    /// @param ticketsSold Number of tickets sold in the current draw
    /// @param isJackpot If it is jackpot reward
    /// @param expectedPayout Expected payout to players per ticket, expressed in `rewardToken`
    /// @return reward Reward size for the winning ticket
    function calculateReward(
        int256 netProfit,
        uint256 fixedReward,
        uint256 fixedJackpot,
        uint256 ticketsSold,
        bool isJackpot,
        uint256 expectedPayout
    )
        internal
        pure
        returns (uint256 reward)
    {
        uint256 excess = calculateExcessPot(netProfit, fixedJackpot);

        // @note - https://docs.wenwin.com/wenwin-lottery/the-game/prizes/bonuses
        // @note - if jackpot, fixedJackpot + ExcessPot * BonusAllocation%
        // @note - else, fixedReward * BonusMultiplier
        reward = isJackpot
            ? fixedReward + excess.getPercentage(EXCESS_BONUS_ALLOCATION)
            : fixedReward.getPercentage(calculateMultiplier(excess, ticketsSold, expectedPayout));
    }

    /// @dev Calculate frontend rewards amount for specific tickets sold
    /// @param ticketPrice One lottery ticket price
    /// @param ticketsSold Amount of tickets sold since last fee payout
    /// @param rewardType Type of the reward we are calculating
    /// @return dueRewards Total due rewards for the particular reward
    function calculateRewards(
        uint256 ticketPrice,
        uint256 ticketsSold,
        LotteryRewardType rewardType
    )
        internal
        pure
        returns (uint256 dueRewards)
    {
        uint256 rewardPercentage = (rewardType == LotteryRewardType.FRONTEND) ? FRONTEND_REWARD : STAKING_REWARD;
        dueRewards = (ticketsSold * ticketPrice).getPercentage(rewardPercentage);
    }
}
