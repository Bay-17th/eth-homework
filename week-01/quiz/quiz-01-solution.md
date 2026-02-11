# Week 1 퀴즈: State/Account + Solidity 기초

**제출 방법:**
1. 이 파일을 복사하여 `quiz-01-solution.md`로 저장
2. 각 문제에 답변 작성 (왜 그런지 설명 포함)
3. Pull Request 생성 (`quiz_submission` 템플릿 사용)

**평가 기준:**
- 정답 여부보다 **개념 이해도**를 중점 평가합니다
- "왜"에 대한 설명이 충분한지 확인합니다
- 문법 오류는 크게 감점하지 않습니다

---

## 문제 1: [이론] 상태 머신 (객관식)

이더리움에서 "상태 전이가 원자적(atomic)이다"라는 말의 의미를 가장 잘 설명한 것은?

다음 상황을 고려하세요:

```
Alice가 Bob에게 1 ETH를 보내는 트랜잭션을 실행합니다.
중간에 가스가 부족해져서 트랜잭션이 실패했습니다.
```

**보기:**
A) Alice의 잔액만 감소하고 Bob의 잔액은 변하지 않는다
B) Alice의 잔액과 Bob의 잔액 모두 변하지 않고, 가스비만 소모된다
C) 네트워크가 자동으로 부족한 가스를 보충해서 트랜잭션을 완료한다
D) 트랜잭션이 절반만 실행되어 0.5 ETH만 전송된다

**답변:**
<!--
정답 알파벳을 적고, 왜 이 답을 선택했는지 설명하세요.
"원자적"이라는 것이 실제로 어떤 의미인지 설명해 주세요.
-->
B) / Tx Execution이 끝까지 성공하면 State가 S -> S'이 된다. 이 State 전이가 원자적이기 때문에 Tx이 실패하니 Execution에 가스비가 소모되고 상태변화는 없으니 State는 유지된다

---

## 문제 2: [이론] 결정론적 실행 (객관식)

이더리움 EVM이 "결정론적(deterministic)"으로 실행된다는 것의 핵심 이유는 무엇인가요?

**보기:**
A) 모든 노드가 같은 하드웨어를 사용해야 해서
B) 같은 입력(트랜잭션)이 주어지면 모든 노드가 같은 결과(상태)를 도출해야 하므로
C) 중앙 서버가 모든 계산을 수행하고 결과를 배포해서
D) 트랜잭션이 항상 1초 안에 처리되어야 해서

**답변:**
<!--
정답과 함께, "결정론적이지 않으면" 어떤 문제가 발생하는지 설명하세요.
예: 노드 A와 노드 B가 다른 결과를 얻으면 어떻게 될까요?
-->
B) / 같은 입력에 대해 모든 노드들은 항상 같은 State를 계산해야 하므로 EVM은 결정론적으로 Execute한다. 결정론적이지 않으면 노드마다 서로 다른 결과를 내어 합의를 할 수 있고, 체인이 포크되거나 할 수 있다.

---

## 문제 3: [이론] EOA vs CA (객관식)

다음 중 EOA(Externally Owned Account)와 CA(Contract Account)의 차이를 올바르게 설명한 것은?

**보기:**
A) EOA는 코드를 실행할 수 있고, CA는 코드를 실행할 수 없다
B) EOA만 트랜잭션을 시작할 수 있고, CA는 EOA에 의해 호출될 때만 실행된다
C) CA만 ETH를 보유할 수 있고, EOA는 ETH를 보유할 수 없다
D) EOA와 CA는 동일한 기능을 가지며 이름만 다르다

**답변:**
<!--
정답과 함께, "왜 CA는 트랜잭션을 시작할 수 없나요?"에 대해 설명하세요.
힌트: 트랜잭션을 시작하려면 무엇이 필요한가요?
-->

B) / EOA만 Private Key를 소우하고 있기 때문에 Tx를 직접 실행할 수 있고, CA는 코드만 갖고있기 때문에 스스로 Tx를 Execute 할 수 없어서 다른 CA나 EOA에 의해 호출될 때만 Execute된다
CA는 Private Key가 없어 서명이 불가하다. 그래서 Tx를 스스로 시작할 수 없고 항상 외부에서 들어오는 메세지에 반응하는 형태로만 동작한다.


