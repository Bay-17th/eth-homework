# Week 2 퀴즈: Transaction/서명 + Foundry

**제출 방법:**
1. 이 파일을 복사하여 `quiz-02-solution.md`로 저장
2. 각 문제에 답변 작성 (왜 그런지 설명 포함)
3. Pull Request 생성 (`quiz_submission` 템플릿 사용)

**평가 기준:**
- 정답 여부보다 **개념 이해도**를 중점 평가합니다
- "왜"에 대한 설명이 충분한지 확인합니다
- 코드 문제는 문법보다 논리적 정확성을 평가합니다

---

## 문제 1: [이론] 트랜잭션 필드 (객관식)

다음 중 이더리움 트랜잭션에서 `gasPrice`와 `gasLimit`의 관계를 올바르게 설명한 것은?

**보기:**
A) gasPrice는 최대 사용량, gasLimit은 단위당 가격이다
B) gasPrice는 단위당 가격, gasLimit은 최대 사용량이다
C) 둘 다 같은 의미이며 호환되어 사용된다
D) gasLimit이 높을수록 트랜잭션이 빨리 처리된다

**답변:**
B
트랜잭션 fee = 실제 gas 사용량 * gasPrice
만약 트랜잭션 fee가 gaslimit보다 높으면 에러가 발생한다.


---

## 문제 2: [이론] nonce의 역할 (객관식)

다음 상황에서 어떤 일이 발생하나요?

```
Alice가 다음 두 트랜잭션을 동시에 네트워크에 브로드캐스트합니다:
- TX-A: nonce=5, Bob에게 1 ETH (gasPrice: 50 Gwei)
- TX-B: nonce=6, Charlie에게 2 ETH (gasPrice: 100 Gwei)

Alice의 현재 nonce: 5
```

**보기:**
A) TX-B가 gasPrice가 높아서 먼저 처리되고, TX-A는 나중에 처리된다
B) TX-A가 먼저 처리되어야 TX-B가 처리될 수 있다. gasPrice와 무관하게 순서대로 처리된다
C) 두 트랜잭션이 동시에 처리된다
D) 둘 다 실패하고 Alice의 계정이 잠긴다

**답변:**
B
gasPrice가 TX-B에서 더 높지만, nonce의 규칙이 더 우선이다. 즉 트랜잭션 순서 번호인 nonce가 순서의 무결성 및 이중 지불 방지 역할을 하므로 TX-A가 먼저 처리되어야 TX-B가 처리된다.


---

## 문제 3: [이론] 디지털 서명 (객관식)

디지털 서명(ECDSA)이 보장하는 세 가지 속성 중, "누군가 내 트랜잭션을 위조할 수 없다"를 보장하는 것은?

**보기:**
A) 인증 (Authentication)
B) 무결성 (Integrity)
C) 부인 방지 (Non-repudiation)
D) 암호화 (Encryption)

**답변:**
B
인증 : 송신자의 신원을 확인한다.
부인 방지 : 사후에 참여자들의 행위의 대해 사실 부인을 방지한다.

---

## 문제 4: [이론] 키 유도 (객관식)

다음 중 키 유도 과정에서 올바른 방향을 설명한 것은?

**보기:**
A) Public Key -> Private Key -> Address 순으로 유도된다
B) Address -> Public Key -> Private Key 순으로 역추적 가능하다
C) Private Key -> Public Key -> Address 순으로 유도되며, 역방향은 불가능하다
D) 세 값은 독립적으로 생성되며 서로 연관이 없다

**답변:**
C
타원곡선 문제의 난이도: 공개키에서 개인키를 알아내려면 이산 로그 문제를 풀어야 하지만 극도로 높은 난이도로 사실상 불가능에 가깝다.
해시 함수의 일방성: 주소를 만들 때 사용하는 해시 함수는 결과값(주소)을 보고 입력값(공개키)을 유추하는 것이 아예 불가능하도록 설계된 수학적 장치다.
물론 주소와 달리 개인키가 유출되면 모든 권한을 탈취 당한다.

