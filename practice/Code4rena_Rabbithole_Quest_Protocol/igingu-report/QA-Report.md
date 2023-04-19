# Low Risk and Non-Critical Issues

## L-01: Node engine specification incompatible with node packages

https://github.com/rabbitholegg/quest-protocol/blob/8c4c1f71221570b14a0479c216583342bd652d8d/package.json#L33

### Proof of concept:
1. Change node version to version 10: ```nvm install 10.0.0```
2. ```cd quest-protocol```
3. ```yarn```
4. ```error hardhat@2.12.2: The engine "node" is incompatible with this module. Expected version "^14.0.0 || ^16.0.0 || ^18.0.0". Got "12.22.9"``` when running ```yarn```. ```package.json``` specifies ```"node": ">=10"```

### Remediation: 
1. Change ```package.json``` node version to ```"node": ">=14"```, instead of ```"node": ">=10"```.

## L-02: Unreachable code
Flagged by ```yarn compile```.
https://github.com/rabbitholegg/quest-protocol/blob/8c4c1f71221570b14a0479c216583342bd652d8d/contracts/Quest.sol#L114
https://github.com/rabbitholegg/quest-protocol/blob/8c4c1f71221570b14a0479c216583342bd652d8d/contracts/Quest.sol#L115
https://github.com/rabbitholegg/quest-protocol/blob/8c4c1f71221570b14a0479c216583342bd652d8d/contracts/Quest.sol#L117

Does not have impact as Quest.sol contract is not supposed to be used directly, but inherited.

## L-03: Unused function parameters

Flagged by ```yarn compile```. Should remove parameter name and only leave type, as well as remove NatSpec comment where needed.
https://github.com/rabbitholegg/quest-protocol/blob/8c4c1f71221570b14a0479c216583342bd652d8d/contracts/RabbitHoleReceipt.sol#L110 should be changed to ```string memory```

https://github.com/rabbitholegg/quest-protocol/blob/8c4c1f71221570b14a0479c216583342bd652d8d/contracts/Quest.sol#L122 should be changed to 
``` function _calculateRewards(uint256) internal virtual returns (uint256) {```

https://github.com/rabbitholegg/quest-protocol/blob/8c4c1f71221570b14a0479c216583342bd652d8d/contracts/Quest.sol#L122

https://github.com/rabbitholegg/quest-protocol/blob/8c4c1f71221570b14a0479c216583342bd652d8d/contracts/Quest.sol#L129

https://github.com/rabbitholegg/quest-protocol/blob/8c4c1f71221570b14a0479c216583342bd652d8d/contracts/Quest.sol#L150

## L-04: Test suite should be 100% ready, by the time the security audit starts

There is a test that is skipped:
https://github.com/rabbitholegg/quest-protocol/blob/main/test/RabbitHoleReceipt.spec.ts#L76

## L-05: Solidity-coverage should only run on source code, not tests.

Currently, solidity-coverage runs on all **.sol** files, including tests. Tests should be excluded, for more ease of reading the report.

