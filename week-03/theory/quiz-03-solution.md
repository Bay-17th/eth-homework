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
B,EVM에서 합의가 가능하려면 같은 입력을 넣었을 때 같은 출력이 나와야 모든 노드들이 같은 결과로 검증이 가능하다.
하지만 랜덤함수를 쓴다면, 모든 노드들이 같은 입력에 다른 출력을 가지게 될 수도 있다.
그리고, 외부 API내부에 입력을 넣어도 다른 출력이 나오는 로직이 포함 되어 있거나 api를 제공하는 서버의 로직이 바뀌면 이 또한 결정론적이지 않다.


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
B,
Storage는 블록체인에 영구저장되는 상태에 기록된다. 그래서 쓰기가 비싸다.(모든 풀노드가 영구히 저장해야하기 때문)
Memory는 함수 실행 중에만 존재하고, 비교적 저렴하다. 함수가 끝나면 휘발된다.
Stack은 로컬 변수와 연산 중간값을 저장한다. 32바이트 단위이며 가장 빠르고 저렴하다. 단, 배열이나 struct는 저장할 수 없다. 
그래서 Storage>Memory>Stack순으로 비싸다. 

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
D, SSTORE 연산은 이더리움의 전역 상태를 변경하는 연산이다.상태 트리를 수정하고 상태루트의 영향을 준다.
모든 노드가 변경을 저장해야 하므로 가스 비용이 가장 높다


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
Effects를 먼저 실행하고 Interactions를 수행하는 이유는 외부 호출 전에 상태를 변경해 재진입 공격을 방지하기 위해서이다.
외부 호출을 먼저 하면 상대 컨트랙트의 코드가 실행되면서 다시 원래 함수를 호출할 수 있다.
이때 상태가 아직 변경되지 않았다면 동일한 조건이 유지되어 자금을 반복적으로 인출하는 재진입 공격이 발생할 수도 있다.


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
기술적 교훈은 상태를 먼저 변경하고 외부 호출을 해야한다는 것이고 스마트컨트랙트를 배포하면 바꿀 수 없으므로 배포하기 전에 보안 검증을 꼭 해야한다는 것이다. 이후 이더리움 생태계는 하드포크를 하여 자금을 복구했고, 이 때 하드포크를 진행한 이더리움은 현재의 이더리움이 그대로 반영한 블록체인은 이더리움 클래식으로 분리되었다.이 이후 보안에 대한 인식이 강화되었다.


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
현재는 (Checks-Interactions-Effects)로 동작하여 CEI패턴을 어겼다, Interaction을 한 후 잔액을 차감한다.
150번째 줄에 있는 로직을 146번째 줄보다 먼저 수행해야한다.


**2) 왜 이것이 문제인가:**
<!--
공격자가 어떻게 이 취약점을 악용할 수 있는지 단계별로 설명하세요.
-->
이렇게하면 잔액을 차감하기전에 withdraw가 또 호출되어 계속해서 인출이 가능해진다(Reentrancy 공격 취약점 존재).


**3) 올바른 수정 방법 (CEI 패턴):**
```solidity
// GOOD CODE - CEI 패턴으로 수정하세요
function withdraw(uint256 amount) public {
    // 여기에 안전한 코드를 작성하세요
    require(balances[msg.sender] >= amount, "Insufficient balance");

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
// 빈칸을 채운 완성 코드를 작성하세요
function secureWithdraw(uint256 amount) public{
    require(balances[msg.sender]>=amount,"Insufficient balance");
    balances[msg.sender]-=amount;
    (bool success,) = msg.sender.call{value:amount}("");
    require(success,"Transfer failed")
}
```

**왜 이 순서가 중요한가요:**
<!--
CEI 순서가 재진입을 어떻게 방지하는지 설명하세요.
-->
balance를 먼저 감소시키고 Effects를 발생시키므로 
재진입을 한다면 balance는 이미 줄어든 상태라 의미가 없어진다.


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
EOA->CA->CA 순으로 호출되는 경우
tx.orgin은 EOA의 주소이고 msg.sender은 CA의 주소이다.
즉 tx.origin은 가장 먼저 트랜잭션을 시작한 주소
msg.sender은 바로 직전에 보낸 주소이다.

**2) 공격 시나리오:**
<!--
공격자가 어떻게 이 취약점을 악용할 수 있나요?
힌트: 공격자 컨트랙트를 통한 우회
-->
Alice가 저 트랜잭션의 Owner라고 하자.
공격자가 공격 컨트랙트를 만든다.
이 공격트랜잭션은 transferOwnership(공격자의 address)을 호출한다.
공격자가 Alice를 속여 이 컨트랙트를 호출하게 하면
이 컨트랙트는 다시 transferOwnership을 호출하게된다.
그러면 이때 tx.origin은 Alice기 때문에 require(tx.origin == owner, "Not owner");를 통과하게 되고
owner이 공격자의 address로 바뀐다.



**3) 올바른 수정 방법:**
```solidity
// GOOD CODE - 수정된 코드를 작성하세요
contract PhishingVulnerable{
    address public owner;
    constructor(){
        owner = msg.sender;
    }
    function transferOwnership(address newOwner) public{
        require(msg.sender == owner, "Not owner");
        owner = newOwner;
    }
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
// 빈칸을 채운 완성 코드를 작성하세요
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
contract SecureVault is ReentrancyGuard{
    mapping(address => uint256) public balances;

    function deposit() public payable{
        balances[msg.sender] += msg.value;
    }
    function withdraw(uint256 amount) public nonReentrant{
        require(balances[msg.sender]>=amount,"Insufficient");
        balances[msg.sender] -= amount;
        (bool success, ) = msg.sender.call{value:amount}("");
        require(success, "Failed");
    }
}

```

**CEI 패턴 vs ReentrancyGuard - 언제 무엇을 사용하나요:**
<!--
두 방법의 장단점을 설명하세요.
-->
CEI 패턴은 ReentrancyGuard에 비해 가스가 적게 소모된다.
하지만, 컨트랙트의 코드가 길어지고 로직이 복잡해져 실수가 나온다면, 굉장히 큰 피해를 보게 된다.
기본적으로 CEI를 만족하게 코드를 작성해야겠지만 복잡하거나 돈이 오가는 코드에는 ReentrancyGuard를 씌워주는 것이 안전하다.


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
상태변경이 외부호출(call) 이후에 일어나기 때문에 재진입 시점에는 balances가 아직 감소하지 않은 상태이다.
따라서 require 조건이 계속 통과하게 된다.


**질문 2:** CEI 패턴을 적용하면 6번에서 어떻게 되나요?

**답변:**
<!--
상태 변경 순서가 바뀌면 어떤 차이가 생기는지 설명하세요.
-->
balances를 먼저 줄이고 외부호출(call)이 일어나기 때문에 require을 통과하지 못한다. 


**질문 3:** 공격자가 총 몇 ETH를 탈취할 수 있나요? (예치금 1 ETH, Vault 총 잔액 10 ETH 가정)

**답변:**
<!--
공격 시나리오를 수치로 분석해 보세요.
-->
예치금은 1 ETH 지만, 상태 변경이 외부호출(call)이후에 일어나기 때문에 재진입을 계속해서
Vault 의 잔액이 0이 될 때까지 반복할 수 있다.
따라서 10 ETH를 탈취할 수 있다.
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
