# [M-01] Namespace protocol: fusing cost uses hardcoded 1e18 number of units instead of ```note.decimals()```, but NOTE contract can change

Currently, Canto's $NOTE contract is an ERC20 token with 18 decimals, and the cost of fusing is calculated using a [hardcoded 1e18 number of units](https://github.com/code-423n4/2023-03-canto-identity/blob/main/canto-namespace-protocol/src/Namespace.sol#L113). 

However, Namespace contract [has functionality to change $NOTE address to a new one](https://github.com/code-423n4/2023-03-canto-identity/blob/main/canto-namespace-protocol/src/Namespace.sol#L196) (in case it changes on the network I assume), which introduces the possibility of the new $NOTE having a different number of decimals.

## Impact:
When fusing, users will either pay much less or much more, by order of 10 ^ ```number_of_wrong_decimals```.

Given Canto is a new blockchain and subject to potential major changes, I would say possibility of NOTE token changing to another number of decimals is definitly not something unthinkable.

## Remediation:
Use ```note.decimals()```. If gas cost is an issue, cache it every time address changes.

```
uint256 fusingCosts = 2**(13 - numCharacters) * unitsForOneNoteToken;

function changeNoteAddress(address _newNoteAddress) external onlyOwner {
    address currentNoteAddress = address(note);
    note = ERC20(_newNoteAddress);
    unitsforOneNoteToken = 10 ** (note.decimals());
    emit NoteAddressUpdate(currentNoteAddress, _newNoteAddress);
}
```