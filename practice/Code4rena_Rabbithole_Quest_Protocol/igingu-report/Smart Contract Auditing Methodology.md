# Smart Contract Audit Methodology

## Project setup checklist

- [X] Does compilation pass without warnings and errors?
- [X] Does linting pass without warnings and errors? Use linting with Solidity conventions rules, as they are described on [SolidityLang](https://docs.soliditylang.org/en/v0.8.17/style-guide.html)?
- [X] Are there unused node packages?
- [X] [What are the used framework's settings, and does it use compiler optimizations?](https://code4rena.com/reports/2022-12-caviar#n-04-solidity-compiler-optimizations-can-be-problematic)
- [X] Is code coverage only running on source code, and not on tests?
- [X] Are there any tests skipped?
- [X] [Is coverage 100%?](https://code4rena.com/reports/2022-12-caviar#n-01-insufficient-coverage)
- [X] Does project have any gas reports, and does functionality use a worrying amount of gas?

## Tools checklist
- [ ] Run slither. Analyze results, and are there any actual vulnerabilities?

## Code review checklist
- [ ] [Are NatSpec comments there and complete?](https://code4rena.com/reports/2022-12-caviar#n-02-natspec-comments-should-be-increased-in-contracts)
- [ ] Gas optimizations
- [ ] [Do all important functions emit events?((https://code4rena.com/reports/2022-12-caviar/#n-12-missing-event-for-critical-parameters-init-and-change))
- [ ] [Are there any loss of precision errors, due to rounding?](https://code4rena.com/reports/2022-12-caviar/#l-03-loss-of-precision-due-to-rounding)

## Code quality checklist
- [ ] [Do source files comply with the Solidity coding conventions?](https://code4rena.com/reports/2022-12-caviar#n-03-function-writing-that-does-not-comply-with-the-solidity-style-guide)
- [ ] Are there internal functions that could be private? Are there public functions that can be external? (also gas optimization here, external costs less)
- [ ] [Are pragma values locked?](https://code4rena.com/reports/2022-12-caviar#n-06-lock-pragmas-to-specific-compiler-version)
- [ ] [Are pragma versions too recent?](https://code4rena.com/reports/2022-12-caviar#n-09-pragma-version0817--version-too-recent-to-be-trusted)
- [ ] [Do number literals use underscores?]((https://code4rena.com/reports/2022-12-caviar/#n-07-use-underscores-for-number-literals))
- [X] [Use bytes.concat instead of abi.encodePacked](https://code4rena.com/reports/2022-12-caviar#n-08-use-of-bytesconcat-instead-of-abiencodepacked)
- [ ] Can view functions be pure? Can normal functions be view/pure?


## Access control checklist
- [ ] [Is safeTransferOwnership used instead of transferOwnership?](https://code4rena.com/reports/2022-12-caviar/#l-02-use-safetransferownership-instead-of-transferownership-function)

## NFT checklist
- [ ] [Can smart contract hold NFTs, and if so, can smart contract withdraw tokens in case of airdrop?](https://code4rena.com/reports/2022-12-caviar#l-05-should-an-airdrop-token-arrive-on-the-pairsol-contract-it-will-be-stuck)

## DEFI checklist
- [ ] [Can funds be mistakenly split towards all LP providers?](https://code4rena.com/reports/2022-12-caviar/#h-02-liquidity-providers-may-lose-funds-when-adding-liquidity)
- [ ] Have you thought of slippage issues?
- [ ] [Can minting of shares be broken by first depositor?](https://code4rena.com/reports/2022-12-caviar#h-03-first-depositor-can-break-minting-of-shares)
- [ ] [Do swap/liquidity adding/trade transactions have a deadline?](https://code4rena.com/reports/2022-12-caviar/#m-01-missing-deadline-checks-allow-pending-transactions-to-be-maliciously-executed)
- [ ] [x*y=k AMM. Can pair price be manipulated by direct transfers?](https://code4rena.com/reports/2022-12-caviar/#m-05-pair-price-may-be-manipulated-by-direct-transfers)




## Gas optimizations checklist
- [ ] [Unchecked blocks should be used whenever possible](https://code4rena.com/reports/2022-12-caviar/#g-02-ii-should-be-uncheckediuncheckedi-when-it-is-not-possible-for-them-to-overflow-as-is-the-case-when-used-in-for--and-while-loops)
- [ ] [Use fixed bytes instead of string, whenever possible](https://code4rena.com/reports/2022-12-caviar/#g-07-using-fixed-bytes-is-cheaper-than-using-string)
- [ ] [Internal functions only called once can be inlined](https://code4rena.com/reports/2022-12-caviar/#g-09-internal-functions-only-called-once-can-be-inlined-to-save-gas)
- [ ] [Can public functions be external?](https://code4rena.com/reports/2022-12-caviar/#g-05-public-functions-to-external)
- [ ] Are any variables initialized with default values? ```for(uint i = 0;...)``` changed to ```for(uint i;...)```
- [ ] Storage array's length should be copied in memory and not read each time
- [ ] [Splitting require() statements saves gas](https://code4rena.com/reports/2022-12-caviar#g-04-splitting-require-statements-that-use--saves-gas)
- [ ] [Require/revert strings should be smaller than 32 bytes](https://code4rena.com/reports/2022-12-caviar/#g-03-requirerevert-strings-longer-than-32-bytes-cost-extra-gas)
- [ ] [Block.number and block.timestamp are added to an event by default, adding them explicitly just wastes gas](https://code4rena.com/reports/2022-12-caviar/#g-08-superfluous-event-fields)
- [ ] [Payable constructor uses less gas than non-payable constructor](https://code4rena.com/reports/2022-12-caviar/#g-10-setting-the-constructor-to-payable)
- [ ] [Functions guaranteed to not be called by normal users could be payable to save gas](https://code4rena.com/reports/2022-12-caviar/#g-11-functions-guaranteed-to-revert-when-called-by-normal-users-can-be-marked-payable)

## Potential suggestions
- [ ] [Are there scripts for emergency pausing or stopping contracts, if functionality exists and is needed?](https://code4rena.com/reports/2022-12-caviar/#s-01-project-upgrade-and-stop-scenario-should-be)