---

## 문제 4: [이론] 계정 상태 필드 (객관식)

이더리움 계정 상태의 4가지 필드 중 `nonce`의 역할을 올바르게 설명한 것은?

다음 상황을 고려하세요:

```
Alice의 현재 nonce: 5
Alice가 두 개의 트랜잭션을 동시에 전송합니다:
- TX-A: nonce=5, Bob에게 1 ETH 전송
- TX-B: nonce=5, Charlie에게 2 ETH 전송
```

**보기:**
A) 두 트랜잭션 모두 성공적으로 처리된다
B) TX-A만 처리되고 TX-B는 무시된다 (또는 그 반대)
C) 두 트랜잭션 모두 실패하고 Alice의 자산이 동결된다
D) 네트워크가 자동으로 TX-B의 nonce를 6으로 변경한다

**답변:**
<!--
정답과 함께, nonce가 "트랜잭션 재사용 공격"을 어떻게 방지하는지 설명하세요.
-->

B) Ethereum에서의 Nonce는 EOA별로 Re-Execution Attack과 Double-Spending 방지를 위해 Tx Count를 Nonce로 기록한다. 그래서 Nonce = 5에 대해서는 Tx A 혹은 B만 Execution된다.

---

## 문제 5: [이론] World State (객관식)

World State에 대한 설명 중 올바른 것은?

**보기:**
A) World State는 최신 100개 블록의 트랜잭션만 저장한다
B) World State는 모든 계정의 현재 상태(주소 -> 상태 매핑)를 나타낸다
C) World State는 EOA의 정보만 저장하고 CA 정보는 별도로 관리한다
D) World State는 각 노드마다 다른 값을 가질 수 있다

**답변:**
<!--
정답과 함께, World State가 "전화번호부"에 비유되는 이유를 설명하세요.
-->

B) / World State는 Ethereum 네트워크에 존재하는 모든 계정(EOA + CA)에 대한 현재 State를 담고있는 Global State다. 전화번호부의 mapping은 (이름 : 전화번호) 형태이고 이에 빗대어 World State는 (Account : Current State) 형태로 되어있다.

---

## 문제 6: [이론] 상태 변수 vs 지역 변수 (단답형)

Solidity에서 `상태 변수(state variable)`와 `지역 변수(local variable)`의 차이는 무엇인가요?

다음 코드를 보고 설명하세요:

```solidity
contract Example {
    uint256 public count;  // 이것은 무엇인가요?

    function calculate(uint256 input) public pure returns (uint256) {
        uint256 result = input * 2;  // 이것은 무엇인가요?
        return result;
    }
}
```

**답변:**
<!--
두 변수의 차이점을 설명하세요.
특히 다음 관점에서 비교해 주세요:
1. 저장 위치 (Storage vs Memory)
2. 지속성 (트랜잭션 종료 후에도 유지되는가?)
3. 비용 (어느 것이 더 비싼가?)
-->

1. 상태변수는 Storage(블록체인 영구 저장)에 지역변수는 Memory(임시 메모리)에 저장된다
2. 상태 변수는 영원히 체인위에 기록, 지역변수는 함수 실행 단위로 생성 및 삭제된다
3. 상태 변수가 지역 변수보다 비용이 훨씬 많이 든다

---

## 문제 7: [이론] 원자성의 이유 (단답형)

이더리움에서 트랜잭션이 "원자적(atomic)"으로 처리되어야 하는 이유는 무엇인가요?

**왜** 부분적으로 성공하는 트랜잭션을 허용하면 문제가 될까요? 구체적인 예시와 함께 설명하세요.

**답변:**
<!--
2-3 문장으로 설명하세요.
힌트: 송금 트랜잭션이 "절반만 성공"하면 어떤 일이 벌어질까요?
누군가의 잔액이 갑자기 사라지거나 생기면 어떻게 될까요?
-->

