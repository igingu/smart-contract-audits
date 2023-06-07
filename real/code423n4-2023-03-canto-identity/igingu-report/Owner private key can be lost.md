# [M-03] Namespace protocol: owner functions can be unaccessible by losing owner private key

Having only one owner is a single point of failure. For increased security and making sure that owner functions will always be accessible, multiple private keys should be owners, even if they belong to the same real-world person. 

## Impact:
Losing owner's private key would make ```changeRevenueAddress``` and ```changeNoteAddress``` functions unaccessible.

## Remediation:
Setup Ownable smart contracts with 3 owners, using [OpenZeppelin's Access Control](https://docs.openzeppelin.com/contracts/4.x/access-control#using-access-control)