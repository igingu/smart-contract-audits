slither . 'forge clean' running (wd: /mnt/d/Programming/Blockchain/Auditing/code-423n4-2023-03-wenwin) 'forge build
--build-info --force' running Compiling 96 files with 0.8.19 Solc 0.8.19 finished in 7.37s Compiler run successful

// @audit-ok source variable will either be initialized or address(0)
RNSourceController.requestRandomNumberFromSource().reason_scope_0 (src/RNSourceController.sol#116) is a local variable
never initialized  
RNSourceController.requestRandomNumberFromSource().reason (src/RNSourceController.sol#114) is a local variable never
initialized Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#uninitialized-local-variables

// @audit-ok Lottery.constructor(LotterySetupParams,uint256,uint256,uint256[],uint256,uint256).playerRewardFirstDraw
(src/Lottery.sol#87) shadows: - ReferralSystem.playerRewardFirstDraw (src/ReferralSystem.sol#12) (state variable) -
IReferralSystem.playerRewardFirstDraw() (src/interfaces/IReferralSystem.sol#39) (function)
Lottery.constructor(LotterySetupParams,uint256,uint256,uint256[],uint256,uint256).playerRewardDecreasePerDraw
(src/Lottery.sol#88) shadows:  
 - ReferralSystem.playerRewardDecreasePerDraw (src/ReferralSystem.sol#13) (state variable) -
IReferralSystem.playerRewardDecreasePerDraw() (src/interfaces/IReferralSystem.sol#43) (function)
Lottery.constructor(LotterySetupParams,uint256,uint256,uint256[],uint256,uint256).rewardsToReferrersPerDraw
(src/Lottery.sol#89) shadows:  
 - ReferralSystem.rewardsToReferrersPerDraw (src/ReferralSystem.sol#15) (state variable) -
IReferralSystem.rewardsToReferrersPerDraw(uint256) (src/interfaces/IReferralSystem.sol#36) (function)
IRNSourceController.source().source (src/interfaces/IRNSourceController.sol#56) shadows: - IRNSourceController.source()
(src/interfaces/IRNSourceController.sol#56) (function)
IReferralSystem.minimumEligibleReferrals(uint128).minimumEligibleReferrals (src/interfaces/IReferralSystem.sol#73)
shadows: - IReferralSystem.minimumEligibleReferrals(uint128) (src/interfaces/IReferralSystem.sol#73) (function)
IReferralSystemDynamic.referralRequirements(uint256).referralRequirements (src/interfaces/IReferralSystemDynamic.sol#35)
shadows: - IReferralSystemDynamic.referralRequirements(uint256) (src/interfaces/IReferralSystemDynamic.sol#32-35)
(function) Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#local-variable-shadowing

// @audit-ok this is user gas, and can't do DoS because can call function with less ticketIds anytime
Lottery.claimWinningTicket(uint256) (src/Lottery.sol#260-270) has external calls inside a loop: (claimedAmount,winTier)
= this.claimable(ticketId) (src/Lottery.sol#262) Reference:
https://github.com/crytic/slither/wiki/Detector-Documentation/#calls-inside-a-loop

// @audit-ok covered above, unitialized-local-variables Variable
'RNSourceController.requestRandomNumberFromSource().reason (src/RNSourceController.sol#114)' in
RNSourceController.requestRandomNumberFromSource() (src/RNSourceController.sol#106-120) potentially used before
declaration: FailedRNRequest(source,bytes(reason)) (src/RNSourceController.sol#115) Variable
'RNSourceController.requestRandomNumberFromSource().reason_scope_0 (src/RNSourceController.sol#116)' in
RNSourceController.requestRandomNumberFromSource() (src/RNSourceController.sol#106-120) potentially used before
declaration: FailedRNRequest(source,reason_scope_0) (src/RNSourceController.sol#117) Reference:
https://github.com/crytic/slither/wiki/Detector-Documentation#pre-declaration-usage-of-local-variables

Reentrancy in Lottery.receiveRandomNumber(uint256) (src/Lottery.sol#204-233): External calls: -
winAmount[drawFinalized][selectionSize] = drawRewardSize(drawFinalized,selectionSize) / jackpotWinners
(src/Lottery.sol#210) - Math.min(\_initialPot.getPercentage(BASE_JACKPOT_PERCENTAGE),jackpotBound)
(src/LotterySetup.sol#170) - currentNetProfit =
LotteryMath.calculateNewProfit(currentNetProfit,ticketsSold[drawFinalized],ticketPrice,jackpotWinners >
0,fixedReward(selectionSize),expectedPayout) (src/Lottery.sol#217-224) -
Math.min(\_initialPot.getPercentage(BASE_JACKPOT_PERCENTAGE),jackpotBound) (src/LotterySetup.sol#170) State variables
written after the call(s): - currentNetProfit =
LotteryMath.calculateNewProfit(currentNetProfit,ticketsSold[drawFinalized],ticketPrice,jackpotWinners >
0,fixedReward(selectionSize),expectedPayout) (src/Lottery.sol#217-224) - drawExecutionInProgress = false
(src/Lottery.sol#226) Reference:
https://github.com/crytic/slither/wiki/Detector-Documentation#reentrancy-vulnerabilities-1

// @audit-ok false positive, there is no external call here Reentrancy in Lottery.receiveRandomNumber(uint256)
(src/Lottery.sol#204-233): External calls: - winAmount[drawFinalized][selectionSize] =
drawRewardSize(drawFinalized,selectionSize) / jackpotWinners (src/Lottery.sol#210) -
Math.min(\_initialPot.getPercentage(BASE_JACKPOT_PERCENTAGE),jackpotBound) (src/LotterySetup.sol#170) - currentNetProfit
= LotteryMath.calculateNewProfit(currentNetProfit,ticketsSold[drawFinalized],ticketPrice,jackpotWinners >
0,fixedReward(selectionSize),expectedPayout) (src/Lottery.sol#217-224) -
Math.min(\_initialPot.getPercentage(BASE_JACKPOT_PERCENTAGE),jackpotBound) (src/LotterySetup.sol#170) State variables
written after the call(s): - lastDrawFinalTicketId = nextTicketId (src/Lottery.sol#229) - winningTicket[drawFinalized] =
\_winningTicket (src/Lottery.sol#225) Reentrancy in Lottery.receiveRandomNumber(uint256) (src/Lottery.sol#204-233):
External calls: - winAmount[drawFinalized][selectionSize] = drawRewardSize(drawFinalized,selectionSize) / jackpotWinners
(src/Lottery.sol#210) - Math.min(\_initialPot.getPercentage(BASE_JACKPOT_PERCENTAGE),jackpotBound)
(src/LotterySetup.sol#170) - currentNetProfit =
LotteryMath.calculateNewProfit(currentNetProfit,ticketsSold[drawFinalized],ticketPrice,jackpotWinners >
0,fixedReward(selectionSize),expectedPayout) (src/Lottery.sol#217-224) -
Math.min(\_initialPot.getPercentage(BASE_JACKPOT_PERCENTAGE),jackpotBound) (src/LotterySetup.sol#170) -
referralDrawFinalize(drawFinalized,ticketsSoldDuringDraw) (src/Lottery.sol#230) -
totalTicketsSoldPrevDraw.getPercentage(PercentageMath.ONE_PERCENT) (src/ReferralSystem.sol#134) -
totalTicketsSoldPrevDraw.getPercentage(PercentageMath.ONE_PERCENT _ 75 / 100) (src/ReferralSystem.sol#138) -
totalTicketsSoldPrevDraw.getPercentage(PercentageMath.ONE_PERCENT _ 50 / 100) (src/ReferralSystem.sol#142) State
variables written after the call(s): - referralDrawFinalize(drawFinalized,ticketsSoldDuringDraw) (src/Lottery.sol#230) -
minimumEligibleReferrals[drawFinalized + 1] = getMinimumEligibleReferralsFactorCalculation(ticketsSoldDuringDraw)
(src/ReferralSystem.sol#104-105) - referralDrawFinalize(drawFinalized,ticketsSoldDuringDraw) (src/Lottery.sol#230) -
playerRewardsPerDrawForOneTicket[drawFinalized] = playerRewardForDraw / ticketsSoldDuringDraw
(src/ReferralSystem.sol#120)  
 - referralDrawFinalize(drawFinalized,ticketsSoldDuringDraw) (src/Lottery.sol#230) -
referrerRewardPerDrawForOneTicket[drawFinalized] = referrerRewardForDraw / totalTicketsForReferrersPerCurrentDraw
(src/ReferralSystem.sol#112-113) Reference:
https://github.com/crytic/slither/wiki/Detector-Documentation#reentrancy-vulnerabilities-2

// @audit-issue should stick to checks-effects-interactions Reentrancy in Lottery.executeDraw()
(src/Lottery.sol#134-143): External calls: - requestRandomNumber() (src/Lottery.sol#141) - source.requestRandomNumber()
(src/RNSourceController.sol#112-118) Event emitted after the call(s): - StartedExecutingDraw(currentDraw)
(src/Lottery.sol#142)

// @audit-ok authorizedConsumer can't be changed to another contract Reentrancy in RNSourceBase.fulfill(uint256,uint256)
(src/RNSourceBase.sol#34-47): External calls: -
IRNSourceConsumer(authorizedConsumer).onRandomNumberFulfilled(randomNumber) (src/RNSourceBase.sol#44) Event emitted
after the call(s): - RequestFulfilled(requestId,randomNumber) (src/RNSourceBase.sol#46)

// @audit-issue should make sure to always set rewards token to DAI, or a non-ERC777 token Reentrancy in
Staking.getReward() (src/staking/Staking.sol#93-103): External calls: - lottery.claimRewards(LotteryRewardType.STAKING)
(src/staking/Staking.sol#99) - rewardsToken.safeTransfer(msg.sender,reward) (src/staking/Staking.sol#100) Event emitted
after the call(s): - RewardPaid(msg.sender,reward) (src/staking/Staking.sol#101)

// @audit-ok false positive, there is no external call here Reentrancy in Lottery.receiveRandomNumber(uint256)
(src/Lottery.sol#204-233): External calls: - winAmount[drawFinalized][selectionSize] =
drawRewardSize(drawFinalized,selectionSize) / jackpotWinners (src/Lottery.sol#210) -
Math.min(\_initialPot.getPercentage(BASE_JACKPOT_PERCENTAGE),jackpotBound) (src/LotterySetup.sol#170) - currentNetProfit
= LotteryMath.calculateNewProfit(currentNetProfit,ticketsSold[drawFinalized],ticketPrice,jackpotWinners >
0,fixedReward(selectionSize),expectedPayout) (src/Lottery.sol#217-224) -
Math.min(\_initialPot.getPercentage(BASE_JACKPOT_PERCENTAGE),jackpotBound) (src/LotterySetup.sol#170) -
referralDrawFinalize(drawFinalized,ticketsSoldDuringDraw) (src/Lottery.sol#230) -
totalTicketsSoldPrevDraw.getPercentage(PercentageMath.ONE_PERCENT) (src/ReferralSystem.sol#134) -
totalTicketsSoldPrevDraw.getPercentage(PercentageMath.ONE_PERCENT _ 75 / 100) (src/ReferralSystem.sol#138) -
totalTicketsSoldPrevDraw.getPercentage(PercentageMath.ONE_PERCENT _ 50 / 100) (src/ReferralSystem.sol#142) Event emitted
after the call(s): - CalculatedRewardsForDraw(drawFinalized,referrerRewardForDraw,playerRewardForDraw)
(src/ReferralSystem.sol#123) - referralDrawFinalize(drawFinalized,ticketsSoldDuringDraw) (src/Lottery.sol#230) -
FinishedExecutingDraw(drawFinalized,randomNumber,\_winningTicket) (src/Lottery.sol#232) // @audit-ok should stick to
checks-effects-interactions pattern Reentrancy in RNSourceController.requestRandomNumberFromSource()
(src/RNSourceController.sol#106-120): External calls: - source.requestRandomNumber()
(src/RNSourceController.sol#112-118) Event emitted after the call(s): - FailedRNRequest(source,bytes(reason))
(src/RNSourceController.sol#115) - FailedRNRequest(source,reason_scope_0) (src/RNSourceController.sol#117) -
SuccessfulRNRequest(source) (src/RNSourceController.sol#113)

// @audit-ok stakingToken is created by the Wenwin team, this is fine Reentrancy in Staking.withdraw(uint256)
(src/staking/Staking.sol#81-91): External calls: - stakingToken.safeTransfer(msg.sender,amount)
(src/staking/Staking.sol#88) Event emitted after the call(s): - Withdrawn(msg.sender,amount)
(src/staking/Staking.sol#90) Reference:
https://github.com/crytic/slither/wiki/Detector-Documentation#reentrancy-vulnerabilities-3

// @audit-ok doesn't rely on it for randomness, influencing this would result in no gain Lottery.claimable(uint256)
(src/Lottery.sol#160-169) uses timestamp for comparisons Dangerous comparisons: - block.timestamp <=
ticketRegistrationDeadline(ticketInfo.drawId + LotteryMath.DRAWS_PER_YEAR) (src/Lottery.sol#165)
RNSourceController.retry() (src/RNSourceController.sol#60-75) uses timestamp for comparisons Dangerous comparisons: -
block.timestamp - lastRequestTimestamp <= maxRequestDelay (src/RNSourceController.sol#64)
RNSourceController.swapSource(IRNSource) (src/RNSourceController.sol#89-104) uses timestamp for comparisons Dangerous
comparisons: - notEnoughTimeReachingMaxFailedAttempts = block.timestamp < maxFailedAttemptsReachedAt + maxRequestDelay
(src/RNSourceController.sol#94) - notEnoughRetryInvocations || notEnoughTimeReachingMaxFailedAttempts
(src/RNSourceController.sol#95) Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#block-timestamp

// @audit-ok this is user gas, and can't do DoS because can call function with less ticketIds anytime
Ticket.mint(address,uint128,uint120) (src/Ticket.sol#25-29) has costly operations inside a loop: - ticketId =
nextTicketId ++ (src/Ticket.sol#26) Reference:
https://github.com/crytic/slither/wiki/Detector-Documentation#costly-operations-inside-a-loop

// @audit-issue solc-0.8.19 is not recommended for deployment Reference:
https://github.com/crytic/slither/wiki/Detector-Documentation#incorrect-versions-of-solidity

// @audit-issue Function ILotteryToken.INITIAL_SUPPLY() (src/interfaces/ILotteryToken.sol#13) is not in mixedCase
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#conformance-to-solidity-naming-conventions
