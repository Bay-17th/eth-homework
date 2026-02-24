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

EVM(Ethereum Virtual Machine)이 "결정론적(deterministic)"으로 실행되어야 하는 이유는?

**보기:**
A) 모든 노드가 같은 CPU를 사용해야 하므로
B) 모든 노드가 같은 입력에 대해 같은 결과를 얻어야 합의가 가능하므로
C) 트랜잭션 처리 속도를 높이기 위해
D) 개발자가 코드를 디버깅하기 쉽게 하기 위해

**답변:**
<!--
정답과 함께, EVM에서 랜덤 함수나 외부 API 호출이 금지된 이유를 설명하세요.
-->
B) 순수한 랜덤 함수는 모든 노드에서 같은 실행 결과를 얻는 것이 불가능하고, 외부 API 호출에 대해 응답을 주는 외부 서버 프로그램이 같은 입력에 대해 항상 같은 결과를 줄 것이라고 보장할 수 없으므로 EVM의 결정론적 실행을 훼손한다.

---

## 문제 2: [이론] Storage vs Memory (객관식)

다음 코드에서 `data` 변수의 저장 위치와 특성을 올바르게 설명한 것은?

```solidity
function process(uint[] memory data) public pure returns (uint) {
    uint sum = 0;
    for (uint i = 0; i < data.length; i++) {
        sum += data[i];
    }
    return sum;
}
```

**보기:**
A) Storage에 저장되며 함수 종료 후에도 유지된다
B) Memory에 저장되며 함수 종료 시 삭제된다
C) Stack에 저장되며 가장 비싼 저장 공간이다
D) Calldata에 저장되며 수정이 가능하다

**답변:**
<!--
정답과 함께, Storage/Memory/Stack의 비용 차이를 간단히 설명하세요.
힌트: 어떤 것이 가장 비싸고, 왜 비싼가요?
-->
B) Storage는 블록체인에 영구 기록되는 상태변수가 저장되는 공간으로 블록체인 상태 트리를 업데이트하는 연산을 수행하기 때문에 비용이 가장 크다. Memory와 Stack은 함수 실행 중에만 존재하는 변수가 저장되는 공간이다. 크기가 동적이거나 용량이 큰 복합형 타입 변수(동적 배열, 구조체, 매핑)는 Memory에, 단일 값의 기본형 변수(uint, bool, address)는 Stack에 저장되고 다루는 변수의 크기와 연산 비용을 고려했을 때 Memory의 비용이 대체로 Stack보다 크다.

---

## 문제 3: [이론] Gas 비용 (객관식)

다음 중 Gas 비용이 가장 높은 연산은?

**보기:**
A) ADD (덧셈)
B) MUL (곱셈)
C) SLOAD (Storage 읽기)
D) SSTORE (Storage 쓰기)

**답변:**
<!--
정답과 함께, 왜 Storage 관련 연산이 비싼지 설명하세요.
힌트: Storage에 저장된 데이터는 어떤 특성이 있나요?
-->
D)블록체인 상태 트리를 업데이트하고 영구 기록을 남겨야 하기 때문에 가장 비용이 높다.

---

## 문제 4: [이론] CEI 패턴 (단답형)

**왜** CEI(Checks-Effects-Interactions) 패턴에서 Effects(상태 변경)가 Interactions(외부 호출)보다 먼저 와야 하나요?

재진입 공격 시나리오와 연결해서 구체적으로 설명하세요.

**답변:**
<!--
2-3 문장으로 설명하세요.
힌트:
- 외부 호출 시 상대방 컨트랙트의 코드가 실행됨
- 그 코드에서 다시 원래 함수를 호출하면?
- 상태가 변경되지 않은 상태라면 어떻게 될까요?
-->
재진입 공격으로 컨트랙트의 Interactions 코드(msg.sender.call{value: amount})에 반응하여 원래 함수를 재호출시 컨트랙트의 Checks 코드를 제일 먼저 마주하게 된다. Checks 코드는 대체로 컨트랙트 내부의 상태를 기반으로 검사하기 때문에 이전 호출에 대한 상태의 변경이 완료되지 않았다면 첫 호출의 상태를 기준으로 require 검사나 잔액 체크가 수행되므로 무제한 인출을 허용하게 된다.

