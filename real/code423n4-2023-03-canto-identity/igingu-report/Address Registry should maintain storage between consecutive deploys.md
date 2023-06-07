# [H-01] Profile Picture: Address Registry should maintain storage between consecutive deploys

This vulnerability is more in the code of Canto Identity Protocol, but it impacts the ProfilePicture Subprotocol.

A ProfilePicture NFT (with id=```pfpId```) is linked to a CID NFT (with id=```cidId```) and another referenced NFT (with id=```referencedId```). In order for a Profile Picture NFT to return a ```tokenURI```, [the address registered at cidId has to be the same as the owner of ```referencedId``` NFT](https://github.com/code-423n4/2023-03-canto-identity/blob/main/canto-pfp-protocol/src/ProfilePicture.sol#L101), effectively meaning that ```pfpId``` is only valid if it is linked to a CID NFT, the CID NFT is registered with the [AddressRegistry](https://github.com/code-423n4/2023-03-canto-identity/blob/main/canto-identity-protocol/src/AddressRegistry.sol) for an address, and that address is also the owner of ```referencedId```.

[CIDNFT has the functionality to change the address registry to a new one](https://github.com/code-423n4/2023-03-canto-identity/blob/main/canto-identity-protocol/src/CidNFT.sol#L432), effectively destroying all previous mappings between users' addresses and CIDNFT ids (a new AddressRegistry contract means a fresh [mapping between address and CIDNFT id](https://github.com/code-423n4/2023-03-canto-identity/blob/main/canto-identity-protocol/src/AddressRegistry.sol#L22)).

## Impact
Changing the Address Registry smart contract and CIDNFT's [addressRegistry address](https://github.com/code-423n4/2023-03-canto-identity/blob/main/canto-identity-protocol/src/CidNFT.sol#L36) would immediately make ALL ProfilePicture NFTs useless, until each user in turn re-registers their CIDNFT with the new AddressRegistry contract ([tokenURI](https://github.com/code-423n4/2023-03-canto-identity/blob/main/canto-pfp-protocol/src/ProfilePicture.sol#L70) would not be able to be called anymore because of [this check](https://github.com/code-423n4/2023-03-canto-identity/blob/main/canto-pfp-protocol/src/ProfilePicture.sol#L101), now that users' CIDNFTs are no longer registered for their address).

## Remediation
AddressRegistry should be behind a Proxy, and measures should be taken so that changing the AddressRegistry implementation would not invalidate previous storage. CIDNFT smart contract should have immutable AddressRegistry address (the address of the proxy).

The above could be implemented using [OpenZeppelin's Proxies](https://docs.openzeppelin.com/contracts/4.x/api/proxy). Please also read about the [Proxy Upgrade Pattern](https://docs.openzeppelin.com/upgrades-plugins/1.x/proxies), to make sure memory is persisted between subsequent deploys of implementation.
