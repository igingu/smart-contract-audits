# [M-02] Malicious onlyOwner and changing of Oracle can drain Lottery

If RNSourceController's owner is stolen and Chainlink's Oracle is not answering to requests anymore, a hacker can use
the owner private key to swap Chainlink's Oracle provider with a hacked implementation, which provides whatever number
the hacker would want.

## Proof of concept:

```solidity
contract OracleByHacker {
    uint256 private _requestId;
    function requestRandomnessFromUnderlyingSource() internal override returns (uint256 requestId) {
        requestId = _requestId++;
        emit HackerShouldFulfillRequest(requestId);
    }

    function fulfillRandomWords(uint256 requestId, uint256[] memory randomWords) public override ONLY_HACKER {
        fulfill(requestId, randomWords[0]);
    }
}
```

The above contract would make it so that requests can always be fulfilled (manually by hacker or using an off-chain
event listener), which would make it impossible for `Lottery` contract to swap oracles back with a non-malicious one.

Now, the hacker in control could buy tickets, trigger the draw execution each week and supply the exact number they
picked, winning the jackpot every time, and effectively draining the Lottery of all funds.

Given all assets are at indirect risk, with a hypothetical attack path with stated assumptions but external
requirements, I put the above as a Mid Vulnerability, thinking the developers should take this into consideration and
have a remediation plan, given the lottery aims to be a fully decentralized, uninterrupted and non-error prone lottery.
