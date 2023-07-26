Summary
Club owners can mint players for free when fee was not provided for divisionTier. Can be prevented using trivial check

Vulnerability Detail
When minting players, a club owner needs to pay a totalFee, which is calculated by multiplying the number of players minted by the fee of the divisionTier.. Fees for each divisions are set during initialization, but nowhere is it checked that fees for the divisionTier have been set correctly or at all.

Impact
When minting players, if divisionTier > fees.length or fees[i] == 0, club owners can mint unlimited players for free.

Code Snippet
https://github.com/sherlock-audit/2023-04-footium-igingu/blob/main/footium-eth-shareable/contracts/FootiumAcademy.sol#L258

Tool used
Manual Review

Recommendation
Add a check that the divisionToFee[divisionTier] != 0. This prevents either setting the fee incorrectly, or minting players for a division that is present in the merkle tree, but for which the fee has not been set at the beginning.

if (SeasonID.unwrap(seasonId) > currentSeasonId) {
    revert PlayerTooYoung(seasonId);
}

->

if (SeasonID.unwrap(seasonId) > currentSeasonId) {
    revert PlayerTooYoung(seasonId);
}

if (divisionToFee[divisionTier] == 0) {
    revert DivisonFeeCanNotBeZero(divisionTier);
}