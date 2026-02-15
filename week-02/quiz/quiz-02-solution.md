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
B) 트랜잭션 실행에 사용된 gas가 gasLimit 보다 작을 경우, (사용한 gas 단위) * gasPrice 공식으로 총 가스 비용이 계산된다. 반면 gasLimit만큼의 gas를 소모했음에도 트랜잭션 실행이 완료되지 않았다면 gasLimit * gasPrice가 총 가스 비용으로 빠져나가고 트랜잭션은 롤백되어 실행 전 상태로 돌아간다.

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
B) nonce는 해당 계정이 몇 번째로 보내는 트랜잭션인지 나타내는 값으로 트랜잭션의 실행 순서를 보장하고 이중 지불(double spending)을 방지한다. 동일 계정의 트랜잭션을 nonce 순서대로 처리함으로써 상태 일관성이 보장된 결정론적 실행을 가능하게 하고, 이미 처리된 트랜잭션을 인식하고 폐기함으로써 시스템 신뢰성을 확보한다. 트랜잭션의 gasPrice로 얻고자하는 블록 포함 경쟁력은 nonce로 확보된 결정론적 실행이 가능한 시스템 위에서 의미가 있으므로 nonce 순서가 gasPrice보다 우선한다. 

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
A) 디지털 서명은 개인키로부터 일련의 수학적 가공을 거친 결과로 인증, 무결성, 부인 방지를 보장한다. 
인증: 개인키를 모르는 사람이 그 키에 대응하는 유효한 서명 값을 도출하는 것을 수학적으로 불가능하게 설계하여 서명이 해당 개인키 소유자에 의해 생성되었음을 보장한다. 이를 통해 신분이나 서명의 위조를 방지한다.

무결성: 서명은 메시지의 해시값에 대해 만들어지므로 서명 이후 메시지 내용이 변경되면 서명 검증이 실패하여 그 변경을 감지해 낼 수 있다. 이를 통해 데이터 변경 감지를 보장하고 변조를 방지한다.

부인 방지: 개인키를 보유한 사람만이 유효한 서명을 만들 수 있으므로 키가 안전하게 보관된다는 전제 하에서 서명의 생성자는 자신이 해당 메시지에 서명했다는 사실을 사후에 부인할 수 없다. 이를 통해 서명자의 서명 행위 부인 방지를 보장한다.

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

C) Private Key에 타원곡선 위의 특정 좌표 G를 곱해서 Public Key를 계산한다. 이를 역산하여 Public Key로부터 Private Key를 계산하는 과정은 "이산 로그 문제"에 해당하며 현재 알려진 알고리즘으로는 사실상 계산이 불가능하다.
Public Key에 해시함수(keccak256)를 적용 후 마지막 12B를 잘라 Address를 생성한다. 이 과정에서 12B의 정보가 손실되므로 Address로부터 Public Key의 해시값을 유일하게 복원하는 것은 불가능하다. 설령 해시값을 알더라도 해시 함수의 역상저항성(preimage resistance)으로 인해 해당 해시값에 대응하는 Public Key를 계산하는 것은 사실상 불가능하다. 

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

nonce가 없다면 동일 트랜잭션의 재사용을 방지할 수 없다.

예를 들어 과거에 B가 A에게 1ETH를 송금하는 유효한 트랜잭션 T를 보낸 상황에서 A가 이 트랜잭션을 복사한 T'를 생성해서 전파한다고 하자. 매번 출금을 위해 참조하는 아웃풋이 달라지는 UTXO 모델과 다르게 Account 모델을 사용하는 이더리움에서는 T와 T'의 출금처(B 계좌)가 완전히 동일하다. 이로 인해 과거 T에 대한 B의 서명이 동일한 내용의 T'에 대해서도 유효하게 검증된다. 이는 과거 유효했던 트랜잭션을 복사해서 반복 실행하는 재사용 공격으로 시스템의 신뢰성을 훼손할 수 있다.

---

## 문제 6: [이론] Private Key 보안 (단답형)

