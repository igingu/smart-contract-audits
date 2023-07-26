## Summary
A club is an ERC721 NFT owned by an owner. Each club has a FootiumEscrow contract linked to it. The FootiumEscrow contract is responsible for holding tokens and players for the club, and [its' transfer/approve functions can only be triggered by the club's owner](https://github.com/sherlock-audit/2023-04-footium-igingu/blob/main/footium-eth-shareable/contracts/FootiumEscrow.sol#L33). The club NFT on its own is worthless, if it doesn't hold any tokens/players => its' value is directly proportional to the players and tokens it holds in escrow. 

A FootiumClub is a standard ERC721 token, which makes it tradeable/transferable on an open/secondary market.

## Vulnerability Detail
Assume Bob owns ManchesterClub NFT, which holds 1e18 FootiumTokens, and 100 players in its' escrow. Given how valuable the underlying assets are in the Footium ecosystem, Bob puts the NFT for sale on Rarible, for 1 ETH. Someone accepts that offer, and a FootiumClub.transferFrom(Bob, buyer) is submitted to the blockchain. Bob frontruns this transaction with some transactions of his own, namely transfering the 1e18 FootiumTokens and 100 players to his secondary club, ChelseaClub NFT's escrow, by calling FootiumEscrow.transferERC20 and FootiumEscrow.transferERC721.

## Impact
Victim ends up buying ManchesterClub NFT for 1 ETH, only that now, ManchesterClub holds no tokens and no players. Bob ends the day with the initial 100 players and 1e18 tokens (now linked to ChelseaClub NFT), and 1 ETH. Bob is free to perform scam again.

A similar vulnerability has been recently flagged as a Medium on a Code4rena audit - [the buyer of a winning lottery ticket could be frontrun by the ticket's owner, who claims the ticket before - buyer gets claimed winning ticket, owner gets trade profits and winning ticket rewards](https://code4rena.com/reports/2023-03-wenwin/#m-03-the-buyer-of-the-ticket-could-be-front-runned-by-the-ticket-owner-who-claims-the-rewards-before-the-tickets-nft-is-traded)

## Code Snippet
https://github.com/sherlock-audit/2023-04-footium-igingu/blob/main/footium-eth-shareable/contracts/FootiumClub.sol#L16
https://github.com/sherlock-audit/2023-04-footium-igingu/blob/main/footium-eth-shareable/contracts/FootiumEscrow.sol#L105

## Tool used

Manual Review

## Recommendation
Given that a FootiumClub NFT is so tightly coupled with a FootiumEscrow contract, through the club's admin, a potential remediation for this would be to modify FootiumClub's transfer function to one that accepts two additional parameters:
* the number of tokens held by the club
* the number of players held by the club

Transfer function could check that while it's being executed, the current number of tokens and players in the escrow is the same as what the buyer wanted to get in the first place, and revert otherwise (this can be achieved by calling ```FootiumToken.balanceOf(clubToEscrow[clubId])``` and ```FootiumPlayer.balanceOf(clubToEscrow[clubId])```. This would make the frontrunning attack a lot more difficult to perform, probably non-profitable. 