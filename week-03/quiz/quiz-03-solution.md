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
 정답 - B / 이더리움은 하나의 거대한 State machine이기 때문에 모든 노드가 합의에 이르려면 동일한 상태를 공유, 유지해야합니다. 만약 노드 A, B가 동일한 트랜잭션을 실행시켰을때 다른 결과가 나온다면 합의에 이르지 못할 것이기 때문입니다.

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
 정답 - B / 매개변수에 memory가 명시되어 있으므로 data는 memory에 저장됩니다.
Storage는 가장 비싸고  Stack이 가장 싸고 Memory는 Stack보다 조금 더 비싼 정돕니다. Storage가 가장 비싼 이유는 블록체인에 영구적으로 저장되며 모든 노드가 이를 유지해야하기 때문입니다.

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
정답 - D / Storage는 모든 노드가 영구적으로 저장하고 유지해야 하는 데이터이기 때문에 비쌉니다.

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
외부 호출을 하면 상대방 컨트랙트의 receive() 또는 fallback()이 실행됩니다. 그 안에서 다시 내 함수를 호출한다면 Effects가 아직 안 되어 있으므로 require 잔액 검증을 통과해버려서 재진입이 성공해버립니다. 하지만 CEI 패턴에서 Effects를 먼저 하면 재진입시 잔액이 이미 0으로 줄어있어 require에서 revert됩니다.

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
- 기술적 교훈 : 외부 호출 이후에 상태를 변경하는 코드 패턴은 단 하나의 취약점이지만 엄청난 손실로 이끌 수 있다는 것을 배웠습니다. 이후에 CEI 패턴과 ReentrancyGuard가 표준으로 자리잡았습니다.

- 생태계 교훈 : 이 사건 이후에 이더리움 커뮤니티는 블록체인을 하드포크했고 이에 반대한 측이 Ethereum Classic으로 분리되었습니다.

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

        // ETH 전송
        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Transfer failed");

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
withdraw 함수에서 CEI 패턴을 위반하고 있습니다. call이 잔액 차감보다 먼저 실행됩니다.

**2) 왜 이것이 문제인가:**
<!--
공격자가 어떻게 이 취약점을 악용할 수 있는지 단계별로 설명하세요.
-->
공격자가 1 ETH 입금
withdraw(1 ether) 호출 → require 통과 
call로 공격자에게 1 ETH 전송 → 공격자의 receive() 실행
receive() 안에서 다시 withdraw(1 ether) 호출
balances가 아직 차감되지 않았으므로 require 또 통과
Vault 잔액이 0이 될 때까지 반복

**3) 올바른 수정 방법 (CEI 패턴):**
```solidity
// GOOD CODE - CEI 패턴으로 수정하세요
function withdraw(uint256 amount) public {
    // Checks
    require(balances[msg.sender] >= amount, "Insufficient balance");

    // Effects 먼저
    balances[msg.sender] -= amount;

    // Interactions 나중에
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
    require(______________________, "Insufficient balance");

    // 2. Effects - 상태 변경 (외부 호출 전에!)
    ______________________;

    // 3. Interactions - 외부 호출 (마지막에!)
    (bool success, ) = msg.sender.call{value: ______}("");
    require(success, "Transfer failed");
}
```

**답변:**
```solidity
function secureWithdraw(uint256 amount) public {
    // 1. Checks - 조건 확인
    require(balances[msg.sender] >= amount, "Insufficient balance");

    // 2. Effects - 상태 변경 (외부 호출 전에!)
    balances[msg.sender] -= amount;

    // 3. Interactions - 외부 호출 (마지막에!)
    (bool success, ) = msg.sender.call{value: amount}("");
    require(success, "Transfer failed");
}
```

**왜 이 순서가 중요한가요:**
<!--
CEI 순서가 재진입을 어떻게 방지하는지 설명하세요.
-->
재진입 공격자가 call 도중 다시 이 함수를 호출해도, Effects 단계에서 이미 balances[msg.sender]가 0으로 줄어 있으므로 require(0 >= amount)에서 revert됩니다. 상태가 먼저 바뀌어 있으므로 두 번째 인출이 원천 차단됩니다.

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
tx.origin을 사용한 권한 검증입니다. tx.origin은 트랜잭션을 최초로 시작한 EOA이고, msg.sender는 직접 이 함수를 호출한 주소입니다.

**2) 공격 시나리오:**
<!--
공격자가 어떻게 이 취약점을 악용할 수 있나요?
힌트: 공격자 컨트랙트를 통한 우회
-->
공격자가 악성 컨트랙트(AttackContract)를 배포
owner를 속여서 AttackContract의 어떤 함수를 호출하게 유도 (예: "이 컨트랙트에서 에어드랍 받으세요")
AttackContract 내부에서 PhishingVulnerable.transferOwnership 호출
이때 tx.origin == owner(최초 서명자는 owner)이므로 require 통과
msg.sender는 AttackContract이지만 tx.origin은 owner이므로 권한 검증이 통과됨
ownership이 공격자로 넘어감

