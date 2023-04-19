# https://code4rena.com/contests/2022-12-caviar-contest

NFBM - Not Found By Me

Known issues: https://gist.github.com/Picodes/42f9144fd8cba738f3a7098411737760

# Steps I took
1. Set up the project
```
yarn
foundryup
forge install
forge test --gas-report
```

2. Looked into [testing documentation](https://github.com/code-423n4/2022-12-caviar/blob/main/docs/TESTING.md)
    * Ran solhint and discovered 12 solhint warnings
    ```
    solhint ./src/**.sol
    solhint ./src/lib/**.sol
    ```
    * Ran gas report
    ```
    forge test --gas-report
    ```
    * Generated test coverage report and looked over:
    ```
    forge coverage --report lcov && genhtml lcov.info -o coverage
    ```
    * Reproduced static analysis steps with slither
    ```
    slither .
    ```
    * [Slither report with my comments](./slither/slither-report-commented.md)

3. Started looking into code and [specification documentation](https://github.com/code-423n4/2022-12-caviar/blob/main/docs/SPECIFICATION.md), in this order:
    * SafeERC20Namer.sol
    * LpToken.sol: SolMate.ERC20.sol, SolMate.Owned.sol, and then LpToken.sol
    * Caviar.sol
    * Pair.sol: Solmate.ERC721.sol, Solmate.SafeTransferLib.sol, Solmate.MerkleProofLib.sol, NFTWrapping, Core AMM, NFT AMM
    * Pair.sol: Emergency logic

**NEW THINGS LEARNED**: foundry uses ```foundry.toml``` for configurations.

**NEW THING LEARNED**: forge has a flag for gas reports, and can also produce code coverage reports:
```
forge test --gas-reports
forge coverage --report lcov
```

**NEW THING LEARNED**: solc-select, a tool used to install different solidity compiler versions, and switch between them. Caviar needed 0.8.17, and instructed to do:
```
solc-select install 0.8.17
solc-select use 0.8.17
solc --version
Version: 0.8.17+commit.8df45f5f.Linux.g++
```

**NEW THING LEARNED**: Using [Slither](https://github.com/crytic/slither/), the Solidity source analyzer. Slither uses ```slither.config.json``` for configurations.

**NEW THING LEARNED**: ```staticcall``` in solidity is used whenever you want the call you are making (external call) to not modify state, otherwise it will revert. There are times when you call functions on unknown contracts, and you want to make sure they don't change state by reentering or w/e.

**NEW THING LEAERNED**: [Uniswap SafeERC20Namer.sol](https://github.com/Uniswap/solidity-lib/blob/master/contracts/libraries/SafeERC20Namer.sol) is used because some ERC20 tokens either lack ```symbol()``` implementation, or return bytes32 instead of string. Most contracts use the ```SafeERC20Namer.tokenSymbol()``` function.

**NEW THING LEARNED**: [Solmate](https://github.com/transmissions11/solmate), a gas-optimized library similar but smaller than OpenZeppelin.
This project utilizes Solmate's **Owned.sol** and **ERC20.sol**.

**NEW THING LEARNED**: [EIP-2612](https://eips.ethereum.org/EIPS/eip-2612) - [Permit Extension](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/extensions/ERC20Permit.sol#L57). Current flow of smart contract pulling funds from user involves EOA doing **approve**, and then smart contract doing **transferFrom**. This implies that the EOA requires ETH to initially call **approve** function (needs to pay gas). EIP2612 extends the ERC20 standard with a **permit** function, which allows changing an account's allowance by presenting a message signed by the account. This way, the EOA that needs to do **approve** no longer requires ETH to pay gas - it can sign the transaction off-chain, and let someone else send it through the **permit** function.

```function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s ) public virtual override {}```

**NEW THING LEARNED**: [ERC-721 safeTransferFrom](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol#L192) makes it so that you can only transfer tokens to an EOA or a contract that implements the [IERC721Receiver.onERC721Received](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721Receiver.sol#L21) function correctly.

**NEW THING LEARNED**: [ERC-1820: Pseudo-introspection Registry Contract](https://eips.ethereum.org/EIPS/eip-1820): the more modern version or [ERC-165: Standard Interface Detection](https://eips.ethereum.org/EIPS/eip-165) and it's use with **supportsInterface**. ERC-1820 defines a universal registry smart contract where any address can register which interface it supports, and what smart contract address is responsible for its implementation (in case of proxies). Also acts as an ERC-165 cache to reduce gas consumption.

Registry contract address is the same on every chain: [Goerli](https://goerli.etherscan.io/address/0x1820a4B7618BdE71Dce8cdc73aAB6C95905faD24), [Polygon](https://polygonscan.com/address/0x1820a4B7618BdE71Dce8cdc73aAB6C95905faD24), deployed by 0xa990077c3205cbDf861e17Fa532eeB069cE9fF96.

**NEW THING LEARNED**: [ERC-777 Token Standard](https://eips.ethereum.org/EIPS/eip-777). The ERC-777 standard is fully backwards-compatible with ERC20, and adds advanced features to interact with tokens:
* operators to send tokens on behalf of another address (contract or EOA)
* send/receive hooks, to offer token holders more control over their tokens; if A sends X tokens to B, the flow will be:
    * call [ERC777TokensSender.tokensToSend](https://github.com/0xjac/ERC777/blob/master/contracts/examples/ReferenceToken.sol#L277) on token sender 
    * decrease sender balance; increase receiver balance;
    * call [ERC777TokenRecipient.tokensReceived](https://github.com/0xjac/ERC777/blob/master/contracts/examples/ReferenceToken.sol#L313) on token receiver
    * if a contract wants to completely reject holding any token, they can implement their **tokensReceived** hook to always revert, effectivily blocking all transfers to this address

[Reference implementation](https://github.com/0xjac/ERC777/blob/master/contracts/examples/ReferenceToken.sol)

[ERC777TokensSender example](https://github.com/0xjac/ERC777/blob/master/contracts/examples/ExampleTokensSender.sol) + [ERC777TokensRecipient example](https://github.com/0xjac/ERC777/blob/master/contracts/examples/ExampleTokensRecipient.sol)

**NEW THING LEARNED**: [Reentrancy possible using ERC-777 tokens](https://code4rena.com/reports/2022-12-caviar/#h-01-reentrancy-in-buy-function-for-erc777-tokens-allows-buying-funds-with-considerable-discount)

**NEW THING LEARNED**: [Swaps, adding/removing liquidity and similar actions should have a deadline set](https://code4rena.com/reports/2022-12-caviar/#m-01-missing-deadline-checks-allow-pending-transactions-to-be-maliciously-executed).

**NEW THING LEARNED**: To avoid insolvency, [should round up incoming assets, and round down outgoing assets](https://code4rena.com/reports/2022-12-caviar/#m-03-rounding-error-in-buyquote-might-result-in-free-tokens) => avoids giving out free tokens.

**NEW THING LEARNED**: [x*y=k invariants should be maintained by tracking pair's reserves internally, not querying balances](https://code4rena.com/reports/2022-12-caviar#m-05-pair-price-may-be-manipulated-by-direct-transfers).

**NEW THING LEARNED**: [Should use safeTransferOwnership instead of transferOwnership](https://code4rena.com/reports/2022-12-caviar#l-02-use-safetransferownership-instead-of-transferownership-function).

# Findings

## High risk findings
### H-01

---
## Medium risk findings
### M-01: User can wrap NFTs and unwrap it for other NFT ids, also found by Code4rena: [https://code4rena.com/reports/2022-12-caviar/#m-04-its-possible-to-swap-nft-token-ids-without-fee-and-also-attacker-can-wrap-unwrap-all-the-nft-token-balance-of-the-pair-contract-and-steal-their-air-drops-for-those-token-ids](M-04)

---
## Low risk findings
### L-01-NFBM: Given that the Pair contract can hold NFT tokens, it could potentially receive token airdrops because of it. There is no withdraw function for token airdrops.

### L-02-NFBM: [No reentrancy guard for withdraw function](https://github.com/code-423n4/2022-12-caviar/blob/main/src/Pair.sol#L359-L373).

### L-03-NFBM: [Solmate's SafeTransferLib doesn't check if ERC20 contract exists](https://code4rena.com/reports/2022-12-caviar/#l-04-solmates-safetransferlib-doesnt-check-whether-the-erc20-contract-exists)

---
## Non-Critical findings
### N-01: Solhint shows warnings for "global import of path <path> is not allowed. Specify names to import individually". 
* ```solhint ./src/**.sol```
    * ./src/Caviar.sol: 3 places
    * ./src/LpToken.sol: 2 places
    * ./src/Pair.sol: 7 places
* ```solhint ./src/lib/**.sol```
    * no appearances
* change ```import "./Pair.sol";``` to ```import { Pair } from "./Pair.sol"```, for all appearances

### N-02: Test coverage is not at 100%, for the ```src``` folder. ```src/lib/SafeERC20Namer.sol``` is not tested at all.

### N-03-NFBM: Function writing does not comply with Solidity Style Guide
Internal functions after private functions:
* https://github.com/code-423n4/2022-12-caviar/blob/main/src/lib/SafeERC20Namer.sol#L76
* Most functions in Pair.sol

### N-04: Internal functions could be private
* https://github.com/code-423n4/2022-12-caviar/blob/main/src/Pair.sol#L463
* https://github.com/code-423n4/2022-12-caviar/blob/main/src/Pair.sol#L477

### N-05: Comparing bytes32 merkle tree root with bytes23(0)
* https://github.com/code-423n4/2022-12-caviar/blob/main/src/Pair.sol#L465

### N-06: Pragma values should be locked, to prevent deployment with too-recent version which could be unstable
* https://github.com/igingu/code-423n4-2022-12-caviar/blob/main/src/Pair.sol#L2
* https://github.com/igingu/code-423n4-2022-12-caviar/blob/main/src/lib/SafeERC20Namer.sol
* https://github.com/igingu/code-423n4-2022-12-caviar/blob/main/src/LpToken.sol
* https://github.com/igingu/code-423n4-2022-12-caviar/blob/main/src/Caviar.sol

### N-07-NFBM: Should have more NATSPEC comments everywhere.

### N-08-NFBM: [Number literals should use underscores](https://code4rena.com/reports/2022-12-caviar/#n-07-use-underscores-for-number-literals).

### N-09-NFBM: [Solidity compiler optimizations are not recommended](https://code4rena.com/reports/2022-12-caviar/#n-04-solidity-compiler-optimizations-can-be-problematic)

### N-10-NFBM: [All important functions should emit events for off-chain tracking](https://code4rena.com/reports/2022-12-caviar/#n-12-missing-event-for-critical-parameters-init-and-change)

## Suggestions
### S-01-NFBM: [Should have scripts for emergency upgrade or stop functionality](https://code4rena.com/reports/2022-12-caviar/#s-01-project-upgrade-and-stop-scenario-should-be)

## Gas optimizations
### G-01: For loops increments do not use ```unchecked``` block for gas optimizations, and should use ```++i``` instead of ```i++```.
* https://github.com/code-423n4/2022-12-caviar/blob/main/src/lib/SafeERC20Namer.sol#L13
* https://github.com/code-423n4/2022-12-caviar/blob/main/src/lib/SafeERC20Namer.sol#L22
* https://github.com/code-423n4/2022-12-caviar/blob/main/src/lib/SafeERC20Namer.sol#L33
* https://github.com/code-423n4/2022-12-caviar/blob/main/src/lib/SafeERC20Namer.sol#L39
* https://github.com/code-423n4/2022-12-caviar/blob/main/src/Pair.sol#L468
* https://github.com/code-423n4/2022-12-caviar/blob/main/src/Pair.sol#L238


### G-02-NFBM: Using fixed ```bytes``` is cheaper than using ```string```
* https://github.com/code-423n4/2022-12-caviar/blob/main/src/Caviar.sol#L33
* https://github.com/code-423n4/2022-12-caviar/blob/main/src/Caviar.sol#L34
* https://github.com/code-423n4/2022-12-caviar/blob/main/src/Caviar.sol#L36

### G-03-NFBM: Using ```x = x + y``` spends less gas than ```x += y```, for state variables.
* https://github.com/code-423n4/2022-12-caviar/blob/main/src/Pair.sol#L453
* https://github.com/code-423n4/2022-12-caviar/blob/main/src/Pair.sol#L448

### G-04-NFBM: Internal functions only called once can be inlined to save gas
* https://github.com/code-423n4/2022-12-caviar/blob/main/src/lib/SafeERC20Namer.sol#L87
* https://github.com/code-423n4/2022-12-caviar/blob/main/src/Pair.sol#L227

### G-05: Functions that are public could be external to save gas
* https://github.com/igingu/code-423n4-2022-12-caviar/blob/main/src/LpToken.sol#L19
* https://github.com/igingu/code-423n4-2022-12-caviar/blob/main/src/LpToken.sol#L26
* https://github.com/igingu/code-423n4-2022-12-caviar/blob/main/src/Pair.sol#L275
* https://github.com/igingu/code-423n4-2022-12-caviar/blob/main/src/Pair.sol#L294
* https://github.com/igingu/code-423n4-2022-12-caviar/blob/main/src/Pair.sol#L310
* https://github.com/igingu/code-423n4-2022-12-caviar/blob/main/src/Pair.sol#L323
* https://github.com/code-423n4/2022-12-caviar/blob/main/src/Caviar.sol#L28
* https://github.com/code-423n4/2022-12-caviar/blob/main/src/Caviar.sol#L49

### G-06: Variables initialized with default values
* https://github.com/code-423n4/2022-12-caviar/blob/main/src/Pair.sol#L468
* https://github.com/code-423n4/2022-12-caviar/blob/main/src/Pair.sol#L238
* https://github.com/code-423n4/2022-12-caviar/blob/main/src/Pair.sol#L258

### G-07: Storage array's length not copied in memory but loaded every time
* https://github.com/code-423n4/2022-12-caviar/blob/main/src/Pair.sol#L468
* https://github.com/code-423n4/2022-12-caviar/blob/main/src/Pair.sol#L238
* https://github.com/code-423n4/2022-12-caviar/blob/main/src/Pair.sol#L258

### G-08: No need to store variable in memory just to use in require below
* https://github.com/code-423n4/2022-12-caviar/blob/main/src/Pair.sol#L469
* https://github.com/code-423n4/2022-12-caviar/blob/main/src/Pair.sol#L258

### G-09: Splitting require statements using multiple checks saves gas
* https://github.com/code-423n4/2022-12-caviar/blob/main/src/Pair.sol#L71

### G-10-NFBM: [Require/revert strings should be smaller than 32 bytes](https://code4rena.com/reports/2022-12-caviar/#g-03-requirerevert-strings-longer-than-32-bytes-cost-extra-gas)

### G-11-NFBM: [Optimize names to save gas](https://code4rena.com/reports/2022-12-caviar/#g-06-optimize-names-to-save-gas)

### G-12-NFBM: [Block.number and block.timestamp are added to an event by default, adding them explicitly just wastes gas](https://code4rena.com/reports/2022-12-caviar/#g-08-superfluous-event-fields)

### G-13-NFBM: [Payable constructor uses less gas than non-payable constructor](https://code4rena.com/reports/2022-12-caviar/#g-10-setting-the-constructor-to-payable)

### G-14-NFBM: [Functions guaranteed to not be called by normal users could be payable to save gas](https://code4rena.com/reports/2022-12-caviar/#g-11-functions-guaranteed-to-revert-when-called-by-normal-users-can-be-marked-payable)

## Suggestions