트랜잭션은 원자적으로 처리되어야 State 변화가 전부 처리되거나 혹은 롤백된다. 송금 트랜잭션을 실행하는데 송금자의 잔액이 줄고 수신자의 잔액이 늘지 않았다면 State 불일치가 발생하기 때문에 네트워크 전체 합의가 깨지는 문제가 발생한다

---

## 문제 8: [이론] 계정 구조 설명 (단답형)

EOA에는 `codeHash`와 `storageRoot`가 왜 의미가 없나요?

**답변:**
<!--
EOA와 CA의 구조적 차이를 설명하면서 답변하세요.
힌트: EOA에 코드가 있나요? 저장소가 필요한가요?
-->

EOA에는 코드가 없고 State Variable을 저장하지 않는다. 그렇기 때문에 codeHash, storageRoot 모두 빈 값이다. CA는 Code, State Variable이 있기 때문에 모두 가진다.

---

## 문제 9: [코드] Counter 읽기 (코드 읽기)

다음 Counter.sol 코드를 분석하세요:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract Counter {
    uint256 public count;

    function getCount() public view returns (uint256) {
        return count;
    }

    function increment() public {
        count += 1;
    }

    function decrement() public {
        require(count > 0, "Count cannot go below zero");
        count -= 1;
    }
}
```

**1) `public` 키워드의 역할:**
`count` 변수에 `public`이 붙으면 어떤 일이 자동으로 일어나나요?

**답변:**
<!--
자동 생성되는 것이 무엇인지 설명하세요.
-->

Compiler가 getter()를 자동으로 생성해서 외부에서 해당 State Variable를 읽을 수 있도록 한다.
그래서 별도의 read function을 생성하지 않아도 된다.


**2) `view` 키워드의 의미:**
`getCount()` 함수에 `view`가 붙은 이유는 무엇인가요? `view`를 제거하면 어떻게 될까요?

**답변:**
<!--
view 함수의 특성을 설명하세요.
-->

읽기 전용을 사용하는 키워드. 단순 State Variable read를 위함인데 view가 없으면 Tx로 처리돼서 Gas 비용이 낭비가 된다.

---

## 문제 10: [코드] Counter 동작 예측 (코드 읽기)

위의 Counter 컨트랙트에서 다음 시나리오를 분석하세요:

**시나리오:**
```
초기 상태: count = 0

1. increment() 호출
2. increment() 호출
3. decrement() 호출
4. decrement() 호출
5. decrement() 호출
```

**질문 1:** 5번째 `decrement()` 호출의 결과는 무엇인가요?

**답변:**
<!--
성공/실패 여부와 그 이유를 설명하세요.
-->

4번 함수 실행이 끝났을 때 count의 값은 0이다
그리고 5번함수가 실행되면 require(count > 0, ...) 조건에 걸리기 때문에
Tx이 Revert되고 전체 롤백되므로 count는 0이다


**질문 2:** 왜 `decrement()` 함수에 `require(count > 0, ...)` 조건이 필요한가요?

**답변:**
<!--
이 조건이 없으면 어떤 문제가 발생하는지 설명하세요.
힌트: uint256의 특성을 고려하세요.
-->

uint256의 정수 범위는 0~2^256 - 1이기 때문에 자료형 문제로 Underflow같은 현상이 발생할 수 있다

---

## 자기 평가

모든 문제를 풀었다면, 아래 체크리스트로 자기 평가를 해보세요:

- [x] 상태 머신과 원자성 개념을 이해했다
- [x] EOA와 CA의 차이를 설명할 수 있다
- [x] 계정 상태의 4가지 필드(nonce, balance, storageRoot, codeHash)를 이해했다
- [x] Solidity 기본 문법(public, view, require)을 이해했다
- [x] 상태 변수와 지역 변수의 차이를 설명할 수 있다

---

## 참고 자료

- 이론: `eth-materials/week-01/theory/slides.md`
- 코드: `eth-homework/week-01/dev/src/Counter.sol`
- 용어: `eth-materials/resources/glossary.md`
