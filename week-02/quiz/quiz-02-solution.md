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
<!--
정답과 함께, "총 가스 비용"을 계산하는 공식을 설명하세요.
예: 어떤 값들을 곱하면 실제 비용이 나오나요?
-->
B) / 정답대로 gasPrice는 단위당 가격이고 gasLimit은 최대 사용량이다
실제 사용한 가스 양은 gasUsed이다. 그래서 (총 가스 비용) = (gasUsed) * (gasPrice)

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
<!--
정답과 함께, 왜 nonce 순서가 gasPrice보다 우선하는지 설명하세요.
-->

B) / Nonce가 우선이다, gasPrice Tx-B가 더 높더라도 nonce가 뒷순이기 때문에 Tx-A가 우선이다
같은 계정에서 안에서 nonce 순서대로만 트랜잭션을 확정할 수 있다.

---

## 문제 3: [이론] 디지털 서명 (객관식)

디지털 서명(ECDSA)이 보장하는 세 가지 속성 중, "누군가 내 트랜잭션을 위조할 수 없다"를 보장하는 것은?

**보기:**
A) 인증 (Authentication)
B) 무결성 (Integrity)
C) 부인 방지 (Non-repudiation)
D) 암호화 (Encryption)

**답변:**
<!--
정답과 함께, 나머지 두 속성(인증, 무결성, 부인 방지 중)이
각각 무엇을 보장하는지 간단히 설명하세요.
-->

A) 
Authentication : 서명 검증 시 해당 트랜잭션은 이 Public Key의 Private Key로만 만들 수 있다를 보장해서, 다른 사람이 위조 서명을 만들 수 없도록 한다. 
Integrity : 서명 데이터가 한 비트라도 바뀌면 서명이 더 이상 유효하지 않으므로, 전송 중 조작/변경을 탐지할 수 있다
Non-repudiation : 나중에 내가 해당 트랜잭션을 안 보냈다라고 주장해도, 유효한 서명이 남아 있는 한 본인이 보냈음을 부인할 수 없게 만드는 성질이다

---

## 문제 4: [이론] 키 유도 (객관식)

다음 중 키 유도 과정에서 올바른 방향을 설명한 것은?

**보기:**
A) Public Key -> Private Key -> Address 순으로 유도된다
B) Address -> Public Key -> Private Key 순으로 역추적 가능하다
C) Private Key -> Public Key -> Address 순으로 유도되며, 역방향은 불가능하다
D) 세 값은 독립적으로 생성되며 서로 연관이 없다

**답변:**
<!--
정답과 함께, "왜 역방향이 불가능한지" 간단히 설명하세요.
힌트: 수학적 난이도 관점에서 생각해 보세요.
-->

C) / Private Key 는 랜덤으로 256bit로 주어진다. 이를 ECDSA secp256k1 곡선 연산에 의해 Public Key를 생성한다(512bits, 65bytes). 이 Public Key를 Keccak256 Hash를하고 뒤 20bytes를 통해 Address를 생성해내서
총 큰 연산 2회(ECDSA, Keccak256 Hash) 모두 역연산 불가능이기 때문에 불가능하다.

그래서 Address만 보고 Private Key를 찾아내려고 해도 불가능하다

---

## 문제 5: [이론] nonce의 필요성 (단답형)

이더리움에서 **왜** nonce가 필요한가요?

만약 nonce가 없다면 어떤 공격이 가능해질까요? 구체적인 예시와 함께 설명하세요.

**답변:**
<!--
2-3 문장으로 설명하세요.
힌트: "재사용 공격"이란 무엇일까요?
누군가가 당신의 서명된 트랜잭션을 복사해서 여러 번 보내면?
-->

Nonce는 같은 계정에서 동일한 트랜잭션이 Replay Attack되는 것을 방지하기 위해 필요하다. 
Nonce가 없다면 공격자는 예를들어 Alice의 서명된 "Bob에게 1ETH 송금" 트랜잭션을 여러 번 테느워크에 재전송 할 수 있고, Alice의 계좌에서 1ETH씩 무한 인출되는 재앙이 발생할 수 있다.
각 트랜잭션마다 nonce가 증가함으로써 이미 처리된 트랜잭션은 무효화돼 일회성 Execution만 보장한다.

---

## 문제 6: [이론] Private Key 보안 (단답형)

2022년 Ronin Bridge 해킹에서 약 $625M이 탈취되었습니다.

**왜** Private Key 유출이 이렇게 치명적인가요? 은행 계좌 비밀번호 유출과 비교해서 설명하세요.

**답변:**
<!--
2-3 문장으로 설명하세요.
힌트: 은행은 이상 거래 취소가 가능합니다. 블록체인은?
-->