2022년 Ronin Bridge 해킹에서 약 $625M이 탈취되었습니다.

**왜** Private Key 유출이 이렇게 치명적인가요? 은행 계좌 비밀번호 유출과 비교해서 설명하세요.

**답변:**
<!--
2-3 문장으로 설명하세요.
힌트: 은행은 이상 거래 취소가 가능합니다. 블록체인은?
-->

Private Key가 유출되면 공격자는 디지털 서명을 직접 만들 수 있으므로 해당 키로 생성된 모든 계좌에서 유효한 트랜잭션을 자유롭게 생성할 수 있다. 모든 거래를 통제하는 중앙 기관이 존재하여 이상 거래에 대해 사후 조치를 할 수 있는 은행과 다르게 블록체인 시스템은 중앙 통제자 없이 참여자들의 합의로 운영된다. 일단 블록에 기록되어 합의에 의해 확정된 거래(트랜잭션)는 무슨 일이 있어도 되돌릴 수 없기 때문에 사후 구제 방안이 없다는 점에서 치명적이다.

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

EIP-1559 이전에는 사용자가 gas 1단위당 가격인 gasPrice를 직접 설정하고 해당 수수료 전액이 블록 제안자에게 지급되는 경매 방식이었다. 이후에는 네트워크 혼잡도에 따라 자동으로 조정되는 baseFee와 블록 포함 경쟁을 위해 사용자가 설정하는 priorityFee로 분리되어 baseFee는 소각되고 priorityFee만 제안자에게 돌아가게 되었다. 이를 통해 수수료 경쟁이 완화되고 수수료의 예측 가능성이 향상되었으며 ETH 통화량과 발행량에도 영향을 끼쳤다.

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
        vm.prank(user);
        // vm.deal에서의 user는 테스트 코드를 실행하는 계정, vm.prank에서의 user는 해당 함수를 호출하는 계정(함수를 호출하는 트랜잭션의 msg.sender 설정)

        // Act: 1 ETH 입금
        storage_.deposit{value: 1 ether}();
        // call with value 문법 - Solidity에서 해당 함수 호출이 담긴 트랜잭션의 속성 필드(value, gas,  maxFeePerGas, maxPriorityPerGas) 값을 설정 가능 (nonce, r/s/v, chainId 필드는 설정 불가)

        // Assert: 잔액 확인
        assertEq(storage_.getBalance(user), 1 ether); 
        // 10eth를 가진 0x1 EOA에서 storage_라는 Simple Storage가 올라간 CA로 1eth를 입금했으므로 storage_ 내부 스토리지에서 관리하는 0x1의 balances에는 1eth, 0x1의 EOA 계정 balance에는 9eth가 된다.
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

vm은 virtual machine으로 Foundry에서 제공하는 테스트 전용 가상 머신 인터페이스이다. 모든 노드가 서로 동등한 지위를 갖고 각 노드에서 함수 호출과 상태 변경이 독립적으로 일어나는 운영 환경과 다르게 테스트 환경에서는 네트워크 전체를 조망하며 테스트 스크립트를 실행하는 외부 노드(단일 EVM 인스턴스)가 존재한다. 스크립트로 설계된 테스트 상황에서의 각 노드의 동작은 이 EVM 안에서 이루어지며, vm은 외부 노드의 입장에서 스크립트 내부에서 동작하는 가상 노드의 동작을 제어하는 함수를 제공한다. 그 중 vm.prank는 트랜잭션의 호출자를 설정하여 실행 주체를 자유롭게 시뮬레이션 할 수 있게 한다. 위 코드에서 vm.deal로 balance에 10 eth를 설정한 user EOA가 테스트 환경의 내부 노드로서 deposit을 호출하는 시나리오를 위해 vm.prank(user)로 실행 주체를 전환했다.

