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
B
gasPrice는 단위 가스당 가격, gasLimit은 해당 트랜잭션이 사용할 수 있는 최대 가스량이다.
총 가스 비용은 gasUsed × gasPrice이며, 최대 지불 가능 금액은 gasLimit × gasPrice이다.
여기서 gasUsed는 gasLimit라는 한도 내에서 실제로 EVM이 트랜잭션을 실행하면서 소비한 가스량이다.
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
B
Alice의 현재 nonce가 5이므로, nonce=5인 TX-A가 먼저 처리되어야 nonce=6인 TX-B를 실행할 수 있다.
nonce는 계정별로 순차적인 카운터이기 때문에, 이전 nonce가 처리되지 않으면 다음 nonce 트랜잭션은 대기한다.
gasPrice는 동일 nonce 간 경쟁에서만 우선순위를 결정하며, nonce 순서를 건너뛸 수는 없다.

만약 gasPrice가 우선되면 nonce=6인 TX-B가 먼저 실행되어 nonce가 6으로 증가하게 되고
이후 nonce=5인 TX-A는 과거 nonce로 간주되어 무효가 된다. 즉 이상한 상태가 되는 것이다.
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
A
인증은 해당 트랜잭션이 실제 개인키 보유자에 의해 서명되었음을 보장하므로 타인이 위조할 수 없음을 의미한다.
무결성은 서명 후 메시지가 변경되지 않았음을 보장하고, 
부인 방지는 서명자가 나중에 내가 한 게 아니라고 부인할 수 없음을 의미한다.
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
C
Private Key → Public Key → Address 순으로 유도되며, 역방향은 불가능하다.
Public Key는 타원곡선에 기반해 계산되므로, Public Key로부터 Private Key를 역산하는 것은 수학적으로 불가능하다.
이는 각 단계가 단방향 함수이기 때문이다.
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

nonce는 EOA에 귀속되는 값으로 트랜잭션 카운터이다. 즉 동일 EOA에서 발생한 트랜잭션의 실행 순서를 표현하는 것이다. 동일한 논스를 가진 트랙잭션은 동시에 처리될 수 없고, 하나가 처리되면 나머지는 무효가 된다. 
트랜잭션 재사용 공격이란, 과거에 한 번 실행된 트랜잭션을 그대로 다시 전송하여 동일한 상태 전이를 반복 실행시키려는 공격이다.
nonce는 이미 사용된 값의 트랜잭션을 무효화 하기 때문에 트랜잭션 재사용 공격을 방지할 수 있다.
---

## 문제 6: [이론] Private Key 보안 (단답형)

2022년 Ronin Bridge 해킹에서 약 $625M이 탈취되었습니다.

**왜** Private Key 유출이 이렇게 치명적인가요? 은행 계좌 비밀번호 유출과 비교해서 설명하세요.

**답변:**
<!--
2-3 문장으로 설명하세요.
힌트: 은행은 이상 거래 취소가 가능합니다. 블록체인은?
-->

Private Key는 타원곡선 문제에 기반해 Public Key와 Address를 생성하는 값이며 서명을 할 때도 사용한다.
따라서 이것이 유출되면 해당 계정의 모든 자산을 트랜젝션과 서명을 통해 즉시 이동시킬 수 있다.
블록체인에서는 유효한 트랜젝션을 되돌릴 수 없기 때문에 은행처럼 이상 거래를 취소하거나 복구할 수 없다.
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
EIP-1559 이전에는 사용자가 gasPrice를 직접 설정하고 검증자는 가장 높은 가스비를 설정한 트랜잭션을 선택하는 방식이었다.
EIP-1559 이후에는 프로토콜이 baseFee를 블록 혼잡도에 따라 자동으로 조정하고, 사용자는 검증자에게 줄 팁인 priorityFee만 설정한다. 
또 다른 핵심적인 차이는 baseFee가 소각된다는 것으로 가스비가 전부 검증자에게 가지 않고 일부는 소각되므로 이더리움의 인플레이션을 억제하는 효과도 있다.
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
        // setUp() 실행 -> test_DepositUpdatesBalance() 실행
        // Arrange: user 관점에서 실행
        vm.prank(user);  // TODO: user로 전환하는 코드

        // Act: 1 ETH 입금
        storage_.deposit{value: 1 ether}();  // TODO: 1 ether를 입금하는 코드

        // Assert: 잔액 확인
        assertEq(storage_.getBalance(user), 11 ether);  // TODO: 예상 잔액
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
vm.prank(user) : 다음 호출에서 msg.sender을 user로 설정한 것이다.
{value: 1 ether} : 해당 함수 호출과 함께 1 이더를 전송하는 것이다.
마지막으로 처음에 10 이더를 설정하고 1 이더를 입금했으니 11 이더 잔액을 예상했다.
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
잔액이 차감하고자 하는 양보다 많은지 검사하는 것이 빠져있다

**2) 왜 이것이 문제인가:**
<!--
이 상태로 withdraw(100 ether)를 호출하면 어떻게 될까요?
힌트: 잔액이 1 ether밖에 없는 경우를 생각해 보세요.
-->
솔리디티 0.7 이하 버전이면 언더플로우가 생겨 무한 인출이 가능해지는데, 
0.8 이상이면 별 문제는 없지만 코드 가독성이 떨어진다.

**3) 올바른 수정 방법:**
```solidity
// GOOD CODE - 수정된 withdraw 함수를 작성하세요
contract Wallet {
    mapping(address => uint256) public balances;

    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint256 amount) public {

        require(balances[msg.sender] >= amount, "Insufficient balance");

        // 잔액 차감
        balances[msg.sender] -= amount;
        
        // ETH 전송
        payable(msg.sender).transfer(amount);
    }
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
require(balances[msg.sender] >= amount, "Insufficient balance"); 조건에 걸린다.

**질문 2:** 이 테스트를 "출금 실패를 테스트하는 정상 테스트"로 바꾸려면 어떻게 수정해야 하나요?

**답변:**
```solidity
// 힌트: vm.expectRevert를 사용하세요
// 수정된 테스트 코드를 작성하세요
function test_WithdrawFails() public {
    // 이 다음 호출은 revert될 것으로 기대
    // 즉, 잔액이 부족하면 출금이 실패해야 함
    // 테스트에서는 잔액이 부족하면 출금이 실패하는 것이 정답이라고 명시
    vm.expectRevert("Insufficient balance");

    storage_.withdraw(1 ether);
}

```

---

## 자기 평가

모든 문제를 풀었다면, 아래 체크리스트로 자기 평가를 해보세요:

- [V] 트랜잭션 필드(nonce, gasPrice, gasLimit 등)의 역할을 이해했다
- [V] 디지털 서명의 세 가지 보장(인증, 무결성, 부인 방지)을 설명할 수 있다
- [V] Private Key 보안의 중요성을 이해했다
- [V] Foundry 테스트 기본 패턴(vm.prank, vm.deal, assertEq)을 사용할 수 있다
- [V] require 조건의 필요성을 이해했다

---

## 참고 자료

- 이론: `eth-materials/week-02/theory/slides.md`
- 코드: `eth-homework/week-02/dev/src/SimpleStorage.sol`
- 테스트: `eth-homework/week-02/dev/test/SimpleStorage.t.sol`
- 용어: `eth-materials/resources/glossary.md`
