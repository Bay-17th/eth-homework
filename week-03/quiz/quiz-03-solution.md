# Week 3 퀴즈: EVM/Security patterns

**제출 방법:**
1. 이 파일을 복사하여 `quiz-03-solution.md`로 저장
2. 각 문제에 답변 작성 (왜 그런지 설명 포함)
3. Pull Request 생성 (`quiz_submission` 템플릿 사용)

**평가 기준:**
- 정답 여부보다 **개념 이해도**를 중점 평가합니다
- 특히 **보안 취약점 식별과 방어 패턴**을 중점 평가합니다
- 코드 문제는 문법보다 보안 논리를 평가합니다

---

## 문제 1: [이론] EVM 개념 (객관식)

**답변: B) 모든 노드가 같은 입력에 대해 같은 결과를 얻어야 합의가 가능하므로**

### 설명

EVM은 전 세계 수많은 노드에서 동일하게 실행되는 가상 머신입니다.
블록체인의 핵심은 모든 노드가 동일한 상태(State)를 유지하는 **합의(Consensus)**에 있습니다.

만약 EVM에서 랜덤 함수(`Math.random()`)나 외부 API 호출이 허용된다면:

* 노드 A와 노드 B가 같은 트랜잭션을 실행해도 서로 다른 결과를 낼 수 있습니다.
* 이는 상태 불일치를 초래하며 블록체인 합의를 깨뜨립니다.

따라서 EVM은 어떤 환경에서 실행되더라도 **항상 동일한 결과를 보장하는 결정론적(Deterministic)** 실행 모델을 유지해야 합니다.

---

## 문제 2: [이론] Storage vs Memory (객관식)

**답변: B) Memory에 저장되며 함수 종료 시 삭제된다**

### 설명

Solidity의 저장 영역은 다음과 같이 구분됩니다:

* **Storage (가장 비쌈)**
  블록체인에 영구 저장됩니다.
  모든 노드가 데이터를 디스크에 저장해야 하므로 가스 비용이 매우 높습니다.

* **Memory (중간 비용)**
  함수 실행 중에만 존재하는 임시 공간입니다.
  함수 종료 시 삭제되며 Storage보다 훨씬 저렴합니다.

* **Stack (가장 저렴함)**
  작은 값 타입(`uint`, `bool` 등)이 저장되는 매우 빠른 공간입니다.

* **Calldata**
  외부 호출 시 전달되는 읽기 전용 데이터 영역입니다.

따라서 `uint[] memory data`는 Memory에 저장되며 함수 종료 시 삭제됩니다.

---

## 문제 3: [이론] Gas 비용 (객관식)

**답변: D) SSTORE (Storage 쓰기)**

### 설명

`SSTORE`는 블록체인의 상태를 영구적으로 변경하는 연산입니다.

* 모든 Full Node가 해당 데이터를 디스크에 영구 저장해야 합니다.
* 네트워크 전체 자원을 소모하기 때문에 매우 높은 가스 비용이 부과됩니다.
* 최초 기록 시 약 **20,000 gas**가 발생합니다.

반면:

* `ADD`, `MUL`은 수 gas 수준
* `SLOAD`는 약 2,100 gas 수준

따라서 Storage 쓰기(`SSTORE`)가 가장 비쌉니다.

---

## 문제 4: [이론] CEI 패턴

### 답변

CEI 패턴에서 Effects(상태 변경)가 Interactions(외부 호출)보다 먼저 와야 하는 이유는 **재진입 공격을 방지하기 위해서**입니다.

외부 호출(`call`)을 실행하면 제어권이 상대 컨트랙트로 넘어갑니다.
만약 상태를 변경하기 전에 외부 호출을 하면, 상대 컨트랙트가 `receive()`에서 다시 원래 함수를 호출(재진입)할 수 있습니다.

상태를 먼저 변경하면 재진입하더라도 조건 검사(`require`)에서 실패하여 공격이 차단됩니다.

---

## 문제 5: [이론] The DAO 사건 교훈

### 답변

* **기술적 교훈:**
  스마트 컨트랙트에서는 코드 순서 하나의 실수가 치명적인 보안 사고로 이어질 수 있습니다.
  CEI 패턴과 같은 방어적 프로그래밍이 필수적입니다.

* **생태계 교훈:**
  해킹 이후 하드포크를 통해 이더리움은 ETH와 ETC로 분리되었습니다.
  이는 블록체인의 불변성과 커뮤니티 거버넌스에 대한 중요한 논쟁을 남겼습니다.

---

## 문제 6: [코드] 재진입 공격 식별

### 1) 발견한 취약점

`withdraw()` 함수에서 외부 호출(`call`)이 상태 변경(`balances -= amount`)보다 먼저 실행되는
**재진입(Reentrancy) 취약점**이 존재합니다.

---

### 2) 왜 이것이 문제인가

