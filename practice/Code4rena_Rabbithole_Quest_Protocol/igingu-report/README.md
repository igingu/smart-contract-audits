# https://code4rena.com/contests/2023-01-rabbithole-quest-protocol-contest

parameters could be calldata
wrong function visibility (public everywhere, should be external, private, etc.)
basis points max should be constant (10_000)
wrong comments (         require(_exists(tokenId_), 'ERC721URIStorage: URI query for nonexistent token');)
imports not ordered
functions don't respect solidity conventions (naming for private/internal, variables start with uppercase)
isPaused is already false     function start() public virtual onlyOwner {
There is no need for started and paused. Users can only do things once quest is both started and unpaused. Can just create quest and set paused to true at the beginning, then pause/unpause at will. Can use OwnablePausable.
Doesn't respect Solidity conventions function ordering
    function _calculateRewards(uint256) internal virtual returns (uint256) {
        revert MustImplementInChild();
    } this is not common practice, can just leave them as virtual I guess? Do we want to ever instantiate Quest?
inefficient way to check equality         if (quests[questId_].numberMinted + 1 > quests[questId_].totalParticipants) revert OverMaxAllowedToMint();
questFee is too high, and should be configurable?


























**NEW THING LEARNED**: ```hardhat@2.12.2``` requires **node** "^14.0.0 || ^16.0.0 || ^18.0.0". Used [nvm](https://github.com/nvm-sh/nvm) to install and change node versions. 
```
nvm install 18.14.2
nvm current node -v
v18.14.2
```

**NEW THING LEARNED**: [ERC-1155: Multi Token Standard](https://eips.ethereum.org/EIPS/eip-1155) is a smart contract interface that can represent any number of fungible and non-fungible token types: each **token id** represents a new configurable token type, which can have its own metadata, supply and other attributes. ERC20/ERC721 require a separate contract for each token type, which places redundant bytecode on chain, with a lot of gas cost. ERC-1155 can transfer multiple tokens at once, saving on tx costs. No more need to approve individual token contracts separately.

Caveat: For NFTs, you no longer have the ```ownerOf(nftId)``` functionality, returning the owner of each nftID. Figuring out who the owner of an NFT is should be done using custom off-chain event analyzers (looking through all Transfer events), or TheGraph.

[OpenZeppelin implementation](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC1155/ERC1155.sol)

Has ```safeTransferFrom```, ```safeBatchTransferFrom```, ```_mint```, ```_mintBatch```, ```_burn```, ```_burnBatch```, ```_beforeTokenTransfer```, ```_afterTokenTransfer```, ```_doSafeTransferAcceptanceCheck``` that receipient can receive tokens, ```_doSafeBatchTransferAcceptanceCheck``` that recipients can receive token.

**NEW THING LEARNED**: [OpenSea metadata standards for NFTs](https://docs.opensea.io/docs/metadata-standards)

The tokenURI function in your ERC721 or the uri function in your ERC1155 contract should return an HTTP or IPFS URL. When queried, this URL should in turn return a JSON blob of data with the metadata for your token. This way, OpenSea can display your NFTs picture, metadata and so on.

Example:
```
{
  "description": "Friendly OpenSea Creature that enjoys long swims in the ocean.", 
  "external_url": "https://openseacreatures.io/3", 
  "image": "https://storage.googleapis.com/opensea-prod.appspot.com/puffs/3.png", 
  "name": "Dave Starbelly",
  "attributes": [ ... ]
}
```

**NEW THING LEARNED**: Deploying OpenZeppelin Upgradable Proxies uses the [OpenZeppelin Hardhat Upgrades API](https://docs.openzeppelin.com/upgrades-plugins/1.x/api-hardhat-upgrades), namely the [deployProxy function](https://github.com/rabbitholegg/quest-protocol/blob/8c4c1f71221570b14a0479c216583342bd652d8d/scripts/deployRabbitHoleTickets.js#L17)

This creates a Transparent or UUPS proxy given an ethers contract factory to use as an implementation, and returns a contract instance with the proxy address and the implementation interface. If ```args``` is set, will call an initializer function ```initialize``` with the supplied ```args``` during proxy deployment.

**NEW THING LEARNED**: [OpenZeppelin's Transparent Proxy Pattern](https://blog.openzeppelin.com/the-transparent-proxy-pattern/) - users interact with a proxy that holds the state and delegates execution to a logic contract that holds the code.

Techniques:
* [Proxy Forwarding](https://blog.openzeppelin.com/the-transparent-proxy-pattern/) - assembly code put in fallback function, that will forward any call to any function with any set of parameters to a logic contract - copies calldata to memory, call is forwarded to logic contract, return dara from the call to the logic contract is retrieved, returned data is forwarded back to caller - uses **DELEGATECALL** => the logic contract controls the proxy's state, and the logic contract's state is meaningless.
* [Unstructured Storage Proxies](https://blog.openzeppelin.com/the-transparent-proxy-pattern/) - since implementation's and proxy's storages can overlap, implementation address will live at a random address
```
bytes32 private constant implementationPosition = bytes32(uint256(
  keccak256('eip1967.proxy.implementation')) - 1
));
```
* [Storage collisions between implementation versions](https://docs.openzeppelin.com/upgrades-plugins/1.x/proxies#storage-collisions-between-implementation-versions) - storage hierarchy in implementation should always be appended, not modified. Storage members should keep their types
* [Constructor caveat](https://docs.openzeppelin.com/upgrades-plugins/1.x/proxies#storage-collisions-between-implementation-versions) - the constructor of implementation is ran at contract creation time, not through delegatecall, so it will not update the Proxy's state. Initialization needs to be done through an **initialize** function, only callable once.
* [Function Clashes](https://docs.openzeppelin.com/upgrades-plugins/1.x/proxies#storage-collisions-between-implementation-versions) - functions called by owner will be looked for in proxy, functions called by someone else will be looked for in implementation

[Proxy specifications](https://docs.openzeppelin.com/contracts/4.x/api/proxy)

[Initializable](https://docs.openzeppelin.com/contracts/4.x/api/proxy#Initializable) - provides the **initialize** function to initialize proxy state - can initialize with initial version, or [reinitialize](https://docs.openzeppelin.com/contracts/4.x/api/proxy#Initializable-reinitializer-uint8-) with subsequent version. The [initializer](https://docs.openzeppelin.com/contracts/4.x/api/proxy#Initializable-initializer--) modifier that protects **initialize** only be called onceTo avoid leaving a contract uninitialized (implementation), should invoke the [_disableInitializers](https://docs.openzeppelin.com/contracts/4.x/api/proxy#Initializable-_disableInitializers--) function in the constructor to lock it when it is deployed.

I found **_disableInitializers** very hard to understand, but [this post](https://forum.openzeppelin.com/t/uupsupgradeable-vulnerability-post-mortem/15680) made it very clear to me. You want to stop the implementation contracts from being initialized, since if they contain any **selfdestruct** or **delegatecall**, someone else could initialize it and use the **selfdestruct** or **delegatecall** into malicious contract with **selfdestruct** to destroy your implementation contract, leaving your proxy without implementation. If **_disableInitializers** is called in the implementation's constructor, the proxy can still call the **initialize** function on it and init the proxy's state (because of delegatecall). 

**NEW THING LEARNED**: [ERC-2981: NFT Royalty Standard](https://eips.ethereum.org/EIPS/eip-2981) - standard that allows contracts to signal a royalty amount to be paid to the NFT creator or rights holder every time the NFT is sold or re-sold.

```
 function royaltyInfo(
    uint256 _tokenId,
    uint256 _salePrice
) external view returns (
    address receiver,
    uint256 royaltyAmount
);
```

This way, marketplace intermediates NFT trades. When it's time to swap the NFT for the funds, it will call the royaltyInfo function on the NFT's contract, to figure out who to send how much royalty to.

**NEW THING LEARNED**: Use Solidity Visual Auditor's Inline Bookmarks:

**NEW THING LEARNED**: [ERC721Enumerable](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/ERC721Enumerable.sol) is an optional extension which adds enumerability of all the token ids in the contract, as well as enumerability of tokenIds owned by an account.

```
function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256)
```

```
function tokenByIndex(uint256 index) public view virtual override returns (uint256)
```

[ERC721URIStorage](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/ERC721URIStorage.sol) adds [storage based token URI management](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/ERC721URIStorage.sol#L28). Returns NFTs' **baseURI** + URI ending specific to each token.