은행 계좌 비밀번호 유출 시 은행이 이상거래를 감지하고 즉시 계좌 동결/취소가 가능하지만, 
블록체인에서는 Private Key로 서명된 트랜잭션이 블록에 들어가서 확정되면 immutable하므로 복구 불가능하다.

Private Key 유출은 블록체인에서 계좌 전체 자산이 즉시 탈취될 수 있는 심각한 보안 사고다.

---

## 문제 7: [이론] EIP-1559 이해 (단답형)

EIP-1559 이전과 이후의 가스 수수료 메커니즘의 가장 큰 차이점은 무엇인가요?

**힌트:** `baseFee`와 `priorityFee`의 역할을 설명하면서 답변하세요.

**답변:**
<!--
2-3 문장으로 설명하세요.
이전: 가스 가격을 사용자가 직접 설정
이후: 어떤 부분이 달라졌나요?
-->
컨셉적으로는 경매식 고정 가격 -> 자동조정 baseFee + 팁 구조로 전환됐다

이전 총 수수료 = gasUsed * gasPrice
gasPrice는 사용자가 직접 입찰하고, 문제는 예측 불가하며 과납부가 빈번했다

그래서 현재는 gasUsed * (baseFee * priorityFee)로 계산된다
baseFee는 네트워크가 현재 블록 혼잡도에 따라 자동 조정한다
priorityFee는 사용자 설정 팁이다, Validator 우선순위용이다
baseFee는 burn하고 ETH 디플레이션 효과가 난다

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
        storage_.deposit{value:1ether}();  // TODO: 1 ether를 입금하는 코드

        // Assert: 잔액 확인
        assertEq(storage_.getBalance(user), 1ether);  // TODO: 예상 잔액
    }
}
```

**답변:**
```solidity
// 빈칸을 채운 완성 코드를 작성하세요
```

**왜 이렇게 작성했나요:**
<!--
각 빈칸에 대해 왜 그 코드를 선택했는지 설명하세요.
특히 vm.prank와 {value: ...} 구문의 의미를 설명해 주세요.
-->

vm.prank() : 현재 msg.sender를 user로 위장한다
deposit{value:1ether}() : payable 함수에 ETH 전송
assertEq(..., 1ether) : 입금한 만큼 잔액 증가 확인

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
        // 잔액 차감
        balances[msg.sender] -= amount;

        // ETH 전송
        payable(msg.sender).transfer(amount);
    }
}
```

**1) 발견한 문제점:**
<!--
어떤 검증이 빠져 있나요?
-->
잔액보다 더 많은 출금을 하려고 할 때 문제가 발생한다


**2) 왜 이것이 문제인가:**
<!--
이 상태로 withdraw(100 ether)를 호출하면 어떻게 될까요?
힌트: 잔액이 1 ether밖에 없는 경우를 생각해 보세요.
-->
잔액이 음수값이되는 언더플로우가 발생한다.
솔리디티 0.8 이전에는 이 문제가 해결이 안돼서 잔액이 양수로 높게잡히는 취약점이 있었다.


**3) 올바른 수정 방법:**
```solidity
// GOOD CODE - 수정된 withdraw 함수를 작성하세요

function  withdraw(uint256 amount) public {
    require(amount <= balances[msg.sender], "Insufficient Balance");
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
잔액이 0인데, 출금을 시도한다 그래서 revert된다


**질문 2:** 이 테스트를 "출금 실패를 테스트하는 정상 테스트"로 바꾸려면 어떻게 수정해야 하나요?

**답변:**
```solidity
// 힌트: vm.expectRevert를 사용하세요
// 수정된 테스트 코드를 작성하세요
    function test_WithdrawFails() public {
        vm.expectRevert("Insufficient Balance");

        storage_.withdraw(1 ether);
    }
```


---

## 자기 평가

모든 문제를 풀었다면, 아래 체크리스트로 자기 평가를 해보세요:

- [x] 트랜잭션 필드(nonce, gasPrice, gasLimit 등)의 역할을 이해했다
- [x] 디지털 서명의 세 가지 보장(인증, 무결성, 부인 방지)을 설명할 수 있다
- [x] Private Key 보안의 중요성을 이해했다
- [x] Foundry 테스트 기본 패턴(vm.prank, vm.deal, assertEq)을 사용할 수 있다
- [x] require 조건의 필요성을 이해했다

---

## 참고 자료

- 이론: `eth-materials/week-02/theory/slides.md`
- 코드: `eth-homework/week-02/dev/src/SimpleStorage.sol`
- 테스트: `eth-homework/week-02/dev/test/SimpleStorage.t.sol`
- 용어: `eth-materials/resources/glossary.md`

