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
정답은 B입니다. gasPrice는 가스의 단위 비용이고 gasLimit은 트랜잭션이 사용할 수 있는 최대 가스 양입니다. 단일 트랜잭션이 사용하는 총 가스 비용은 (실제 사용 가스량)*(gasPrice) 입니다. 
-->


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
정답은 B입니다. gasPrice와 무관하게 트랜잭션의 원자성을 위해서 nonce의 순서를 지켜야합니다. 그리고 애초에 nonce=6인 트랜잭션은 nonce=5인 트랜잭션이 확정되지 않으면 실행 자체가 불가능합니다.
-->


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
처음엔 정답을 B라고 생각했습니다. 왜냐하면 내 트랜잭션을 위조할 수 없다는게 기존의 트랜잭션을 임의로 수정할 수 없다는 것으로 이해하여 이는 무결성이라고 생각했지만 위조라는 단어를 헷갈리고 있어서 그런 것이였습니다. 위조란 '존재하지 않는 것을 새로 만들어내는 것'입니다. 그렇다면 "누군가 내 트랜잭션을 임의로 만들어낼 수 없다"는 것은 제 3자가 내 서명을 생성할 수 없다는 것을 말하므로 이는 인증의 속성을 설명합니다.

무결성은 서명된 트랜잭션 데이터가 중간에 변조되지 않았음을 보장하는 속성이고 부인 방지는 서명한 사람이 "그 트랜잭션을 보낸 사람이 내가 아니다"라고 부인할 수 없다는 속성입니다.
-->


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
정답은 C입니다. 난수 생성 알고리즘으로 Private Key를 생성한 뒤에 Private key와 ECDSA를 사용하여 Public key를 생성합니다. 하지만 타원 곡선 암호화를 역산하는 것은 수학적으로 가능은 하지만 현대 컴퓨팅 능력으로 불가능에 매우 가까운 확률을 가집니다. 그리고 Address는 Public key를 해시 함수에 돌려서 결과값의 마지막 20 바이트를 사용합니다. 해시 함수는 일방향 함수이므로 해시 함수의 결과값을 사용해서 입력값을 추론해내는 것은 불가능에 가깝습니다. 그래서 두 과정 모두 역방향으로 이전 값을 알아내는 것은 현대의 컴퓨팅 능력으로 사실상 불가능에 가깝습니다.
-->


---

## 문제 5: [이론] nonce의 필요성 (단답형)

이더리움에서 **왜** nonce가 필요한가요?

만약 nonce가 없다면 어떤 공격이 가능해질까요? 구체적인 예시와 함께 설명하세요.

**답변:**
<!--
Alice가 Bob에게 100 ETH를 보내는 서명된 트랜잭션을 broadcast했다고 가정하자. nonce라는 field가 아예 없다면 Bob은 그냥 해당 트랜잭션을 그대로 복사해서 여러번 broadcast해버리면 검증자들 입장에서는 지극히 정상적인 트랜잭션이 여러 개 오는 것이므로 Alice는 Bob에게 100 ETH만 보내려고 했지만 몇 백 ETH를 보내게 됩니다. 이때 nonce를 사용한다면 Bob이 복사해서 broadcast해도 nonce가 동일한 트랜잭션들 중 무조건 하나만 처리되기 때문에 재사용 공격이 불가능해진다. 만약 Bob이 다른 내용은 동일하고 nonce만 바꿔서 broadcast해도 ECDSA 기반 서명은 트랜잭션의 전체 내용을 사용하여 서명을 생성하기 때문에 nonce값이 바뀌면 서명으로 검증이 불가능해지므로 nonce field만 추가해줘도 재사용 공격이 방지됩니다.
-->


---

## 문제 6: [이론] Private Key 보안 (단답형)

2022년 Ronin Bridge 해킹에서 약 $625M이 탈취되었습니다.

**왜** Private Key 유출이 이렇게 치명적인가요? 은행 계좌 비밀번호 유출과 비교해서 설명하세요.

**답변:**
<!--
은행 계좌 비밀번호가 유출된다면 주인이 계좌를 동결시키거나 은행에 조치를 취해달라고 요청할 수 있지만 Private key가 유출되어버린다면 은행과 같은 중앙관리자가 없으므로 거래를 되돌리거나 취소할 방법이 존재하지 않습니다. 블록체인에서는 한 번 블록에 기록된 트랜잭션은 불변이며 Private key를 가진 자가 곧 소유자이기 때문입니다.
-->


---

## 문제 7: [이론] EIP-1559 이해 (단답형)

EIP-1559 이전과 이후의 가스 수수료 메커니즘의 가장 큰 차이점은 무엇인가요?

**힌트:** `baseFee`와 `priorityFee`의 역할을 설명하면서 답변하세요.

**답변:**
<!--
EIP-1559 이전에는 사용자가 gasPrice를 직접 설정하는 방식이었지만 이후에는 수수료는 두 부분으로 나뉘게 됩니다. baseFee는 소각되는 기본 수수료로 이를 통해 ETH 공급량을 줄이고 priorityFee는 검증자에게 직접적으로 지불하는 fee입니다. priorityFee는 비트코인의 transaction fee와 같은 개념이라고 생각하면 되고 이를 통해 트랜잭션의 우선순위를 높힐 수 있습니다.
-->


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

        // Assert: 잔액 확인
        assertEq(storage_.getBalance(user), 1 ether);  // TODO: 예상 잔액
    }
}
```

**답변:**
```solidity
// 빈칸을 채운 완성 코드를 작성하세요
```

**왜 이렇게 작성했나요:**
<!--
- vm.prank(user): Foundry 치트코드로 다음 한 번의 외부 호출에서 msg.sender를 user로 변경해서 user 주소가 호출한 것처럼 시뮬레이션합니다.
- storage_.deposit{value: 1 ether}(): Solidity의 {value: ...} 구문으로 함수 호출 시 ETH를 함께 전송합니다. deposit()이 payable이므로 가능합니다.
- 1 ether: 1 ETH를 입금했으므로 예상 잔액도 1 ether입니다.
-->


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
withdraw 함수에서 잔액 확인인 require이 없습니다. amount가 사용자의 잔액보다 큰지 검증하지 않고 바로 차감해버립니다.
-->


**2) 왜 이것이 문제인가:**
<!--
잔액이 1 ETH인 사용자가 withdraw(100 ether)를 호출하면, balances[msg.sender] -= amount에서 언더플로우가 발생합니다. 또한 require가 없으면 의미 있는 에러 메시지를 제공할 수 없어 디버깅이 어려워집니다.
-->


**3) 올바른 수정 방법:**
```solidity
function withdraw(uint256 amount) public {
    require(balances[msg.sender] >= amount, "잔액이 충분하지 않습니다.");
    balances[msg.sender] -= amount;
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
deposit()을 하지 않았으므로 잔액이 0입니다. withdraw(1 ether) 호출 시 require(balances[msg.sender] >= amount, "잔액이 충분하지 않습니다.") 조건에서 0 >= 1 ether이 false이므로 revert되어 테스트가 실패합니다.
-->


**질문 2:** 이 테스트를 "출금 실패를 테스트하는 정상 테스트"로 바꾸려면 어떻게 수정해야 하나요?

**답변:**
```solidity
function test_WithdrawFails() public {
    vm.expectRevert("잔액이 충분하지 않습니다.");
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