1. 공격자가 `withdraw(1 ETH)` 호출
2. `require` 통과
3. ETH 전송 → 공격자의 `receive()` 실행
4. 아직 잔액 차감이 실행되지 않음
5. 공격자가 다시 `withdraw()` 호출
6. 반복하여 Vault 잔액을 모두 탈취

---

### 3) 올바른 수정 방법 (CEI 패턴)

```solidity
function withdraw(uint256 amount) public {
    require(balances[msg.sender] >= amount, "Insufficient balance");

    // Effects
    balances[msg.sender] -= amount;

    // Interactions
    (bool success, ) = msg.sender.call{value: amount}("");
    require(success, "Transfer failed");
}
```

---

## 문제 7: [코드] CEI 패턴 구현

```solidity
function secureWithdraw(uint256 amount) public {
    require(balances[msg.sender] >= amount, "Insufficient balance");

    balances[msg.sender] -= amount;

    (bool success, ) = msg.sender.call{value: amount}("");
    require(success, "Transfer failed");
}
```

### 왜 이 순서가 중요한가?

상태를 먼저 변경하면 재진입이 발생해도 잔액이 이미 차감되어
`require`에서 실패하고 트랜잭션이 Revert됩니다.

---

## 문제 8: [코드] tx.origin 취약점

### 1) 발견한 취약점

`tx.origin`을 사용한 권한 검증 → **피싱 취약점**

---

### 2) 공격 시나리오

* 공격자가 악성 컨트랙트 생성
* 소유자가 이를 호출
* 악성 컨트랙트가 내부적으로 `transferOwnership()` 호출
* `tx.origin`은 여전히 소유자이므로 require 통과
* 소유권 탈취

---

### 3) 올바른 수정 방법

```solidity
contract PhishingResistant {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function transferOwnership(address newOwner) public {
        require(msg.sender == owner, "Not owner");
        owner = newOwner;
    }
}
```

---

## 문제 9: [코드] ReentrancyGuard 적용

```solidity
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract SecureVault is ReentrancyGuard {
    mapping(address => uint256) public balances;

    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint256 amount) public nonReentrant {
        require(balances[msg.sender] >= amount, "Insufficient");
        balances[msg.sender] -= amount;

        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Failed");
    }
}
```

### CEI vs ReentrancyGuard

좋아요 👍
표 대신 **자연스러운 줄글 설명 형태**로 정리해드릴게요. 그대로 교체해서 쓰시면 됩니다.

---

### CEI vs ReentrancyGuard

- CEI(Checks-Effects-Interactions) 패턴은 상태 변경을 외부 호출보다 먼저 수행함으로써 재진입 공격을 방지하는 방식입니다. 별도의 라이브러리를 사용하지 않기 때문에 가스 효율이 좋고, 코드 구조가 단순한 경우 매우 효과적입니다. 다만 개발자가 순서를 잘못 작성하면 보안 취약점이 발생할 수 있어, 휴먼 에러의 가능성이 존재합니다.

- ReentrancyGuard는 OpenZeppelin에서 제공하는 보안 모듈로, `nonReentrant` modifier를 통해 재진입을 원천적으로 차단합니다. 코드 레벨에서 명시적으로 재진입을 막기 때문에 실수를 줄일 수 있고, 복잡한 컨트랙트 구조에서 특히 유용합니다. 하지만 내부적으로 락 상태를 저장하고 변경해야 하므로 약간의 가스 오버헤드가 발생합니다.

실무에서는 하나만 사용하는 것보다, CEI 패턴을 기본적으로 지키면서 ReentrancyGuard를 함께 사용하는 **Defense in Depth(심층 방어 전략)**이 가장 안전한 접근 방식으로 권장됩니다.


---

## 문제 10: [다이어그램 분석]

### 질문 1

6번에서 require가 통과하는 이유는
**잔액 차감이 아직 실행되지 않았기 때문**입니다.

---

### 질문 2

CEI 적용 시 잔액이 먼저 차감되므로
재진입 시 `require`에서 실패하고 Revert됩니다.

---

### 질문 3

공격자는 자신의 1 ETH를 이용해 공격을 시작하고
재진입을 통해 Vault에 존재하는 모든 ETH(10 ETH)를 탈취할 수 있습니다.

결과적으로 Vault 전체 잔액이 drain됩니다.

---

# 자기 평가

* [x] EVM의 결정론적 실행 이해
* [x] Storage/Memory/Stack 차이 이해
* [x] 재진입 공격 원리 설명 가능
* [x] CEI 패턴 구현 가능
* [x] tx.origin 취약점 이해
* [x] ReentrancyGuard 적용 가능

---

## 참고 자료

- 이론: `eth-materials/week-03/theory/slides.md`
- 취약한 코드: `eth-homework/week-03/dev/src/Vault.sol`
- 안전한 코드: `eth-homework/week-03/dev/src/VaultSecure.sol`
- 테스트: `eth-homework/week-03/dev/test/Vault.t.sol`
- 용어: `eth-materials/resources/glossary.md`
