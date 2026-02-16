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

Total Transaction Fee = Gas Units Used * (Base Fee + Priority Fee)
총 사용량에 대한 값은 유닛당 가스의 소비량 * (기본료 + 우선시하기 위한 수수료) 의 값이라고 볼 수 있다.
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

nonce는 거래에서 순서를 보장하기 위한 속성이다. 따라서 gasPrice보다 nonce의 속성에 따라 거래의 순서가 정해지는 것이 당연하다고 볼 수 있다.
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
A, B, C 
A 인증(Authentication) : 이더리움 주소와 관련된 private key가 생성되었음을 인증함. 
B 무결성(Integrity) : 서명이 만들어진 뒤에 transaction data는 변하지 않는다는 것을 보장함.
C 부인 방지(Non-repudiation) : 서명을 하고 네트워크에 공표되었을 때, 나중에 그 서명한 것에 대해서 부인할 수 없다는 것을 보장함.

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
C. 
ECC함수에서 K = k * G를 찾을 수 없는 이유는 이산로그문제에 해당한다. 이는 현재 계산적으로 풀 수 없는 어려운 문제이기 때문에 알고있는 k와 G를 통한 K를 구하는 것은 수월하지만, K와 G를 통한 k구하기는 역 연산을 매우 오랫동안 해야한다. 이는 현재 컴퓨터로도 너무 많은 시간을 사용하여야 한다.  

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
nonce가 필요한 이유 : 1. 재사용 공격을 예방하기 위해서. 2. transaction 질서를 보장하기 위해서. 
재사용 공격이란 ECDSA에서 같은 nonce를 여러 번 사용하면, 공개된 서명 정보만으로 개인키를 계산할 수 있는 공격이다. 

---

## 문제 6: [이론] Private Key 보안 (단답형)

2022년 Ronin Bridge 해킹에서 약 $625M이 탈취되었습니다.

**왜** Private Key 유출이 이렇게 치명적인가요? 은행 계좌 비밀번호 유출과 비교해서 설명하세요.

**답변:**
<!--
2-3 문장으로 설명하세요.
힌트: 은행은 이상 거래 취소가 가능합니다. 블록체인은?
-->
블록체인에서는 private key를 통해서 transaction을 서명한다. 그렇게 된다면 그 transaction은 승인되는데 이는 탈중앙화를 중점으로 만든 시스템이기 때문에 바로 적용되는 것을 알 수 있다. 그렇기 때문에 거래를 취소/수정할 수 없다. 
은행 비밀번호는 노출되어도 중앙화된 특성을 이용하여 되돌리거나 수정하거나 그런 지원을 받을 수 있는 부분이 블록체인의 private key를 이용한 거래와는 다소 다른 부분이라고 볼 수 있다. 
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
이후 : 기본적으로 transaction을 블록에 연결하기 위한 최소한의 gas를 요구하는 가격이 존재하는데 이를 Base Fee라고 한다. 여기에 priorityFee를 더하여 최종적인 gas비가 산출되는데, 이는 우리가 흔히 알고있는 미국의 tip과 같은 비용이라고 볼 수 있다. 나의 transaction을 우선 처리해달라는 의미에서의 추가적인 비용이다. 
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
        assertEq(storage_.getBalance(user), 1 ether );  // TODO: 예상 잔액
    }
}
```

**왜 이렇게 작성했나요:**
<!--
각 빈칸에 대해 왜 그 코드를 선택했는지 설명하세요.
특히 vm.prank와 {value: ...} 구문의 의미를 설명해 주세요.
-->
SimpleStorage.t.sol 파일에 이렇게 적혀있기도 하고, 어떤 의미인지 잘 몰라서 그냥 붙혀 넣었다. 그래서 gemini에게 도움을 받았다. 다음 외부 호출을 위해 지정된 주소로 msg.send를 설정하기 위해 작성한다. 
{value :1 ether}의 구문의 의미는 함수의 호출과 함께 ether를 보내기 위한 구문이라고 볼 수 있다. (이를 위해 함수를 지불 가능으로 표시해야 한다고 한다)
        

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
잔액에서 차감하는 값이 잔고에 남아있는 값보다 클 때 문제가 발생한다. 보통 이러한 상황을 대비해서 require함수를 이용하여 차감하는 금액이 남아있는 금액보다 클 때 실행되지 않도록 설정하는 검증이 누락돼있다. 


**2) 왜 이것이 문제인가:**
<!--
이 상태로 withdraw(100 ether)를 호출하면 어떻게 될까요?
힌트: 잔액이 1 ether밖에 없는 경우를 생각해 보세요.
-->
잔액보다 더 많은 금액을 추출하는 호출을 하게 된다면 Panic Error가 발생하고 transaction은 자동적으로 revert된다. (음수는 존재할 수 없기 때문)

**3) 올바른 수정 방법:**
```solidity
// GOOD CODE - 수정된 withdraw 함수를 작성하세요
    function withdraw(uint256 amount) public {
        //잔액이 충분한지에 대한 검증
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
withdraw함수에 require의 조건이 걸려 함수가 실행되지 않고 revert가 걸린다. Foundry테스트의 기본 규칙은 revert가 발생하면 테스트는 실패한다는 것이다. 그래서 revert가 발생한다는 것을 미리 선언해줘야 revert가 발생하지 않고 계속 진행된다. 

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
        vm.expectRevert();
        // 입금 없이 바로 출금 시도
        storage_.withdraw(1 ether);
    }
}
```

---

## 자기 평가

모든 문제를 풀었다면, 아래 체크리스트로 자기 평가를 해보세요:

- [x] 트랜잭션 필드(nonce, gasPrice, gasLimit 등)의 역할을 이해했다
- [ ] 디지털 서명의 세 가지 보장(인증, 무결성, 부인 방지)을 설명할 수 있다
- [x] Private Key 보안의 중요성을 이해했다
- [ ] Foundry 테스트 기본 패턴(vm.prank, vm.deal, assertEq)을 사용할 수 있다
- [x] require 조건의 필요성을 이해했다

---

## 참고 자료

- 이론: `eth-materials/week-02/theory/slides.md`
- 코드: `eth-homework/week-02/dev/src/SimpleStorage.sol`
- 테스트: `eth-homework/week-02/dev/test/SimpleStorage.t.sol`
- 용어: `eth-materials/resources/glossary.md`