---

## 문제 5: [이론] The DAO 사건 교훈 (단답형)

2016년 The DAO 해킹($60M 피해)에서 우리가 배워야 할 **가장 중요한 교훈**은 무엇인가요?

이 사건 이후 이더리움 생태계에 어떤 변화가 있었나요?

**답변:**
<!--
2-3 문장으로 설명하세요.
교훈:
- 기술적 교훈 (코드 작성 관점)
- 생태계 교훈 (이더리움 커뮤니티 관점)
-->
기술적 관점에서 철저한 Checks, CEI 패턴, ReentrancyGuard 등 안전한 코딩 관행이 필수임을 보여주었다. 이 사건 이후 하드포크를 통해 블록체인 상태를 롤백한 생태계로서는 탈중앙이라는 무게에 비해 스마트컨트랙트 보안이 비교적 가볍다는 경각심을 갖고 컨트랙트 안전 검사, 안전한 패턴 표준화, 테스트의 중요성이 한층 강화되었다.

---

## 문제 6: [코드] 재진입 공격 식별 (취약점 찾기)

다음 코드에서 재진입 공격 취약점을 찾으세요:

```solidity
// BAD CODE - 취약점 찾기
contract VulnerableVault {
    mapping(address => uint256) public balances;

    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint256 amount) public {
        require(balances[msg.sender] >= amount, "Insufficient balance");

        // ❌ Reentrancy 위험: Effects보다 Interactions가 먼저 옴
        // ETH 전송
        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Transfer failed");

        // ❌ Reentrancy 위험: Effects가 Interactions보다 나중에 옴
        // 잔액 차감
        balances[msg.sender] -= amount;
    }
}
```

**1) 발견한 취약점:**
<!--
취약점 이름과 위치를 명시하세요.
힌트: withdraw 함수의 순서를 자세히 보세요.
-->


**2) 왜 이것이 문제인가:**
<!--
공격자가 어떻게 이 취약점을 악용할 수 있는지 단계별로 설명하세요.
-->

공격자는 withdraw 함수의 순서를 악용하여 재진입 공격을 할 수 있다.
1. 공격자는 먼저 deposit()으로 소액을 입금 후 withdraw(amount)를 호출
2. VulnerableVault는 withdraw의 내부 call로 공격자에게 ETH 전송 (EVM은 싱글 스레드, 동기적 실행 구조로 콜스택 모두 완료까지 차감 대기) 
3. call로 ETH를 받은 공격자는 미리 하나의 트랜잭션으로 구성해놓은 receive() 함수로 withdraw를 재호출
4. 두 번째 호출에 의해 withdraw는 require문 실행
5. 첫 호출에서 잔액이 아직 차감되지 않았으므로 require(balances[msg.sender] >= amount)를 통과
6. VulnerableVault는 withdraw의 내부 call로 공격자에게 ETH 전송 (반복)

공격자가 재호출하는 방식으로 정의한 receive()로 특정 함수를 호출할 경우, 컨트랙트의 외부 호출(ETH 전송)이 내부에서 또 다른 호출을 유발할 수 있고, 이때 이전 호출에 의한 상태 변화가 또 다른 호출 후에 일어나는 구조라면 Checks를 항상 통과한다는 것을 이용할 수 있다.


**3) 올바른 수정 방법 (CEI 패턴):**
```solidity
// GOOD CODE - CEI 패턴으로 수정하세요
function withdraw(uint256 amount) public {

    // 잔액 차감
    balances[msg.sender] -= amount;

    // ETH 전송
    (bool success, ) = msg.sender.call{value: amount}("");
    require(success, "Transfer failed");

}
```

---

## 문제 7: [코드] CEI 패턴 구현 (빈칸 채우기)

다음 코드의 빈칸을 채워 CEI 패턴을 완성하세요:

