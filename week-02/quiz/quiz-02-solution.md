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
정답: B

gasPrice는 EVM에서 연산을 처리할때 가스 1 단위당 채굴자에게 지불하겠다고 약속하는 단가입니다. 네트워크가 혼잡할수록 채굴자들은 비싼 단가를 부른 사람의 거래를 먼저 처리해주므로 이 값을 높이면 트랜잭션이 빨리 처리될 확률이 높아집니다. gasLimit은 이 트랜잭션이 실행될 때 소비할 수 있는 최대 가스량의 상한선으로, 최대로 써도 된다고 허용한 가스의 총량입니다 악의적인 공격으로 인해 수수료가 무한정 빠져나가는것을 막기 위한 안전장치 역할을 합니다.

총 가스 비용 = 실제 사용한 가스량(gasUsed) * 가스당 가격(gasPrice)

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

정답: B

이더리움에서 논스는 특정 지갑 계정에서 전송한 트랜잭션의 고유한 일련번호이고, 이때 한 계정에서 나온 트랜잭션은 반드시 논스숫자가 오름차순으로, 중간에 빠짐없이 순서대로 처리되어야 한다는 규칙이 있습니다.

블록체인은 A에서 B상태로 넘어가는 상태머신이기 때문에 5번 트랜잭션이 계좌의 잔고를 어떻게 바꾸느냐에 따라 6번 트랜잭션의 성공여부가 결정됩니다. 그래서 TX-A(nonce=5)의 논스 5가 처리되어야 TX-B(nonce=6)가 처리될 수 있습니다.TX-B의 gasPrice가 더 높더라도, 같은 계정에서 나온 트랜잭션은 gasPrice가 순서를 깨고 앞지를 수 없습니다.

채굴자 입장에서는 gasPrice가 100gwei 로 더 비싼 TX-B를 먼저 처리해서 수수료를 많이 받고싶을것이지만, 이더리움 프로토콜 규칙상 현재 상태가 논스 5를 기다리는 상태라면 TX-B는 멤풀에서 머물며 기다려야만 합니다. 
---

## 문제 3: [이론] 디지털 서명 (객관식)

디지털 서명(ECDSA)이 보장하는 세 가지 속성 중, "누군가 내 트랜잭션을 위조할 수 없다"를 보장하는 것은?

**보기:**
A) 인증 (Authentication)
B) 무결성 (Integrity)
C) 부인 방지 (Non-repudiation)
D) 암호화 (Encryption)

**답변:**

정답: A

트랜잭션 데이터에 나의 private key로 복잡한 수학적 연산을 거쳐 서명값ㅇ을 덧붙여 네트워크에 보내면, 다른 사람들은 나의 공개키를 사용해 이 서명이 진짜 그 개인키를 가진 사람으로부터 나온것이 맞는지를 검증하는데, 이것이 인증입니다. 

- 무결성: 트랜잭션 내용을 해시함수에 넣어 해시값을 만들고, 그 값에 서명함으로써 데이터가 중간에 변조되지 않았다는 것을 보장합니다.
- 부인방지: 한번 내 키로 서명해서 보낸 트랜잭션은 공개키 검증을 통해 그 키로 서명된 사실이 남기때문에 나중에 부정하기 어렵습니다.
---

## 문제 4: [이론] 키 유도 (객관식)

다음 중 키 유도 과정에서 올바른 방향을 설명한 것은?

**보기:**
A) Public Key -> Private Key -> Address 순으로 유도된다
B) Address -> Public Key -> Private Key 순으로 역추적 가능하다
C) Private Key -> Public Key -> Address 순으로 유도되며, 역방향은 불가능하다
D) 세 값은 독립적으로 생성되며 서로 연관이 없다

**답변:**

정답: C

Private Key로부터 Public Key는 타원곡선 연산(스칼라 곱)으로 만들어집니다. 그리고 Public Key로부터 Address는 해시(예: Keccak-256)로 만든 뒤 일부를 쓰는 방식으로 만들어집니다.

Public Key -> Private Key는 타원곡선 이산로그 문제라서, 현실적인 시간 안에 풀기 어렵습니다. Address -> Public Key도 해시의 역상 찾기 문제라서, 입력을 거꾸로 찾아내는것이 사실상 불가능합니다. 즉, 정방향은 계산이 쉽지만 역방향은 계산이 극단적으로 어려운 일방향성 때문에 안전합니다.
---

## 문제 5: [이론] nonce의 필요성 (단답형)

이더리움에서 **왜** nonce가 필요한가요?

만약 nonce가 없다면 어떤 공격이 가능해질까요? 구체적인 예시와 함께 설명하세요.

**답변:**

nonce는 트랜잭션을 한 번만 유효하게 만들기 위해 필요합니다.
논스가 없다면 내가 이미 서명해서 보낸 트랜잭션을 공격자가 복사해서 똑같이 여러번 재전송할 수 있고, 반복송금으로 인한 피해가 발생하게 됩니다. 그래서 논스라는 일회용 일련번호를 데이터안에 포함시킴으로써 이러한 재사용 공격을 방지합니다.

---

## 문제 6: [이론] Private Key 보안 (단답형)