{value: ...} 구문은 함수를 호출할 뿐만 아니라 함수가 담길 트랜잭션의 value 필드를 설정히여 해당 CA로 이더를 전송하는 call with value 문법이다. SimpleStorage의 deposit 함수는 입금 금액을 별도의 인자 대신 msg.value로 트랜잭션의 value 필드에 직접 접근하여 동작하도록 정의되었으므로 {value: 1 eth}로 호출하였다. value 필드 이외에도 {gas: ..., maxFeePerGas, maxPriorityFeePerGas: ...}와 같은 형식으로 함수 호출과 관련된 트랜잭션 실행 속성을 설정할 수 있으며 계정, 서명 관련 핵심 필드는 설정할 수 없다.

assertEq는 Foundry가 테스트 환경에서 제공하는 함수로 인자로 받은 두 값이 같은지 검증하는 함수이다. deposit 함수 실행 후의 balances 값을 deposit으로 전달된 입금 금액과 비교하여 함수가 의도대로 동작하는지 확인할 수 있다.

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

withdraw()에서 출금하려는 금액이 기존 잔액보다 작은지 검증하는 과정이 빠져있다.

**2) 왜 이것이 문제인가:**
<!--
이 상태로 withdraw(100 ether)를 호출하면 어떻게 될까요?
힌트: 잔액이 1 ether밖에 없는 경우를 생각해 보세요.
-->

withdraw를 호출한 계좌를 A라고 하자. 현재 코드 그대로 실행된다면 Wallet 컨트랙트에서 A의 balances 값에 (1 - 100)의 계산 결과가 저장된다. uint256 타입에서 1 - 100 계산 시 언더플로우가 발생하여 트랜잭션이 revert된다.

**3) 올바른 수정 방법:**
```solidity
// GOOD CODE - 수정된 withdraw 함수를 작성하세요
```

function withdraw(uint256 amount) public {
    require(balances[msg.sender] >= amount, "Insufficient balance");

    // 잔액 차감
    balances[msg.sender] -= amount;

    // ETH 전송
    payable(msg.sender).transfer(amount);
}

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
Solidity에서 mapping이나 uint256 같은 상태 변수는 컨트랙트 배포 시 자동으로 0으로 초기화된다. 따라서 호출하는 계좌를 따로 셋업하지 않고 SimpleStorage에 접근할 경우 모든 상태 변수가 0인 상태를 기반으로 동작하게 된다. 위 테스트처럼 호출 계좌가 입금 없이 withdraw(1 ether)를 실행할 경우 잔액인 0보다 큰 값을 출금하게 되어 balances[msg.sender] < amount가 된다. 이에 require(balances[msg.sender] >= amount, "Insufficient balance"); 조건을 충족하지 못해 트랜잭션이 revert 된다.

**질문 2:** 이 테스트를 "출금 실패를 테스트하는 정상 테스트"로 바꾸려면 어떻게 수정해야 하나요?

**답변:**
```solidity
// 힌트: vm.expectRevert를 사용하세요
// 수정된 테스트 코드를 작성하세요
```

function test_WithdrawFails() public {
    vm.expectRevert("Insufficient balance");
    storage_.withdraw(1 ether);
}

vm.expectRevert는 다음 실행되는 함수가 지정된 revert 메시지와 함께 실패할 것으로 예상하고 테스트를 통과시킨다.
---

## 자기 평가

모든 문제를 풀었다면, 아래 체크리스트로 자기 평가를 해보세요:

- [v] 트랜잭션 필드(nonce, gasPrice, gasLimit 등)의 역할을 이해했다
- [v] 디지털 서명의 세 가지 보장(인증, 무결성, 부인 방지)을 설명할 수 있다
- [v] Private Key 보안의 중요성을 이해했다
- [v] Foundry 테스트 기본 패턴(vm.prank, vm.deal, assertEq)을 사용할 수 있다
- [v] require 조건의 필요성을 이해했다

---

## 참고 자료

- 이론: `eth-materials/week-02/theory/slides.md`
- 코드: `eth-homework/week-02/dev/src/SimpleStorage.sol`
- 테스트: `eth-homework/week-02/dev/test/SimpleStorage.t.sol`
- 용어: `eth-materials/resources/glossary.md`
