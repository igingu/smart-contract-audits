### Not an issue, closeTimestamp can only be set once, it's meant to block wrapping for good
Pair.wrap(uint256[],bytes32[][]) (src/Pair.sol#217-243) uses a dangerous strict equality:
        - require(bool,string)(closeTimestamp == 0,Wrap: closed) (src/Pair.sol#224)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#dangerous-strict-equalities

### Should be fine, all payable functions check that the base token should be ether. Ether can only be added if the base token is ETH, by adding/removing liquidity, and the LpTokens assure that all liquidity can be removed fully.
Contract locking ether found:
        Contract Pair (src/Pair.sol#16-482) has payable functions:
         - Pair.add(uint256,uint256,uint256) (src/Pair.sol#63-99)
         - Pair.buy(uint256,uint256) (src/Pair.sol#147-176)
         - Pair.nftAdd(uint256,uint256[],uint256,bytes32[][]) (src/Pair.sol#275-286)
         - Pair.nftBuy(uint256[],uint256) (src/Pair.sol#310-316)
        But does not have a function to withdraw the ether
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#contracts-that-lock-ether

Reentrancy in Pair.nftAdd(uint256,uint256[],uint256,bytes32[][]) (src/Pair.sol#275-286):
        External calls:
        - fractionalTokenAmount = wrap(tokenIds,proofs) (src/Pair.sol#282)
                - ERC721(nft).safeTransferFrom(msg.sender,address(this),tokenIds[i]) (src/Pair.sol#239)
        - lpTokenAmount = add(baseTokenAmount,fractionalTokenAmount,minLpTokenAmount) (src/Pair.sol#285)
                - lpToken.mint(msg.sender,lpTokenAmount) (src/Pair.sol#90)
        State variables written after the call(s):
        - lpTokenAmount = add(baseTokenAmount,fractionalTokenAmount,minLpTokenAmount) (src/Pair.sol#285)
                - balanceOf[from] -= amount (src/Pair.sol#448)
                - balanceOf[to] += amount (src/Pair.sol#453)
Reentrancy in Pair.nftSell(uint256[],uint256,bytes32[][]) (src/Pair.sol#323-332):
        External calls:
        - inputAmount = wrap(tokenIds,proofs) (src/Pair.sol#328)
                - ERC721(nft).safeTransferFrom(msg.sender,address(this),tokenIds[i]) (src/Pair.sol#239)
        State variables written after the call(s):
        - outputAmount = sell(inputAmount,minOutputAmount) (src/Pair.sol#331)
                - balanceOf[from] -= amount (src/Pair.sol#448)
                - balanceOf[to] += amount (src/Pair.sol#453)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#reentrancy-vulnerabilities-1

### Should be fine considering: baseToken can be address(0); nft shouldn't be address(0) considering Pair is always constructed by Caviar
Pair.constructor(address,address,bytes32,string,string,string)._nft (src/Pair.sol#40) lacks a zero-check on :
                - nft = _nft (src/Pair.sol#47)
Pair.constructor(address,address,bytes32,string,string,string)._baseToken (src/Pair.sol#41) lacks a zero-check on :
                - baseToken = _baseToken (src/Pair.sol#48)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#missing-zero-address-validation

### Wouldn't lead to a DoS attack, as array length is based on function parameters and not on state
Pair.wrap(uint256[],bytes32[][]) (src/Pair.sol#217-243) has external calls inside a loop: ERC721(nft).safeTransferFrom(msg.sender,address(this),tokenIds[i]) (src/Pair.sol#239)
Pair.unwrap(uint256[]) (src/Pair.sol#248-263) has external calls inside a loop: ERC721(nft).safeTransferFrom(address(this),msg.sender,tokenIds[i]) (src/Pair.sol#259)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation/#calls-inside-a-loop

### Here a miner could at most increase the block.timestamp, which would make withdraw happen a little later, but this wouldn't have any impact
Pair.wrap(uint256[],bytes32[][]) (src/Pair.sol#217-243) uses timestamp for comparisons
        Dangerous comparisons:
        - require(bool,string)(closeTimestamp == 0,Wrap: closed) (src/Pair.sol#224)
Pair.withdraw(uint256) (src/Pair.sol#359-373) uses timestamp for comparisons
        Dangerous comparisons:
        - require(bool,string)(closeTimestamp != 0,Withdraw not initiated) (src/Pair.sol#364)
        - require(bool,string)(block.timestamp >= closeTimestamp,Not withdrawable yet) (src/Pair.sol#367)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#block-timestamp

### Event should be emitted beforehand, but LpToken is created by Pair contract and is trusted
Reentrancy in Pair.add(uint256,uint256,uint256) (src/Pair.sol#63-99):
        External calls:
        - lpToken.mint(msg.sender,lpTokenAmount) (src/Pair.sol#90)
        Event emitted after the call(s):
        - Add(baseTokenAmount,fractionalTokenAmount,lpTokenAmount) (src/Pair.sol#98)

### Event should be emitted beforehand, but Caviar is trusted contract
Reentrancy in Pair.close() (src/Pair.sol#341-352):
        External calls:
        - caviar.destroy(nft,baseToken,merkleRoot) (src/Pair.sol#349)
        Event emitted after the call(s):
        - Close(closeTimestamp) (src/Pair.sol#351)

### Event should be emitted beforehand, but LpToken is created by Pair contract and is trusted
Reentrancy in Pair.remove(uint256,uint256,uint256) (src/Pair.sol#107-141):
        External calls:
        - lpToken.burn(msg.sender,lpTokenAmount) (src/Pair.sol#130)
        Event emitted after the call(s):
        - Remove(baseTokenOutputAmount,fractionalTokenOutputAmount,lpTokenAmount) (src/Pair.sol#140)

Reentrancy in Pair.nftAdd(uint256,uint256[],uint256,bytes32[][]) (src/Pair.sol#275-286):
        External calls:
        - fractionalTokenAmount = wrap(tokenIds,proofs) (src/Pair.sol#282)
                - ERC721(nft).safeTransferFrom(msg.sender,address(this),tokenIds[i]) (src/Pair.sol#239)
        - lpTokenAmount = add(baseTokenAmount,fractionalTokenAmount,minLpTokenAmount) (src/Pair.sol#285)
                - lpToken.mint(msg.sender,lpTokenAmount) (src/Pair.sol#90)
        Event emitted after the call(s):
        - Add(baseTokenAmount,fractionalTokenAmount,lpTokenAmount) (src/Pair.sol#98)
                - lpTokenAmount = add(baseTokenAmount,fractionalTokenAmount,minLpTokenAmount) (src/Pair.sol#285)
        - Transfer(from,to,amount) (src/Pair.sol#456)
                - lpTokenAmount = add(baseTokenAmount,fractionalTokenAmount,minLpTokenAmount) (src/Pair.sol#285)

Reentrancy in Pair.nftSell(uint256[],uint256,bytes32[][]) (src/Pair.sol#323-332):
        External calls:
        - inputAmount = wrap(tokenIds,proofs) (src/Pair.sol#328)
                - ERC721(nft).safeTransferFrom(msg.sender,address(this),tokenIds[i]) (src/Pair.sol#239)
        Event emitted after the call(s):
        - Sell(inputAmount,outputAmount) (src/Pair.sol#206)
                - outputAmount = sell(inputAmount,minOutputAmount) (src/Pair.sol#331)
        - Transfer(from,to,amount) (src/Pair.sol#456)
                - outputAmount = sell(inputAmount,minOutputAmount) (src/Pair.sol#331)

Reentrancy in Pair.withdraw(uint256) (src/Pair.sol#359-373):
        External calls:
        - ERC721(nft).safeTransferFrom(address(this),msg.sender,tokenId) (src/Pair.sol#370)
        Event emitted after the call(s):
        - Withdraw(tokenId) (src/Pair.sol#372)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#reentrancy-vulnerabilities-3

### Remediation: switch to solc-0.8.16
Pragma version^0.8.17 (src/Caviar.sol#2) necessitates a version too recent to be trusted. Consider deploying with 0.6.12/0.7.6/0.8.16
Pragma version^0.8.17 (src/LpToken.sol#2) necessitates a version too recent to be trusted. Consider deploying with 0.6.12/0.7.6/0.8.16
Pragma version^0.8.17 (src/Pair.sol#2) necessitates a version too recent to be trusted. Consider deploying with 0.6.12/0.7.6/0.8.16
solc-0.8.17 is not recommended for deployment
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#incorrect-versions-of-solidity
. analyzed (65 contracts with 81 detectors), 20 result(s) found