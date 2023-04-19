# High Risk Issues

## H-01: **onlyMinter** modifier doesn't use require, anyone can call functions guarded by this modifier.

### Proof of concept:

https://github.com/rabbitholegg/quest-protocol/blob/8c4c1f71221570b14a0479c216583342bd652d8d/contracts/RabbitHoleReceipt.sol#L58

In Remix, deploy the below and try calling function ```x```. It will go through and return true:
```
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

contract A {
    address owner;

    constructor() {
        owner = address(0);
    }

    modifier onlyOwner {
        owner == msg.sender;
        _;
    }

    function x() external view onlyOwner returns (bool) {
        return true;
    }
}
```

### Remediation: Add require to modifier
```
modifier onlyMinter() {
    require(msg.sender == minterAddress, "Should be minter.");
    _;
}
```
