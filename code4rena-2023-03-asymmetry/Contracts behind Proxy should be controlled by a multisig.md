# M - Contracts behind Proxy should be controlled by a multisig

Assymetry's system has 4 contracts behind proxies: SafEth, Reth, SfrxEth, WstEth. Each proxy has an owner, which can change the underlying implementation. SafEth contract can mint and burn SafEth shares, while the other 3 derivatives hold balances of rEth, sfrxEth, wstEth.

## Impact
Having any of the 4 private keys controlling the proxies stolen would lead to changing an implementation to a malicious one, which would result in losses of all funds in the compromised Proxy:
Losing SafEth's Proxy private key would result in stealing all funds, (since hacker's malicious contract could burn all other users' shares, mint some to themselves and then unstake them), while losing any of the derivatives' private keys would result in stealing all the staked ether in the compromised contract.

Not only can private key be compromised, but malicious owner can also decide to rugpull the project and steal all the funds, and we can't really stake a lot of ETH based on trust in just one person.

Since this is a DeFi project for staking Eth, the value locked is expected to be very high. This is a very real exploit that [has happened before at PAID Network](https://www.certik.com/resources/blog/paid-network-post-mortem), and was also [used recently by an insider from Kokomo Finance, to rugpull 4 million USD](https://twitter.com/BeosinAlert/status/1640194668389634048?s=20).

[Malt Finance C4 Audit, same issue rated as M](https://code4rena.com/reports/2021-11-malt/#m-01-timelock_role-has-absolute-power-to-withdraw-all-fund-may-raise-red-flags-for-investors)

## Recommended Mitigation Steps
Instead of controlling the Proxies with only one user address, the proxies should be controlled by a MultiSig contract, which requires 2/3 or 3/5 signatures. [Gnosis MultiSigWallet](https://github.com/gnosis/MultiSigWallet) or [Gnosis Safe](https://help.safe.global/en/articles/3876461-creating-a-safe-on-a-web-browser) could be used, which would greatly improve security, with no additional significant gas costs or complexity.

Using a MultiSig for upgrades is [also recommended by OpenZeppelin](https://docs.openzeppelin.com/defender/guide-upgrades), and can be done through their Defender Admin platform.