Summary
Users can not claim prizes if ERC20MerkleTree's and ETHMerkleTree's prizes are not all incremented by the required amounts

Vulnerability Detail
When claiming a prize, a user is only sent the amount that is validated in the merkle tree, minus the amount they have already claimed. When a second round of rewards has to be sent, the owner can update the FootiumPrizeDistributor with the roots of the new merkle trees, but the totalERC20Claimed and totalETHClaimed claimed mappings are not reset. Setting merkle trees where reward amounts are the amounts of the second round, and not the amounts of the second round added to the initial rewards will DoS prize claiming for users, or make users eligible for smaller rewards than intended.

Example:
At the end of season 1, Bob is assigned a prize of 0.1 ETH. Bob claims the 0.1 ETH, which makes totalETHClaimed[Bob] equal to 0.1 ETH. Season 2 plays out, and Bob is assigned yet another 0.05 ETH. Owners create a new Merkle Tree, setting all the rewards, as well as a leaf with (Bob, 0.05ETH). When calling claimETHPrize(Bob, 0.05 ETH, proof), uint256 value = _amount - totalETHClaimed[_to]; will revert, since 0.05 ETH - 0.1 ETH underflows. In order to prevent this, owners should have created the new Merkle Tree with (Bob, all_rewards_to_Bob_so_far + 0.05ETH), which is not enforced anywhere and can't be. This however can be easily mitigated, which I will show in Recommendations.

Impact
From the second assigned reward onwards, users can either not claim it, or they will be able to claim a smaller amount than intended (eg. first reward was 0.1 ETH; second reward was 0.2 ETH; with the current code, user will be able to claim 0.1 ETH after season 1, and 0.2 - 0.1 = 0.1 ETH after season 2, totalling 0.2 ETH, not 0.3 ETH.

Code Snippet
https://github.com/sherlock-audit/2023-04-footium-igingu/blob/main/footium-eth-shareable/contracts/FootiumPrizeDistributor.sol#L163

Tool used
Manual Review

Recommendation
Instead of tracking how much a user has already claimed, one can track if a user has claimed or not, given that claiming implies they get the full amount anyway.

uint256 value = _amount - totalERC20Claimed[_token][_to];

  if (value > 0) {
      totalERC20Claimed[_token][_to] += value;
      _token.transfer(_to, value);
  }
  
  -> 
  
  if (userHasClaimed[erc20MerkleRoot][_to] == false) {
      userHasClaimed[erc20MerkleRoot][_to] = true;
      _token.transfer(_to, value);
  }
Same for ethMerkleRoot.