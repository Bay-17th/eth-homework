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
B, Total Cost(ETH) = gasUsed * gasPrice
gasPrice = baseFee + priorityFee

gasPrice는 gas당 이더리움 가격이고, gasLimit은 트랜잭션이 최대 얼마까지 가스를 쓸 수 있는지 상한이다.
총가스비는 가스 사용량 * 가스당 몇 이더인지
gasPrice는 baseFee 와 priorityFee의 합인데
baseFee는 네트워크가 자동으로 정하는 기본 수수료이다. 이 수수료는 소각된다.
priorityFee는 validator에게 주는 인센티브이다.(이걸 많이 주면 더 빨리 트렌젝션이 처리됨)



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
B, nonce가 현재 계정상태보다 크면 아직 실행할 수 없는 상태라고 판단된다.
nonce가 현재 계정상태보다 작으면 잘못된 트랜잭션이라고 판단된다.
이 단계를 통과해야 실행가능한 상태가 된다.
같은 nonce를 가진 트랜잭션이 여러 개일 때는 가스비가 높은 것이 우선적으로 포함될 확률이 높다.


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
인증: 이 서명이 그 사람의 개인키로 만들어졌다.
무결성: 서명 이후 메시지가 바뀌지 않았다.
부인방지: 개인키는 본인만 알아야하기에 나중에 자신이 안했다 할 수 없다.
암호화: ECDSA는 서명 알고리즘이다. 암호화가 아니다.


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
Public Key = privateKey * 타원곡선의 기준점 이다.
이 연산은 계산은 쉽지만 역산은 어렵다.
그 후 주소는 퍼블릭키를 해쉬한 후 마지막 20바이트를 가져다 쓴다.


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
nonce가 없으면 전에 발생시켰던 트랜잭션을 또 발생시키면
서명이 옳은 서명이기 때문에 그것을 구분해낼 방법이 없다.
그러면 이미 실행한 트랜잭션을 복사해서 가지고 있는 누군가가 여러번 같은 트랜잭션을 발생시킬 수 있다.

---

## 문제 6: [이론] Private Key 보안 (단답형)

2022년 Ronin Bridge 해킹에서 약 $625M이 탈취되었습니다.

**왜** Private Key 유출이 이렇게 치명적인가요? 은행 계좌 비밀번호 유출과 비교해서 설명하세요.

**답변:**
<!--
2-3 문장으로 설명하세요.
힌트: 은행은 이상 거래 취소가 가능합니다. 블록체인은?
-->
은행은 중앙화된 기관이 관리하므로, 비밀번호가 유출되더라도 잘못된 거래를 취소하거나 계좌를 동결할 수 있다.
하지만, 블록체인은 어떤 주소가 누군지 알 수도 없고 중앙화된 서버도 없다.
즉,상대방의 주소만 알 수 있을 뿐 상대가 누군지도 알 수 없고 블록체인은 한번 블록에 담기면 그것을 되돌릴 수 없다.
따라서, Private Key 유출은 온전히 본인이 책임져야한다. 


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
EIP-1559 이전에는 gasPrice가 완전히 경매형식이었고 사용자가 직접 제시하는 형식이었다.
그래서 높은 gasPrice를 제시한 트랜잭션부터 처리가 되었다.
이로 인해, 상황에 따라 가스비의 편차가 매우심했다.

EIP-1559 이후에는 gasPrice가 baseFee가 도입되어 gasPrice=baseFee+priorityFee로 바뀌었다.
baseFee는 소각되는 비용이고 priorityFee는 검증자에게 제공되는 비용이다.
이후 사용자는 priorityFee만 추가적으로 설정하면 되며, 이로인해 수수료 예측이 쉬워졌다.


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
        _______________________;  // TODO: user로 전환하는 코드

        // Act: 1 ETH 입금
        _______________________;  // TODO: 1 ether를 입금하는 코드

        // Assert: 잔액 확인
        assertEq(storage_.getBalance(user), ______);  // TODO: 예상 잔액
    }
}
```

**답변:**
```solidity
// 빈칸을 채운 완성 코드를 작성하세요
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

        // Assert: 잔액 확인
        assertEq(storage_.getBalance(user), 1 ether);  // TODO: 예상 잔액
    }
}
```

**왜 이렇게 작성했나요:**
<!--
각 빈칸에 대해 왜 그 코드를 선택했는지 설명하세요.
특히 vm.prank와 {value: ...} 구문의 의미를 설명해 주세요.
-->
vm.prank(user)은 Foundry에서 msg.sender을 user로 바꿔준다. 테스트 하기 위한 코드이다.

storage_.deposit{value:1 ether}(); payable함수에 ether을 함께 보내는 구문이다. {value:1 ether} 는 1 이더를 보내겟다는 소리다.

assertEq는 user의 Balance 잔액이 1 ehter인지 확인하는 코드이다.




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
withdraw를 할때 잔액이 amount 보다 크거나 같은지 확인하지 않았다.

**2) 왜 이것이 문제인가:**
<!--
이 상태로 withdraw(100 ether)를 호출하면 어떻게 될까요?
힌트: 잔액이 1 ether밖에 없는 경우를 생각해 보세요.
-->
현재 balances는 address => uint256으로 mapping되어있다.
uint는 부호를 신경쓰지 않는 자료형이다.
현재는 잔액이 부족해도 withdraw를 할 수 있으므로 
그럼 음의 값이 나오게 되고 uint에서는 언더플로우가 발생해 매우 큰 값이 나오게 된다.

하지만... solidity 0.8 이상에서는 언더플로우가 나면 자동으로 revert 된다고 합니다!
그럼에도 명시적으로 조건을 표시해주지 않으면 코드의 의도가 불분명해집니다


**3) 올바른 수정 방법:**
```solidity
// GOOD CODE - 수정된 withdraw 함수를 작성하세요
contract Wallet {
    mapping(address => uint256) public balances;

    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint256 amount) public {
        require(balances[msg.sender]>=amount,"Insufficient balance");
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
잔액을 입금한 적이 없다.
따라서 withdraw 함수에 require(balances[msg.sender]>=amount,"Insufficient balance"); 에서 걸려버린다.
따라서 앞에 revert되는 것을 예상하는 테스트코드를 작성해주어야한다.

**질문 2:** 이 테스트를 "출금 실패를 테스트하는 정상 테스트"로 바꾸려면 어떻게 수정해야 하나요?

**답변:**
```solidity
// 힌트: vm.expectRevert를 사용하세요
// 수정된 테스트 코드를 작성하세요
contract SimpleStorageTest is Test {
    SimpleStorage public storage_;

    function setUp() public {
        storage_ = new SimpleStorage();
    }

    function test_WithdrawFails() public {
        // 작성된 테스트 코드 Revert될것을 예상한다.
        vm.expectRevert("Insufficient balance");
        // 입금 없이 바로 출금 시도
        storage_.withdraw(1 ether);
    }
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
