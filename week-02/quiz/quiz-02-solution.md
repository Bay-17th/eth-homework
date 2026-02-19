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
B,총 가스 비용은 EIP-1559 이후 아래 공식을 따른다.
총 비용 = gasUsed * (baseFeePerGas + priorityFeePerGas) 인데 여기서 baseFeePerGas는 블록마다 네트워크가 알아서 산정하는 비용이며 priorityFeePerGas는 검증자에게 주어지는 수수료이다. 이 수수료의 계산법은 트랜잭션에서 거래자가 설정하는 maxPriorityFeePerGas와 maxFeePerGas를 이용하면 아래 공식과 같다
priorityFeePerGas = min(maxPriorityFeePerGas, maxFeePerGas - baseFeePerGas)
그럼 전체 공식은
gasUsed * (baseFeePerGas + min(maxPriorityFeePerGas, maxFeePerGas - baseFeePerGas)) 
가 된다. 참고로 maxPriorityFeePerGas는 검증자에게 줄 팁의 최대치, maxFeePerGas는 이 트랜잭션 전체에 지불할 용의가 있는 가스 최대치다.
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
B,nonce는 트랜잭션의 순서를 강제하고 리플레이 공격 및 이중 지불을 방지하는 합의를 위한 핵심 규칙 요소다. 그렇기에 계정 상태의 순서를 보장하려면 nonce가 gasPrice보다 우선해야하며 gasPrice는 같은 nonce인 트랜잭션일때만 경쟁에 영향을 미친다.

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
C,부인 방지는 서명한 본인이 나중에 이 서명을 내가 한것이 아니라고 부인할 수 없다는 뜻이고, 이는 곧 내 개인키만이 내 이름으로 유효한 서명을 만들 수 있다는 뜻이다. 따라서 다른 누군가 내 트랜잭션을 위조할 수 없음을 뜻한다.

인증은 메시지 송신자가 누구인지 증명이 가능함을 보장하고, 무결성은 메시지 내용이 위변조되지 않았음을 보장한다.

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
C,먼저 개인키->공개키 과정은 역산을 시도할 경우 주어진 Q와 G에서 d를 구하는 타원 곡선 상의 이산 로그문제를 풀게되는데, 이는 현재 상용 컴퓨터의 가장빠른 알고리즘으로도 2^128번 이상 시도를 요구하며 설사 양자컴퓨터의 grover알고리즘을 쓰더라도 여전히 천문학적 수준의 연산인 2^64번을 최소 시도해야한다. 
공개키->주소 과정에 쓰이는 keccak256 해시 함수는 충돌 저항성이 강해 같은 주소가 나오는 공개키를 찾는것조차 preimage를 구하는 급으로 연산을 요구하므로 2^160번 정도의 시도를 요구한다. 수학적 난이도가 극악이므로 불가능에 가깝다.

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
서명된 동일한 트랜잭션을 여러번 재사용하는 걸 막아야한다.

만약 nonce가 없다면 alice가 bob에게 1 eth를 보내는 트랜잭션을 한번 서명해서 보냈을때, 악의적인 공격자가 그 서명된 트랜잭션을 복사해 네트워크에 여러번 다시 전송시 alice의 계좌에 수십 eth가 빠져나가게 된다. nonce는 이런 재사용을 막는다.

---

## 문제 6: [이론] Private Key 보안 (단답형)

2022년 Ronin Bridge 해킹에서 약 $625M이 탈취되었습니다.

**왜** Private Key 유출이 이렇게 치명적인가요? 은행 계좌 비밀번호 유출과 비교해서 설명하세요.

**답변:**
<!--
2-3 문장으로 설명하세요.
힌트: 은행은 이상 거래 취소가 가능합니다. 블록체인은?
-->
블록체인에 기록된 트랜잭션은 불변성에 의해 절대 되돌릴 수 없다. private key를 입수한 공격자가 해당 계정의 모든 자산을 즉시 자신의 계정으로 이동시키는 트랜잭션이 블록에 담긴 경우 중앙화된 은행의 경우 이상거래로 취소가 되지만 탈중앙 네트워크인 블록체인은 누구도 취소나 자금 복구가 불가하다.

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
이전 방식에서 생긴 네트워크 혼잡에서의 경매로 인한 수수료 변동성을 해결하기 위해 EIP-1559 이후 네트워크가 자동으로 계산하는 기본 소각료인 baseFee로 ETH의 과한 공급으로 인한 인플레이션 우려를 해결하고 priorityFee(팁)만 추가로 설정해 거래 우선순위를 안전하게 조절할수 있게 되었다.

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
vm.prank는 foundry cheatcode를 이용해 다음 호출의 msg.sender를 매개변수로 들어간 주소 계정으로 바꾼다.
지정하지 않으면 테스트 컨트랙트의 잔액이 증가하고 user는 그대로이기 떄문이다.
{value : ...} 구문은 payable함수를 호출 시 트랜잭션 메타데이터를 수정하기 위해 들어간다.
assertEq로 user의 밸런스를 체크해 잔액이 정상적으로 증가했는지 테스트한다.
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
balances[msg.sender]가 amount보다 같거나 큰지 검증하는 부분이 빠져 있다.재진입 방지가 되어있지 않다.

**2) 왜 이것이 문제인가:**
<!--
이 상태로 withdraw(100 ether)를 호출하면 어떻게 될까요?
힌트: 잔액이 1 ether밖에 없는 경우를 생각해 보세요.
-->
잔액보다 많은 액수를 인출 요청할 경우 언더플로로 엉뚱한 값이 되거나 강제 revert된다. 또한 DAO 해킹처럼 동일한 계정이 여러번 전송 요청을 보낼수 있으므로 위험하다.

**3) 올바른 수정 방법:**
```solidity
// GOOD CODE - 수정된 withdraw 함수를 작성하세요
function withdraw(uint256 amount) public {
        // 잔액 차감
        require(balances[msg.sender] >= amount, "Count cannot go below zero");
        balances[msg.sender] -= amount;

        // ETH 전송
        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "ETH transfer failed");
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
require(balances[msg.sender] >= amount, "Insufficient balance");
위 조건에 걸려 실패한다.

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
        // 입금 없이 바로 출금 시도
        vm.expectRevert("Insufficient balance");
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