```solidity
function secureWithdraw(uint256 amount) public {
    // 1. Checks - 조건 확인
    require(balances[msg.sender] >= amount, "Insufficient balance");

    // 2. Effects - 상태 변경 (외부 호출 전에!)
    balances[msg.sender] -= amount;;

    // 3. Interactions - 외부 호출 (마지막에!)
    (bool success, ) = msg.sender.call{value: amount}("");
    require(success, "Transfer failed");
}
```

**답변:**
```solidity
// 빈칸을 채운 완성 코드를 작성하세요
```

**왜 이 순서가 중요한가요:**
<!--
CEI 순서가 재진입을 어떻게 방지하는지 설명하세요.
-->
상태를 먼저 바꾼 뒤 외부와 상호작용하므로 재진입이 발생하더라도 이전 호출에서 이미 업데이트된 상태를 기준으로 Checks를 진행함으로써 함수가 호출될때마다 항상 올바른 상태를 기준으로 검증이 이루어지도록 보장한다.

---

## 문제 8: [코드] tx.origin 취약점 (취약점 찾기)

다음 코드에서 보안 취약점을 찾으세요:

```solidity
// BAD CODE - 취약점 찾기
contract PhishingVulnerable {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function transferOwnership(address newOwner) public {
        require(tx.origin == owner, "Not owner");
        owner = newOwner;
    }
}
```

**1) 발견한 취약점:**
<!--
tx.origin과 msg.sender의 차이와 관련된 문제입니다.
-->


**2) 공격 시나리오:**
<!--
공격자가 어떻게 이 취약점을 악용할 수 있나요?
힌트: 공격자 컨트랙트를 통한 우회
-->
tx.origin은 트랜잭션의 발신주소(EOA)를 msg.sender는 함수를 직접 호출한 주소(EOA, CA)를 의미한다. 공격자가 위 컨트랙트의 transferOwnership를 외부 호출하도록 receive 함수를 정의한 스마트 컨트랙트 PhisingOwner를 만들었다고 하자. 위 컨트렉트의 owner가 PhisingOwner로 송금 트랜잭션을 보내는 것만으로도 transferOwnership이 문제없이 완료되어 owner가 PhisingOwner의 주소로 바뀔 수 있다.

**3) 올바른 수정 방법:**
```solidity
// GOOD CODE - 수정된 코드를 작성하세요
```
contract PhishingVulnerable {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function transferOwnership(address newOwner) public {
        require(msg.sender == owner, "Not owner");
        owner = newOwner;
    }
}
---

## 문제 9: [코드] ReentrancyGuard 적용 (빈칸 채우기)

다음 코드의 빈칸을 채워 ReentrancyGuard를 적용하세요:

```solidity
// TODO: OpenZeppelin import
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

// TODO: 상속 추가
contract SecureVault is ReentrancyGuard {
    mapping(address => uint256) public balances;

    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    // TODO: modifier 추가
    function withdraw(uint256 amount) public is nonReentrant {
        require(balances[msg.sender] >= amount, "Insufficient");
        balances[msg.sender] -= amount;
        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Failed");
    }
}
```

**답변:**
```solidity
// 빈칸을 채운 완성 코드를 작성하세요
```

**CEI 패턴 vs ReentrancyGuard - 언제 무엇을 사용하나요:**
<!--
두 방법의 장단점을 설명하세요.
-->
CEI 패턴은 재진입한 후 재호출된 함수의 Checks 단계에서 걸러지는 것이고 ReentrancyGuard는 Lock을 사용해 이미 호출된 함수가 종료 전에 재호출되는 것을 방지해 재진입 자체를 막는 것이다.

CEI 패턴의 장점으로는 Lock과 같은 상태 변수 도입없이 논리적으로 재진입을 막아 가스 효율적이라는 점과 외부 라이브러리 의존성이 없다는 점이 있으나 개발자가 논리적 흐름을 따라가며 순서를 직접 관리해야하므로 실수 가능성이 존재한다는 단점이 존재한다.

