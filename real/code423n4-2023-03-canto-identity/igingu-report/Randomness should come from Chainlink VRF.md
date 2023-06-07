# [M-02] Namespace protoccol: trays are minted based on very easy to calculate pseudo-randomness

In Namespace protocol, a Namespace NFT is created from fusing trays, which are NFTs holding 7 characters. Trays are minted based [on an open, easy to predict pseudo-random-number-generator](https://github.com/code-423n4/2023-03-canto-identity/blob/main/canto-namespace-protocol/src/Tray.sol#L247), implemented as [iteratePRNG](https://github.com/code-423n4/2023-03-canto-identity/blob/main/canto-namespace-protocol/src/Utils.sol#L256). Each tray can contain characters from 10 different font classes, with probabilities for each font class ranging from [32/109 to 1/109](https://github.com/code-423n4/2023-03-canto-identity/blob/main/canto-namespace-protocol/src/Tray.sol#L22). This means that characters belonging to super rare font classes will be considerably more scarce, and so a lot more valuable.

Using a pseudo-random-number-generator means one can predict what tray they will get before minting, with a lot of ease.

## Impact:
The impact is three-fold, first two being more dangerous to normal users (sniping and front-running):

* off-chain bots can monitor the state of the pseudo-random-number-generator, and snipe upcoming trays with characters from super rare font classes, effectively establishing a monopoly over them.
* off-chain bots can monitor the mempool for transactions which will end up minting characters from super rare font classes, and frontrun them, effectively establishing a monopoly over them.
* most people have a nickname/name that they use in the virtual space, which they will probably want to fuse into their NFT. For that they will need to mint enough trays so that they have all the required characters. Knowing what tray I will get before minting it would make it a waste of money if I don't get the right characters, which can make me not mint it in the first place, which will slow down adoption of this protocol.

## Remediation:
Use [Chainlink's Verified Random Function](https://chain.link/vrf) to generate truly random numbers. If implemented correctly, integrating Chainlink VRF won't have possibility of predicting future tray, sniping or front-running.
