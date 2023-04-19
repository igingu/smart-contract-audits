# Gas Optimizations

## G-01: Public functions to external or private if only used in containing contract

The following functions could be set external to save gas and improve code quality.
External call cost is less expensive than of public functions.

https://github.com/rabbitholegg/quest-protocol/blob/8c4c1f71221570b14a0479c216583342bd652d8d/contracts/RabbitHoleReceipt.sol#L48

All functions in RabbitHoleReceipt.sol

The following functions could be set to private to save gas and improve code quality.
Private call cost is less expensive than of public functions.

https://github.com/rabbitholegg/quest-protocol/blob/8c4c1f71221570b14a0479c216583342bd652d8d/contracts/ReceiptRenderer.sol#L21

https://github.com/rabbitholegg/quest-protocol/blob/8c4c1f71221570b14a0479c216583342bd652d8d/contracts/ReceiptRenderer.sol#L40

https://github.com/rabbitholegg/quest-protocol/blob/8c4c1f71221570b14a0479c216583342bd652d8d/contracts/ReceiptRenderer.sol#L82

https://github.com/rabbitholegg/quest-protocol/blob/8c4c1f71221570b14a0479c216583342bd652d8d/contracts/ReceiptRenderer.sol#L100


## G-02: Function parameters that do not mutate can be calldata instead of memory

https://github.com/rabbitholegg/quest-protocol/blob/8c4c1f71221570b14a0479c216583342bd652d8d/contracts/ReceiptRenderer.sol#L21

https://github.com/rabbitholegg/quest-protocol/blob/8c4c1f71221570b14a0479c216583342bd652d8d/contracts/ReceiptRenderer.sol#L40

https://github.com/rabbitholegg/quest-protocol/blob/8c4c1f71221570b14a0479c216583342bd652d8d/contracts/ReceiptRenderer.sol#L82

https://github.com/rabbitholegg/quest-protocol/blob/8c4c1f71221570b14a0479c216583342bd652d8d/contracts/ReceiptRenderer.sol#L100

https://github.com/rabbitholegg/quest-protocol/blob/main/contracts/RabbitHoleReceipt.sol#L99

https://github.com/rabbitholegg/quest-protocol/blob/8c4c1f71221570b14a0479c216583342bd652d8d/contracts/RabbitHoleReceipt.sol#L110

## G-03: Variables shouldn't be initialized with default values
https://github.com/rabbitholegg/quest-protocol/blob/main/contracts/RabbitHoleReceipt.sol#L116
https://github.com/rabbitholegg/quest-protocol/blob/main/contracts/RabbitHoleReceipt.sol#L119
https://github.com/rabbitholegg/quest-protocol/blob/main/contracts/RabbitHoleReceipt.sol#L128
https://github.com/rabbitholegg/quest-protocol/blob/main/contracts/RabbitHoleReceipt.sol#L130


## G-04: For loops increments do not use ```unchecked``` block for gas optimizations, and should use ```++i``` instead of ```i++```.
https://github.com/rabbitholegg/quest-protocol/blob/main/contracts/RabbitHoleReceipt.sol#L119
https://github.com/rabbitholegg/quest-protocol/blob/main/contracts/RabbitHoleReceipt.sol#L123
https://github.com/rabbitholegg/quest-protocol/blob/main/contracts/RabbitHoleReceipt.sol#L130
https://github.com/rabbitholegg/quest-protocol/blob/main/contracts/RabbitHoleReceipt.sol#L133

## G-05: [keccak256(bytes(questId_))](https://github.com/rabbitholegg/quest-protocol/blob/8c4c1f71221570b14a0479c216583342bd652d8d/contracts/RabbitHoleReceipt.sol#L119) can be computed only once

## G-06: Unused functions could be removed

https://github.com/rabbitholegg/quest-protocol/blob/8c4c1f71221570b14a0479c216583342bd652d8d/contracts/RabbitHoleReceipt.sol#L139