ReentrancyGuard는 명시적인 모듈로 제공되는 라이브러리로 이미 검증되어 안전하고 개발자의 실수로부터 안전하다는 장점이 존재하지만 외부 컨트랙트를 호출하는 만큼 가스 비용이 추가되고 독립성이 떨어진다는 단점이 있다.

---

## 문제 10: [다이어그램] 재진입 공격 흐름 해석 (다이어그램 분석)

다음 재진입 공격 시퀀스 다이어그램을 분석하세요:

```mermaid
sequenceDiagram
    participant A as 공격자
    participant V as VulnerableVault

    Note over A,V: 초기 상태: Vault 잔액 10 ETH, 공격자 예치금 1 ETH

    A->>V: 1. withdraw(1 ether) 호출
    V->>V: 2. require 통과 (잔액 1 ETH >= 1 ETH)
    V->>A: 3. call{value: 1 ether}() - ETH 전송
    Note over A: 4. receive() 트리거됨
    A->>V: 5. receive()에서 다시 withdraw(1 ether) 호출
    V->>V: 6. require 통과 (잔액 아직 1 ETH!)
    V->>A: 7. 또 1 ETH 전송
    Note over A: 8. 반복...
    Note over V: 9. Vault 잔액 0이 될 때까지 반복
    V->>V: 10. 최종: balances[attacker] -= 1 ether (여러 번 실행됨)
```

**질문 1:** 6번에서 require 체크가 통과하는 이유는 무엇인가요?

**답변:**
<!--
상태 변경(balances 차감)이 언제 일어나는지 확인하세요.
-->
receive로 withdraw를 재호출한 시점은 첫 withdraw 진입 시 Interactions 부분이라 아직 상태 변경 코드(balances[attacker] -= 1 ether) 실행 전이기 때문이다.

**질문 2:** CEI 패턴을 적용하면 6번에서 어떻게 되나요?

**답변:**
<!--
상태 변경 순서가 바뀌면 어떤 차이가 생기는지 설명하세요.
-->
balances[attacker] -= 1 ether 코드에 의해 이미 잔액이 0인 상태에서 재진입한 것이므로 require(balances[msg.sender]< amount)를 통과하지 못하고 revert 된다.

**질문 3:** 공격자가 총 몇 ETH를 탈취할 수 있나요? (예치금 1 ETH, Vault 총 잔액 10 ETH 가정)

**답변:**
<!--
공격 시나리오를 수치로 분석해 보세요.
-->
첫번째 withdraw 내부에서 공격자 예치금이 1인 상태를 유지하며 receive를 매개로 withdraw 재귀 호출이 일어나므로 receive 함수의 withdraw 호출 조건에 따라 탈취 금액이 달라진다. 

receive() external payable {
    if (address(vault).balance >= 1 ether) {
        vault.withdraw(1 ether);
        }
    } 
예를 들어 receive가 위와 같이 정의되었다면 탈취 금액은 다음과 같다.

             Vault
               10
1. withdraw    9
2. withdraw    8
3. withdraw    7
...
10. withdraw   0

총 10번의 withdraw 호출로 10ETH를 탈취할 수 있다.

---

## 자기 평가

모든 문제를 풀었다면, 아래 체크리스트로 자기 평가를 해보세요:

- [v] EVM의 결정론적 실행 필요성을 이해했다
- [v] Storage/Memory/Stack의 차이와 비용을 알고 있다
- [v] 재진입 공격의 원리를 설명할 수 있다
- [v] CEI 패턴으로 재진입 공격을 방어할 수 있다
- [v] tx.origin vs msg.sender의 보안 차이를 알고 있다
- [v] ReentrancyGuard를 적용할 수 있다

---

## 참고 자료

- 이론: `eth-materials/week-03/theory/slides.md`
- 취약한 코드: `eth-homework/week-03/dev/src/Vault.sol`
- 안전한 코드: `eth-homework/week-03/dev/src/VaultSecure.sol`
- 테스트: `eth-homework/week-03/dev/test/Vault.t.sol`
- 용어: `eth-materials/resources/glossary.md`