---

## 문제 5: [이론] nonce의 필요성 (단답형)

이더리움에서 **왜** nonce가 필요한가요?

만약 nonce가 없다면 어떤 공격이 가능해질까요? 구체적인 예시와 함께 설명하세요.

**답변:**
nonce가 필요한 가장 결정적인 이유는 동일한 트랜잭션이 중복해서 실행되는 것을 방지하기 위해서다.
만약 Nonce가 없다면, 공격자가 네트워크에 이미 공개된 사용자의 유효한 서명을 그대로 복사하여 반복적으로 전송하는 재전송 공격이 가능해진다.
즉, 공격자는 해당 공격으로 지갑 주소의 잔액을 전부 전송하는등의 행위가 가능해진다. 

---

## 문제 6: [이론] Private Key 보안 (단답형)

2022년 Ronin Bridge 해킹에서 약 $625M이 탈취되었습니다.

**왜** Private Key 유출이 이렇게 치명적인가요? 은행 계좌 비밀번호 유출과 비교해서 설명하세요.

**답변:**
블록체인은 중앙 통제 기관이 부재한 특징을 가진다. 따라서 개인키가 유출되는 즉시 공격자가 해당 계정의 유일하고 절대적인 소유권을 갖게 되며, 한 번 실행된 탈취 거래는 그 누구도 되돌리거나 강제로 막을 수 없기 때문에 치명적이다.
은행 계좌 비밀번호 유출 시 은행 내부 시스템이 감지 후 차단을 할 수 있지만, 블록체인은 그것이 불가능하다.


---

## 문제 7: [이론] EIP-1559 이해 (단답형)

EIP-1559 이전과 이후의 가스 수수료 메커니즘의 가장 큰 차이점은 무엇인가요?

**힌트:** `baseFee`와 `priorityFee`의 역할을 설명하면서 답변하세요.

**답변:**
EIP-1559 이전에는 사용자가 입찰하듯 gasPrice를 직접 설정하는 경매방식이었으나, 이후에는 네트워크 수요에 따라 자동으로 결정되는 baseFee와 검증자에게 주는 보너스인 priorityFee로 이원화되었다.

baseFee : 블록에 포함되기 위해 지불해야 하는 최소한의 비용이다. 이 수수료는 채굴자에게 가지 않고 소각되어 이더리움의 공급량을 줄이는 경제적 효과를 낸다.
priorityFee : 내가 전송한 트랜잭션을 남들보다 먼저 처리해달라고 검증자에게 주는 보너스다.

---

## 문제 8: [코드] SimpleStorage 테스트 (빈칸 채우기)

다음 테스트 코드의 빈칸을 채워서 deposit 기능을 테스트하세요:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import "forge-std/Test.sol";
import "../src/SimpleStorage.sol";

contract SimpleStorageTest is Test {
    SimpleStorage public storage_;
    address public user = address(0x1);

    function setUp() public {
        storage_ = new SimpleStorage();
        // user에게 10 ETH 부여
        vm.deal(user, 10 ether);
    }

    function test_DepositUpdatesBalance() public {
        // Arrange: user 관점에서 실행
        vm.prank(user);  // TODO: user로 전환하는 코드

        // Act: 1 ETH 입금
        storage_.deposit{value: 1 ether}();  // TODO: 1 ether를 입금하는 코드

        // low-level call
        // (bool success,) = storage_.call{value: 1 ehter}("");
        // require(success, "error");

        // Assert: 잔액 확인
        assertEq(storage_.getBalance(user), ______);  // TODO: 예상 잔액
    }
}
```

**답변:**
```solidity
// Arrange: user 관점에서 실행
vm.prank(user);  // TODO: user로 전환하는 코드

// Act: 1 ETH 입금
storage_.deposit{value: 1 ether}();  // TODO: 1 ether를 입금하는 코드