**3) 올바른 수정 방법:**
```solidity
// GOOD CODE - 수정된 코드를 작성하세요
function transferOwnership(address newOwner) public {
    require(msg.sender == owner, "Not owner");
    owner = newOwner;
}
```

---

## 문제 9: [코드] ReentrancyGuard 적용 (빈칸 채우기)

다음 코드의 빈칸을 채워 ReentrancyGuard를 적용하세요:

```solidity
// TODO: OpenZeppelin import
______________________________________

// TODO: 상속 추가
contract SecureVault _________________ {
    mapping(address => uint256) public balances;

    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    // TODO: modifier 추가
    function withdraw(uint256 amount) public _________________ {
        require(balances[msg.sender] >= amount, "Insufficient");
        balances[msg.sender] -= amount;
        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Failed");
    }
}
```

**답변:**
```solidity
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract SecureVault is ReentrancyGuard {
    mapping(address => uint256) public balances;

    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    // TODO: modifier 추가
    function withdraw(uint256 amount) public nonReentrant {
        require(balances[msg.sender] >= amount, "Insufficient");
        balances[msg.sender] -= amount;
        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Failed");
    }
}
```

**CEI 패턴 vs ReentrancyGuard - 언제 무엇을 사용하나요:**
<!--
두 방법의 장단점을 설명하세요.
-->
- CEI 패턴의 장점은 첫번째로 가스 측면에서 효율적입니다. 추가적인 상태 변수나 연산이 없으므로 오버헤드 부담이 없지만 ReentrancyGuard는 매 함수 호출마다 상태 변수를 읽고 써야합니다.
- CEI 패턴은 외부 의존성이 없습니다. OpenZeppelin같은 외부 라이브러리를 import할 필요가 없어서 라이브러리에 버그가 생기거나 업데이트가 필요할 때 영향을 받지 않습니다. 
- CEI 패턴의 단점은 개발자가 실수를 할 수도 있다는 것입니다. 2016년 The DAO 해킹 사건이 이의 대표적인 예시입니다. 하지만 ReentrancyGuard는 이러한 실수에서 자유롭습니다. nonReentrant modifier 하나만 붙이면 끝이여서 내부 로직 순서와 무관하게 재진입 자체를 원천 차단합니다.

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
balances[msg.sender] -= amount가 call 이후에 있기 때문입니다. 3번에서 ETH를 전송했지만 잔액은 아직 차감되지 않았으므로 5번에서 다시 withdraw를 호출했을 때 balances[attacker]는 여전히 1 ETH입니다. 그래서 6번의 require(1 ether >= 1 ether)가 통과됩니다.

**질문 2:** CEI 패턴을 적용하면 6번에서 어떻게 되나요?

**답변:**
<!--
상태 변경 순서가 바뀌면 어떤 차이가 생기는지 설명하세요.
-->
CEI 패턴에서는 2번 require 통과 직후 balances[attacker]를 0으로 먼저 차감합니다. 그러면 5번에서 다시 withdraw를 호출할 때 6번의 require(0 >= 1 ether)가 false가 되어 즉시 revert됩니다. 재진입 시도가 첫 번째에서 차단됩니다.

**질문 3:** 공격자가 총 몇 ETH를 탈취할 수 있나요? (예치금 1 ETH, Vault 총 잔액 10 ETH 가정)

**답변:**
<!--
공격 시나리오를 수치로 분석해 보세요.
-->
공격자 예치금: 1 ETH
Vault 총 잔액: 10 ETH (자신의 1 ETH + 타인의 9 ETH)

재진입 반복:
1회: 1 ETH 전송 (Vault 잔액 9 ETH, balances 아직 1 ETH)
2회: 1 ETH 전송 (Vault 잔액 8 ETH)
...
10회: 1 ETH 전송 (Vault 잔액 0 ETH)

총 탈취: 10 ETH (자기 1 ETH + 타인 9 ETH)
공격자는 1 ETH를 입금하고 10 ETH를 탈취합니다

---

## 자기 평가

모든 문제를 풀었다면, 아래 체크리스트로 자기 평가를 해보세요:

- [x] EVM의 결정론적 실행 필요성을 이해했다
- [x] Storage/Memory/Stack의 차이와 비용을 알고 있다
- [x] 재진입 공격의 원리를 설명할 수 있다
- [x] CEI 패턴으로 재진입 공격을 방어할 수 있다
- [x] tx.origin vs msg.sender의 보안 차이를 알고 있다
- [x] ReentrancyGuard를 적용할 수 있다

---

## 참고 자료

- 이론: `eth-materials/week-03/theory/slides.md`
- 취약한 코드: `eth-homework/week-03/dev/src/Vault.sol`
- 안전한 코드: `eth-homework/week-03/dev/src/VaultSecure.sol`
- 테스트: `eth-homework/week-03/dev/test/Vault.t.sol`
- 용어: `eth-materials/resources/glossary.md`