2022년 Ronin Bridge 해킹에서 약 $625M이 탈취되었습니다.

**왜** Private Key 유출이 이렇게 치명적인가요? 은행 계좌 비밀번호 유출과 비교해서 설명하세요.

**답변:**

은행시스템에는 중앙 서버가 존재하기 때문에, 계좌 비밀번호가 유출되더라도 장부에서 거래를 취소하거나 계좌를 동결할 수 있습니다. 반면 블록체인은 private key로 서명된 트랜잭션을 100% 정당한 소유자의 명령으로 간주하며, 한번 블록에 기록된 데이터는 시스템 구조상 누구도 절대 수정하거나 되돌릴 수 없는 불변성을 가지기 때문에 유출 시 자산 회수가 불가능하여 치명적입니다. 

---

## 문제 7: [이론] EIP-1559 이해 (단답형)

EIP-1559 이전과 이후의 가스 수수료 메커니즘의 가장 큰 차이점은 무엇인가요?

**힌트:** `baseFee`와 `priorityFee`의 역할을 설명하면서 답변하세요.

**답변:**

이전: 사용자들이 채굴자에게 가스비를 직접 제시하는 블라인드 경매 방식이라 수수로 예측이 어려웠습니다.

이후: 프로토콜이 네트워크 혼잡도에 따라 알고리즘으로 자동계산하여 전액 소각되는 기본요금인 baseFee랑 빠른 처리를 원할때 채굴다에게 추가해주는 팁 priorityFee로 분리되어 수수료 예측가능성이 높아졌습니다. 
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
function test_DepositUpdatesBalance() public {
        // Arrange: user 관점에서 실행
        vm.prank(user);  // TODO: user로 전환하는 코드

        // Act: 1 ETH 입금
        storage_.deposit{value: 1 ether}();  // TODO: 1 ether를 입금하는 코드

        // Assert: 잔액 확인
        assertEq(storage_.getBalance(user), 1 ether);  // TODO: 예상 잔액
    }
```

**왜 이렇게 작성했나요:**
<!--
각 빈칸에 대해 왜 그 코드를 선택했는지 설명하세요.
특히 vm.prank와 {value: ...} 구문의 의미를 설명해 주세요.
-->
- vm.prank(user);
- EVM에서 모든 트랜잭션은 호출한 사람의 주소인 msg.sender을 가집니다. vm.prank()는 Foundry가 제공하는 치트코드로, 딱 다음 한 줄의 코드만 msg.sender을 user로 바꿔서 실행해달라는 명령어입니다. 

- storage_.deposit{value: 1 ether}();
- Solidity에서 payable이 붙은 함수를 호출하면서 동시에 실제 이더를 전송할때는 함수 이름 뒤에 중괄호{value: 금액}을 붙여서, 이 함수 호출에 eth를 실어서 보냅니다.

- assertEq(storage_.getBalance(user), 1 ether);
- 상태가 올바르게 전이되었는지 확인하는 단계입니다. 유저가 1 이더를 입금했으므로, 컨트랙트 내부의 매핑 데이터를 조회하는 getBalance(user)함수의 반환값은 정확히 1 eth가 되어야 합니다. 이때 assertEq(A,B)는 A와 B가 완벽히 같을때만 테스트를 통과시킵니다.


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

잔액을 검증하는 로직이 빠져있습니다.


**2) 왜 이것이 문제인가:**

잔액이 1 ether인데 withdraw(100 ether)를 호출하면 balances[msg.sender] -= amount에서 언더플로우가 발생하게 됩니다. 그런데 uint256은 음수를 표현할 수 없으므로 실행이 멈추고 에러가 발생하게 됩니다. 

**3) 올바른 수정 방법:**
```solidity
function withdraw(uint256 amount) public {
        // 1. 잔액이 출금 요청액보다 많은지 확인
        require(balances[msg.sender] >= amount, "Insufficient balance");

        // 2. 장부에서 잔액을 먼저 차감하기
        balances[msg.sender] -= amount;

        // 3. 실제 이더리움 네트워크를 통해 ETH를 전송하기
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
테스트가 실패하는 이유는, 입금이 없어서 출금 조건을 만족하지 못하는데 그냥 withdraw를 호출해서 강제 종료가 발생하기 때문입니다. 

**질문 2:** 이 테스트를 "출금 실패를 테스트하는 정상 테스트"로 바꾸려면 어떻게 수정해야 하나요?

**답변:**
```solidity
function test_WithdrawFailsWithoutBalance() public {
        
        vm.expectRevert(); 
        
        // 잔고가 0인 상태에서 출금을 시도하므로 여기서 Revert가 발생합니다.
        // vm.expectRevert() 덕분에 Foundry는 이를 예상된 동작으로 간주하고 테스트를 PASS시킵니다.
        storage_.withdraw(1 ether);
    }
```
revert 가 나야 정상이라는것을 먼저 선언해주어야 합니다. 즉, withdraw 호출 전에 vm.expectRevert()를 써서 이 다음 호출에서는 revert 가 난다는 사실을 알려주면 테스트를 통과할 수 있습니다.
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