// low-level call
// (bool success,) = storage_.call{value: 1 ehter}("");
// require(success, "error");
```

**왜 이렇게 작성했나요:**
vm.prank로 external call의 msg.sender를 다음 주소로 설정하는 코드다. 즉, user를 msg.sender로 설정한다는 뜻이고, value는 전송하는 이더의 양으로 1 ether로 표현하기도 하지만 단순히 숫자만 입력하기도 한다. 숫자만 입력했을때는 wei단위로 전송된다.

---

## 문제 9: [코드] require 조건 (취약점 찾기)

다음 코드에서 잠재적 문제점을 찾으세요:

```solidity
// BAD CODE - 문제점 찾기
contract Wallet {
    mapping(address => uint256) public balances;

    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint256 amount) public {
        // 잔액 검증 로직 추가
        require(balances[msg.sender] >= amount, "Insufficient balance");
        
        // 잔액 차감
        balances[msg.sender] -= amount;

        // ETH 전송
        payable(msg.sender).transfer(amount);
    }
}
```

**1) 발견한 문제점:**
잔액을 검증하는 로직이 없다. 언더플로우 문제를 야기할 수 있다.

**2) 왜 이것이 문제인가:**
언더플로우 에러가 발생하여 트랜잭션이 즉시 취소된다. solidity 0.8.0미만 버전이면 type(uint256).max - 99의 잔액으로 계산되는 문제가 발생 할 수 있다.


**3) 올바른 수정 방법:**
```solidity
function withdraw(uint256 amount) public {
    // 잔액 검증 로직 추가
    require(balances[msg.sender] >= amount, "Insufficient balance");
        
    // 잔액 차감
    balances[msg.sender] -= amount;

    // ETH 전송
    payable(msg.sender).transfer(amount);
}
```

---

## 문제 10: [코드] 테스트 실패 이유 (코드 분석)

다음 테스트가 실패하는 이유를 분석하세요:

```solidity
contract SimpleStorageTest is Test {
    SimpleStorage public storage_;

    function setUp() public {
        storage_ = new SimpleStorage();
    }

    function test_WithdrawFails() public {

        // 입금 없이 바로 출금 시도
        storage_.withdraw(1 ether);
    }
}
```

**질문 1:** 이 테스트가 실패하는 이유는 무엇인가요?

**답변:**
<!--
왜 실패할까요? 어떤 require 조건에 걸릴까요?
-->
존재하지 않은 잔액을 출금 시 부족으로 인해 에러가 발생한다. 
```solidity
require(balances[msg.sender] >= amount, "Insufficient balance");
```


**질문 2:** 이 테스트를 "출금 실패를 테스트하는 정상 테스트"로 바꾸려면 어떻게 수정해야 하나요?

**답변:**
```solidity
function test_WithdrawFails() public {
    // 에러 감지 추가
    vm.expectRevert("Insufficient balance");
    // 입금 없이 바로 출금 시도
    storage_.withdraw(1 ether);
}
```

---

## 자기 평가

모든 문제를 풀었다면, 아래 체크리스트로 자기 평가를 해보세요:

- [ ] 트랜잭션 필드(nonce, gasPrice, gasLimit 등)의 역할을 이해했다
- [ ] 디지털 서명의 세 가지 보장(인증, 무결성, 부인 방지)을 설명할 수 있다
- [ ] Private Key 보안의 중요성을 이해했다
- [ ] Foundry 테스트 기본 패턴(vm.prank, vm.deal, assertEq)을 사용할 수 있다
- [ ] require 조건의 필요성을 이해했다

---

## 참고 자료

- 이론: `eth-materials/week-02/theory/slides.md`
- 코드: `eth-homework/week-02/dev/src/SimpleStorage.sol`
- 테스트: `eth-homework/week-02/dev/test/SimpleStorage.t.sol`
- 용어: `eth-materials/resources/glossary.md`