### Remediation:
Create a [.solcover.js](https://github.com/sc-forks/solidity-coverage/blob/master/HARDHAT_README.md#configuration) configuration file, with configuration excluding the **test** directory.

## L-06: Insufficient coverage
The test coverage of the **contracts** folder is 81.62%. Testing all functions is best practice in terms of security criteria. Due to the relatively small size of the project, test coverage is expected to be 100%.

```
------------------------|----------|----------|----------|----------|----------------|
File                    |  % Stmts | % Branch |  % Funcs |  % Lines |Uncovered Lines |
------------------------|----------|----------|----------|----------|----------------|
 contracts/             |    81.62 |    59.23 |    74.03 |    81.46 |                |
  Erc1155Quest.sol      |      100 |       75 |      100 |    85.71 |             35 |
  Erc20Quest.sol        |      100 |    66.67 |      100 |    94.12 |             60 |
  Quest.sol             |    90.91 |    81.58 |    73.33 |    90.48 |123,129,140,145 |
  QuestFactory.sol      |    94.29 |     72.5 |    85.71 |    94.23 |    146,173,200 |
  RabbitHoleReceipt.sol |    54.29 |    26.92 |    46.67 |    61.54 |... 184,185,193 |
  RabbitHoleTickets.sol |    58.33 |    18.75 |       50 |    59.09 |... 112,113,121 |
  ReceiptRenderer.sol   |      100 |      100 |      100 |      100 |                |
  TicketRenderer.sol    |      100 |      100 |      100 |      100 |                |
 contracts/interfaces/  |      100 |      100 |      100 |      100 |                |
  IQuest.sol            |      100 |      100 |      100 |      100 |                |
  IQuestFactory.sol     |      100 |      100 |      100 |      100 |                |
  ```

## L-06: Setup step doesn't fully work

We are encouraged to run gas test, with:
```
yarn test:gas-stories
```

This contains a failing javascript/typescript execution.

```
 1 passing (7s)
  1 failing

  1) Collections
       Mint Receipt and Claim Rewards:
     Error: VM Exception while processing transaction: reverted with custom error 'ClaimWindowNotStarted()'
      at Erc20Quest.onlyQuestActive (contracts/Quest.sol:90)
      at Erc20Quest.claim (contracts/Quest.sol:96)
      at processTicksAndRejections (node:internal/process/task_queues:95:5)
      at runNextTicks (node:internal/process/task_queues:64:3)
      at listOnTimeout (node:internal/timers:538:9)
      at processTimers (node:internal/timers:512:7)
      at HardhatNode._mineBlockWithPendingTxs (node_modules/hardhat/src/internal/hardhat-network/provider/node.ts:1802:23)
      at HardhatNode.mineBlock (node_modules/hardhat/src/internal/hardhat-network/provider/node.ts:491:16)
      at EthModule._sendTransactionAndReturnHash (node_modules/hardhat/src/internal/hardhat-network/provider/modules/eth.ts:1522:18)



error Command failed with exit code 1.
info Visit https://yarnpkg.com/en/docs/cli/run for documentation about this command.
```

## L-07: Codebase doesn't respect [SolidityLang coding conventions](https://docs.soliditylang.org/en/v0.8.17/style-guide.html).

Running **solhint** with the recommended configuration shows 139 problems (112 errors and 27 warnings)

.solhint.json:
```
{
    "extends": "solhint:recommended",
    "plugins": [],
    "rules": {
      "compiler-version": ["error", "^0.8.17"],
      "func-visibility": ["warn", { "ignoreConstructors": true }],
      "no-empty-blocks": "off",
      "not-rely-on-time": "off"
    }
}
```

Errors:
```
contracts/Erc1155Quest.sol
   2:1    error  Compiler version ^0.8.15 does not satisfy the ^0.8.17 semver requirement  compiler-version
   4:24   error  Use double quotes for string literals                                     quotes
   5:29   error  Use double quotes for string literals                                     quotes
   6:21   error  Use double quotes for string literals                                     quotes
  42:112  error  Use double quotes for string literals                                     quotes
  61:13   error  Use double quotes for string literals                                     quotes

contracts/Erc20Quest.sol
  2:1   error  Compiler version ^0.8.15 does not satisfy the ^0.8.17 semver requirement  compiler-version
  4:33  error  Use double quotes for string literals                                     quotes
  5:21  error  Use double quotes for string literals                                     quotes
  6:28  error  Use double quotes for string literals                                     quotes

contracts/Quest.sol
  2:1   error  Compiler version ^0.8.15 does not satisfy the ^0.8.17 semver requirement  compiler-version
  4:23  error  Use double quotes for string literals                                     quotes
  5:22  error  Use double quotes for string literals                                     quotes
  6:33  error  Use double quotes for string literals                                     quotes
  7:21  error  Use double quotes for string literals                                     quotes

contracts/QuestFactory.sol
    2:1   error    Compiler version ^0.8.15 does not satisfy the ^0.8.17 semver requirement                                             
                                   compiler-version
    4:1   warning  global import of path @openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol is not allowed. Specify names to import individually            no-global-import
    4:8   error    Use double quotes for string literals                                                                                
                                   quotes
    5:26  error    Use double quotes for string literals                                                                                
                                   quotes
    6:29  error    Use double quotes for string literals                                                                                
                                   quotes
    7:28  error    Use double quotes for string literals                                                                                
                                   quotes
    8:33  error    Use double quotes for string literals                                                                                
                                   quotes
    9:34  error    Use double quotes for string literals                                                                                
                                   quotes
   10:1   warning  global import of path @openzeppelin/contracts-upgradeable/utils/cryptography/ECDSAUpgradeable.sol is not allowed. Specify names to import individually  no-global-import
   10:8   error    Use double quotes for string literals                                                                                
                                   quotes
   11:1   warning  global import of path @openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol is not allowed. Specify names to import individually      no-global-import
   11:8   error    Use double quotes for string literals                                                                                
                                   quotes
   17:59  error    Use double quotes for string literals                                                                                
                                   quotes
   72:86  error    Use double quotes for string literals                                                                                
                                   quotes
  105:86  error    Use double quotes for string literals                                                                                
                                   quotes
  211:60  error    Use double quotes for string literals                                                                                
                                   quotes

contracts/RabbitHoleReceipt.sol
    2:1   error    Compiler version ^0.8.15 does not satisfy the ^0.8.17 semver requirement                                             
                                                   compiler-version
    4:1   warning  global import of path @openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol is not allowed. Specify names to import individually                       no-global-import
    4:8   error    Use double quotes for string literals                                                                                
                                                   quotes
    5:1   warning  global import of path @openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721URIStorageUpgradeable.sol is not allowed. Specify names to import individually  no-global-import
    5:8   error    Use double quotes for string literals                                                                                
                                                   quotes
    6:1   warning  global import of path @openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721EnumerableUpgradeable.sol is not allowed. Specify names to import individually  no-global-import
    6:8   error    Use double quotes for string literals                                                                                
                                                   quotes
    7:1   warning  global import of path @openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol is not allowed. Specify names to import individually                            no-global-import
    7:8   error    Use double quotes for string literals                                                                                
                                                   quotes
    8:1   warning  global import of path @openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol is not allowed. Specify names to import individually                            no-global-import
    8:8   error    Use double quotes for string literals                                                                                
                                                   quotes
    9:1   warning  global import of path @openzeppelin/contracts-upgradeable/interfaces/IERC2981Upgradeable.sol is not allowed. Specify names to import individually                       no-global-import
    9:8   error    Use double quotes for string literals                                                                                
                                                   quotes
   10:1   warning  global import of path @openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol is not allowed. Specify names to import individually                            no-global-import
   10:8   error    Use double quotes for string literals                                                                                
                                                   quotes
   11:1   warning  global import of path ./ReceiptRenderer.sol is not allowed. Specify names to import individually                     
                                                   no-global-import
   11:8   error    Use double quotes for string literals                                                                                
                                                   quotes
   12:1   warning  global import of path ./interfaces/IQuestFactory.sol is not allowed. Specify names to import individually            
                                                   no-global-import
   12:8   error    Use double quotes for string literals                                                                                
                                                   quotes
   13:1   warning  global import of path ./interfaces/IQuest.sol is not allowed. Specify names to import individually                   
                                                   no-global-import
   13:8   error    Use double quotes for string literals                                                                                
                                                   quotes
   35:5   warning  Variable name must be in mixedCase                                                                                   
                                                   var-name-mixedcase
   36:5   warning  Variable name must be in mixedCase                                                                                   
                                                   var-name-mixedcase
   49:23  error    Use double quotes for string literals                                                                                
                                                   quotes
   49:44  error    Use double quotes for string literals                                                                                
                                                   quotes
  161:9   warning  Error message for require is too long                                                                                
                                                   reason-string
  161:36  error    Use double quotes for string literals                                                                                
                                                   quotes
  162:68  error    Use double quotes for string literals                                                                                
                                                   quotes
  182:36  error    Use double quotes for string literals                                                                                
                                                   quotes

contracts/RabbitHoleTickets.sol
   2:1   error    Compiler version ^0.8.15 does not satisfy the ^0.8.17 semver requirement                                              
                                                  compiler-version
   4:1   warning  global import of path @openzeppelin/contracts-upgradeable/token/ERC1155/ERC1155Upgradeable.sol is not allowed. Specify names to import individually                     no-global-import
   4:8   error    Use double quotes for string literals                                                                                 
                                                  quotes
   5:1   warning  global import of path @openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol is not allowed. Specify names to import individually                            no-global-import
   5:8   error    Use double quotes for string literals                                                                                 
                                                  quotes
   6:1   warning  global import of path @openzeppelin/contracts-upgradeable/token/ERC1155/extensions/ERC1155BurnableUpgradeable.sol is not allowed. Specify names to import individually  no-global-import
   6:8   error    Use double quotes for string literals                                                                                 
                                                  quotes
   7:1   warning  global import of path @openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol is not allowed. Specify names to import individually                            no-global-import
   7:8   error    Use double quotes for string literals                                                                                 
                                                  quotes
   8:1   warning  global import of path @openzeppelin/contracts-upgradeable/interfaces/IERC2981Upgradeable.sol is not allowed. Specify names to import individually                       no-global-import
   8:8   error    Use double quotes for string literals                                                                                 
                                                  quotes
   9:1   warning  global import of path ./TicketRenderer.sol is not allowed. Specify names to import individually                       
                                                  no-global-import
   9:8   error    Use double quotes for string literals                                                                                 
                                                  quotes
  25:5   warning  Variable name must be in mixedCase                                                                                    
                                                  var-name-mixedcase
  38:24  error    Use double quotes for string literals                                                                                 
                                                  quotes

contracts/ReceiptRenderer.sol
    2:1   error    Compiler version ^0.8.15 does not satisfy the ^0.8.17 semver requirement                                             
 compiler-version
    4:1   warning  global import of path @openzeppelin/contracts/utils/Base64.sol is not allowed. Specify names to import individually  
 no-global-import
    4:8   error    Use double quotes for string literals                                                                                
 quotes
    5:1   warning  global import of path @openzeppelin/contracts/utils/Strings.sol is not allowed. Specify names to import individually 
 no-global-import
    5:8   error    Use double quotes for string literals                                                                                
 quotes
   37:40  error    Use double quotes for string literals                                                                                
 quotes
   49:13  error    Use double quotes for string literals                                                                                
 quotes
   50:31  error    Use double quotes for string literals                                                                                
 quotes
   51:13  error    Use double quotes for string literals                                                                                
 quotes
   52:31  error    Use double quotes for string literals                                                                                
 quotes
   53:13  error    Use double quotes for string literals                                                                                
 quotes
   54:31  error    Use double quotes for string literals                                                                                
 quotes
   55:13  error    Use double quotes for string literals                                                                                
 quotes
   56:31  error    Use double quotes for string literals                                                                                
 quotes
   56:53  error    Use double quotes for string literals                                                                                
 quotes
   56:62  error    Use double quotes for string literals                                                                                
 quotes
   57:13  error    Use double quotes for string literals                                                                                
 quotes
   58:31  error    Use double quotes for string literals                                                                                
 quotes
   59:13  error    Use double quotes for string literals                                                                                
 quotes
   60:31  error    Use double quotes for string literals                                                                                
 quotes
   61:13  error    Use double quotes for string literals                                                                                
 quotes
   64:13  error    Use double quotes for string literals                                                                                
 quotes
   65:13  error    Use double quotes for string literals                                                                                
 quotes
   67:13  error    Use double quotes for string literals                                                                                
 quotes
   68:13  error    Use double quotes for string literals                                                                                
 quotes
   69:13  error    Use double quotes for string literals                                                                                
 quotes
   71:13  error    Use double quotes for string literals                                                                                
 quotes
   72:13  error    Use double quotes for string literals                                                                                
 quotes
   74:13  error    Use double quotes for string literals                                                                                
 quotes
   84:13  error    Use double quotes for string literals                                                                                
 quotes
   85:13  error    Use double quotes for string literals                                                                                
 quotes
   87:13  error    Use double quotes for string literals                                                                                
 quotes
   88:13  error    Use double quotes for string literals                                                                                
 quotes
   90:13  error    Use double quotes for string literals                                                                                
 quotes
   91:13  error    Use double quotes for string literals                                                                                
 quotes
  102:13  error    Use double quotes for string literals                                                                                
 quotes
  103:13  error    Use double quotes for string literals                                                                                
 quotes
  104:13  error    Use double quotes for string literals                                                                                
 quotes
  105:13  error    Use double quotes for string literals                                                                                
 quotes
  107:13  error    Use double quotes for string literals                                                                                
 quotes
  108:13  error    Use double quotes for string literals                                                                                
 quotes
  110:13  error    Use double quotes for string literals                                                                                
 quotes
  111:13  error    Use double quotes for string literals                                                                                
 quotes
  113:40  error    Use double quotes for string literals                                                                                
 quotes

contracts/TicketRenderer.sol
   2:1   error    Compiler version ^0.8.15 does not satisfy the ^0.8.17 semver requirement                                              
compiler-version
   4:1   warning  global import of path @openzeppelin/contracts/utils/Base64.sol is not allowed. Specify names to import individually   no-global-import
   4:8   error    Use double quotes for string literals                                                                                 
quotes
   5:1   warning  global import of path @openzeppelin/contracts/utils/Strings.sol is not allowed. Specify names to import individually  no-global-import
   5:8   error    Use double quotes for string literals                                                                                 
quotes
  20:13  error    Use double quotes for string literals                                                                                 
quotes
  21:13  error    Use double quotes for string literals                                                                                 
quotes
  23:13  error    Use double quotes for string literals                                                                                 
quotes
  24:13  error    Use double quotes for string literals                                                                                 
quotes
  25:13  error    Use double quotes for string literals                                                                                 
quotes
  27:13  error    Use double quotes for string literals                                                                                 
quotes
  28:13  error    Use double quotes for string literals                                                                                 
quotes
  30:40  error    Use double quotes for string literals                                                                                 
quotes
  38:13  error    Use double quotes for string literals                                                                                 
quotes
  39:13  error    Use double quotes for string literals                                                                                 
quotes
  40:13  error    Use double quotes for string literals                                                                                 
quotes
  41:13  error    Use double quotes for string literals                                                                                 
quotes
  43:13  error    Use double quotes for string literals                                                                                 
quotes
  44:13  error    Use double quotes for string literals                                                                                 
quotes
  46:40  error    Use double quotes for string literals                                                                                 
quotes

✖ 139 problems (112 errors, 27 warnings)
```

## L-08: Codebase has multiple unused packages.

Running ```npx [depcheck](https://www.npmjs.com/package/depcheck)``` shows multiple packages that are included but not used:
```
npx depcheck
Unused dependencies
* @nomicfoundation/hardhat-network-helpers
Unused devDependencies
* @openzeppelin/contracts
* @openzeppelin/contracts-upgradeable
* axios
* commander
* ethereumjs-util
* prettier
* prettier-plugin-solidity
* solc
Missing dependencies
* chalk: ./test-gas-stories/gas-stories.ts
```

Out of the above, these actually seem unused:
* @nomicfoundation/hardhat-network-helpers
* axios
* commander
* ethereumjs-util

## L-09: Solidity compiler optimizations can be problematic

Description:
Protocol has enabled optional compiler optimizations in Solidity.
There have been several optimization bugs with security implications. Moreover, optimizations are actively being developed. Solidity compiler optimizations are disabled by default, and it is unclear how many contracts in the wild actually use them.

Therefore, it is unclear how well they are being tested and exercised.
High-severity security issues due to optimization bugs have occurred in the past. A high-severity bug in the emscripten-generated solc-js compiler used by Truffle and Remix persisted until late 2018. The fix for this bug was not reported in the Solidity CHANGELOG.

Another high-severity optimization bug resulting in incorrect bit shift results was patched in Solidity 0.5.6. More recently, another bug due to the incorrect caching of keccak256 was reported.
A compiler audit of Solidity from November 2018 concluded that the optional optimizations may not be safe.
It is likely that there are latent bugs related to optimization and that new bugs will be introduced due to future optimizations.

Exploit Scenario:
A latent or future bug in Solidity compiler optimizations—or in the Emscripten transpilation to solc-js—causes a security vulnerability in the contracts.

Recommendation:
Short term, measure the gas savings from optimizations and carefully weigh them against the possibility of an optimization-related bug. Long term, monitor the development and adoption of Solidity compiler optimizations to assess their maturity.

hardhat.config.ts:
```
  solidity: {
    compilers: [
      {
        version: '0.8.15',
        settings: {
          optimizer: {
            enabled: true,
            runs: 5000,
          },
        },
      },
    ],
  },
```

## L-10: Codebase that comes into audit shouldn't have leftover TODOs.

```
// contract/interfaces/IQuest.sol

// TODO clean this whole thing up
// Allows anyone to claim a token if they exist in a merkle root.
interface IQuest {
```

## L-11: Misleading function namings.

[generateTokenURI](https://github.com/rabbitholegg/quest-protocol/blob/8c4c1f71221570b14a0479c216583342bd652d8d/contracts/TicketRenderer.sol#L16) actually generates a token's metadata according to OpenSea metadata standards. A URI is a Unique Resource Identifier, which in our case would be the web URL where the tokenId's metadata would be found. NatSpec comments should also be changed accordingly.

[generateDataURI](https://github.com/rabbitholegg/quest-protocol/blob/8c4c1f71221570b14a0479c216583342bd652d8d/contracts/ReceiptRenderer.sol#L40)

[generateTokenURI](https://github.com/rabbitholegg/quest-protocol/blob/8c4c1f71221570b14a0479c216583342bd652d8d/contracts/ReceiptRenderer.sol#L21)

## L-12: Where concatenation is needed, use of bytes.concat() instead of abi.encodePacked()

Rather than using abi.encodePacked for appending bytes, since version 0.8.4, bytes.concat() is enabled.

Since version 0.8.4 for appending bytes, bytes.concat() can be used instead of abi.encodePacked(,)

https://github.com/rabbitholegg/quest-protocol/blob/8c4c1f71221570b14a0479c216583342bd652d8d/contracts/TicketRenderer.sol#L30

https://github.com/rabbitholegg/quest-protocol/blob/8c4c1f71221570b14a0479c216583342bd652d8d/contracts/TicketRenderer.sol#L46

https://github.com/rabbitholegg/quest-protocol/blob/8c4c1f71221570b14a0479c216583342bd652d8d/contracts/ReceiptRenderer.sol#L37

https://github.com/rabbitholegg/quest-protocol/blob/8c4c1f71221570b14a0479c216583342bd652d8d/contracts/ReceiptRenderer.sol#L48

https://github.com/rabbitholegg/quest-protocol/blob/8c4c1f71221570b14a0479c216583342bd652d8d/contracts/ReceiptRenderer.sol#L63

https://github.com/rabbitholegg/quest-protocol/blob/8c4c1f71221570b14a0479c216583342bd652d8d/contracts/ReceiptRenderer.sol#L83

https://github.com/rabbitholegg/quest-protocol/blob/8c4c1f71221570b14a0479c216583342bd652d8d/contracts/ReceiptRenderer.sol#L113

## L-13: Functions that do not even read from storage can be pure

https://github.com/rabbitholegg/quest-protocol/blob/8c4c1f71221570b14a0479c216583342bd652d8d/contracts/ReceiptRenderer.sol#L21

https://github.com/rabbitholegg/quest-protocol/blob/8c4c1f71221570b14a0479c216583342bd652d8d/contracts/ReceiptRenderer.sol#L40

## L-14: Missing events for critical actions like RabbitHoleReceipt: setTicketRenderer, setRoyaltyRecipient

## L-15: For loops can cause DoS situations because of block out-of-gas situations
https://github.com/rabbitholegg/quest-protocol/blob/main/contracts/RabbitHoleReceipt.sol#L119
https://github.com/rabbitholegg/quest-protocol/blob/main/contracts/RabbitHoleReceipt.sol#L130