## Noted in the QA-Report
Warning: Unreachable code.
   --> contracts/Quest.sol:113:9:
    |
113 |         _setClaimed(tokens);
    |         ^^^^^^^^^^^^^^^^^^^

Warning: Unreachable code.
   --> contracts/Quest.sol:114:9:
    |
114 |         _transferRewards(totalRedeemableRewards);
    |         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Warning: Unreachable code.
   --> contracts/Quest.sol:115:9:
    |
115 |         redeemedTokens += redeemableTokenCount;
    |         ^ (Relevant source part starts here and spans across multiple lines).




Quest.constructor(address,uint256,uint256,uint256,uint256,string,address).rewardTokenAddress_ (contracts/Quest.sol#27) lacks a zero-check on :
                - rewardToken = rewardTokenAddress_ (contracts/Quest.sol#40)
Erc20Quest.constructor(address,uint256,uint256,uint256,uint256,string,address,uint256,address).protocolFeeRecipient_ (contracts/Erc20Quest.sol#26) lacks a zero-check on :
                - protocolFeeRecipient = protocolFeeRecipient_ (contracts/Erc20Quest.sol#39)
QuestFactory.initialize(address,address,address).claimSignerAddress_ (contracts/QuestFactory.sol#38) lacks a zero-check on :
                - claimSignerAddress = claimSignerAddress_ (contracts/QuestFactory.sol#45)
QuestFactory.setClaimSignerAddress(address).claimSignerAddress_ (contracts/QuestFactory.sol#159) lacks a zero-check on :
                - claimSignerAddress = claimSignerAddress_ (contracts/QuestFactory.sol#160)
RabbitHoleReceipt.initialize(address,address,address,uint256).royaltyRecipient_ (contracts/RabbitHoleReceipt.sol#45) lacks a zero-check on :
                - royaltyRecipient = royaltyRecipient_ (contracts/RabbitHoleReceipt.sol#52)
RabbitHoleReceipt.initialize(address,address,address,uint256).minterAddress_ (contracts/RabbitHoleReceipt.sol#46) lacks a zero-check on :
                - minterAddress = minterAddress_ (contracts/RabbitHoleReceipt.sol#53)
RabbitHoleReceipt.setRoyaltyRecipient(address).royaltyRecipient_ (contracts/RabbitHoleReceipt.sol#71) lacks a zero-check on :
                - royaltyRecipient = royaltyRecipient_ (contracts/RabbitHoleReceipt.sol#72)
RabbitHoleReceipt.setMinterAddress(address).minterAddress_ (contracts/RabbitHoleReceipt.sol#83) lacks a zero-check on :
                - minterAddress = minterAddress_ (contracts/RabbitHoleReceipt.sol#84)
RabbitHoleTickets.initialize(address,address,address,uint256).royaltyRecipient_ (contracts/RabbitHoleTickets.sol#34) lacks a zero-check on :
                - royaltyRecipient = royaltyRecipient_ (contracts/RabbitHoleTickets.sol#41)
RabbitHoleTickets.initialize(address,address,address,uint256).minterAddress_ (contracts/RabbitHoleTickets.sol#35) lacks a zero-check on :
                - minterAddress = minterAddress_ (contracts/RabbitHoleTickets.sol#42)
RabbitHoleTickets.setRoyaltyRecipient(address).royaltyRecipient_ (contracts/RabbitHoleTickets.sol#60) lacks a zero-check on :
                - royaltyRecipient = royaltyRecipient_ (contracts/RabbitHoleTickets.sol#61)
RabbitHoleTickets.setMinterAddress(address).minterAddress_ (contracts/RabbitHoleTickets.sol#73) lacks a zero-check on :
                - minterAddress = minterAddress_ (contracts/RabbitHoleTickets.sol#74)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#missing-zero-address-validation

Reentrancy in QuestFactory.createQuest(address,uint256,uint256,uint256,uint256,string,string) (contracts/QuestFactory.sol#61-137):
        External calls:
        - newQuest.transferOwnership(msg.sender) (contracts/QuestFactory.sol#100)
        State variables written after the call(s):
        - ++ questIdCount (contracts/QuestFactory.sol#101)
Reentrancy in QuestFactory.createQuest(address,uint256,uint256,uint256,uint256,string,string) (contracts/QuestFactory.sol#61-137):
        External calls:
        - newQuest_scope_0.transferOwnership(msg.sender) (contracts/QuestFactory.sol#131)
        State variables written after the call(s):
        - ++ questIdCount (contracts/QuestFactory.sol#132)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#reentrancy-vulnerabilities-2

Quest.constructor(address,uint256,uint256,uint256,uint256,string,address) (contracts/Quest.sol#26-46) uses timestamp for comparisons
        Dangerous comparisons:
        - endTime_ <= block.timestamp (contracts/Quest.sol#35)
        - startTime_ <= block.timestamp (contracts/Quest.sol#36)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#block-timestamp

Quest.isClaimed(uint256) (contracts/Quest.sol#134-136) compares to a boolean constant:
        -claimedList[tokenId_] == true (contracts/Quest.sol#135)
QuestFactory.createQuest(address,uint256,uint256,uint256,uint256,string,string) (contracts/QuestFactory.sol#61-137) compares to a boolean constant:
        -rewardAllowlist[rewardTokenAddress_] == false (contracts/QuestFactory.sol#73)
QuestFactory.mintReceipt(string,bytes32,bytes) (contracts/QuestFactory.sol#219-229) compares to a boolean constant:
        -quests[questId_].addressMinted[msg.sender] == true (contracts/QuestFactory.sol#221)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#boolean-equality

Quest._calculateRewards(uint256) (contracts/Quest.sol#122-124) is never used and should be removed
Quest._transferRewards(uint256) (contracts/Quest.sol#128-130) is never used and should be removed
RabbitHoleReceipt._burn(uint256) (contracts/RabbitHoleReceipt.sol#139-141) is never used and should be removed
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#dead-code

Pragma version^0.8.15 (contracts/Erc1155Quest.sol#2) allows old versions
Pragma version^0.8.15 (contracts/Erc20Quest.sol#2) allows old versions
Pragma version^0.8.15 (contracts/Quest.sol#2) allows old versions
Pragma version^0.8.15 (contracts/QuestFactory.sol#2) allows old versions
Pragma version^0.8.15 (contracts/RabbitHoleReceipt.sol#2) allows old versions
Pragma version^0.8.15 (contracts/RabbitHoleTickets.sol#2) allows old versions
Pragma version^0.8.15 (contracts/ReceiptRenderer.sol#2) allows old versions
Pragma version^0.8.15 (contracts/TicketRenderer.sol#2) allows old versions
Pragma version^0.8.15 (contracts/interfaces/IQuest.sol#2) allows old versions
Pragma version^0.8.15 (contracts/interfaces/IQuestFactory.sol#2) allows old versions
solc-0.8.15 is not recommended for deployment
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#incorrect-versions-of-solidity

Variable RabbitHoleReceipt.ReceiptRendererContract (contracts/RabbitHoleReceipt.sol#35) is not in mixedCase
Variable RabbitHoleReceipt.QuestFactoryContract (contracts/RabbitHoleReceipt.sol#36) is not in mixedCase
Variable RabbitHoleTickets.TicketRendererContract (contracts/RabbitHoleTickets.sol#25) is not in mixedCase
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#conformance-to-solidity-naming-conventions
. analyzed (58 contracts with 81 detectors), 35 result(s) found