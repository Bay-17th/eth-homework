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
# B) Alice의 잔액과 Bob의 잔액 모두 변하지 않고, 가스비만 소모된다
C) 네트워크가 자동으로 부족한 가스를 보충해서 트랜잭션을 완료한다
D) 트랜잭션이 절반만 실행되어 0.5 ETH만 전송된다

**답변:**
<!--
정답 알파벳을 적고, 왜 이 답을 선택했는지 설명하세요.
"원자적"이라는 것이 실제로 어떤 의미인지 설명해 주세요.
-->
B. 이유는 atomic 특성상 transaction 과정에서 단계가 하나라도 성립하지 않는다면, 그 transaction은 유효하지 않은 것이 된다.
그렇기 때문에 transaction은 취소되며, gas비는 몰수된다. 
몰수되는 이유는 validator가 transaction을 검증해야 하므로 이 과정에서 발생하는 임금?의 개념으로 지불해야되기 때문이다. 

'원자적'이라는 의미는 single, indivisible unit으로 여겨진다는 보장이다. 이 특성을 통해서 결과는 Full execution / the revert 이 두 상황에 대한 값만 가지게 된다. (부분적 실행은 불가능하다는 의미이다.)
---

## 문제 2: [이론] 결정론적 실행 (객관식)

이더리움 EVM이 "결정론적(deterministic)"으로 실행된다는 것의 핵심 이유는 무엇인가요?

**보기:**
A) 모든 노드가 같은 하드웨어를 사용해야 해서
# B) 같은 입력(트랜잭션)이 주어지면 모든 노드가 같은 결과(상태)를 도출해야 하므로
C) 중앙 서버가 모든 계산을 수행하고 결과를 배포해서
D) 트랜잭션이 항상 1초 안에 처리되어야 해서

**답변:**
<!--
정답과 함께, "결정론적이지 않으면" 어떤 문제가 발생하는지 설명하세요.
예: 노드 A와 노드 B가 다른 결과를 얻으면 어떻게 될까요?
-->
B
만약, 결정론적이 않으면 이러한 문제가 발생한다.
합의 붕괴 - 부동소수점 연산처럼 환경에 따라 다른 값이 나오는 경우, 어떤 노드는 블록을 유효하다고 판단하고 어떤 노드는 무효라고 판단할 수 있다. 
race condition & MEV 문제 - 순서에 따라서 transaction의 영향을 받기 쉬운 환경인데, 이러한 순서를 무시할 수도 있는 취약성이 발생한다.
smart contract trust 붕괴 - 같은 함수를 호출하더라도 같은 결과가 발생하지 않을 수 있다. 그렇게 된다면 노드A와 노드B가 다른 결과를 얻게될 수 있는 환경이 주어진다.
---

## 문제 3: [이론] EOA vs CA (객관식)

다음 중 EOA(Externally Owned Account)와 CA(Contract Account)의 차이를 올바르게 설명한 것은?

**보기:**
A) EOA는 코드를 실행할 수 있고, CA는 코드를 실행할 수 없다
# B) EOA만 트랜잭션을 시작할 수 있고, CA는 EOA에 의해 호출될 때만 실행된다
C) CA만 ETH를 보유할 수 있고, EOA는 ETH를 보유할 수 없다
D) EOA와 CA는 동일한 기능을 가지며 이름만 다르다

**답변:**
<!--
정답과 함께, "왜 CA는 트랜잭션을 시작할 수 없나요?"에 대해 설명하세요.
힌트: 트랜잭션을 시작하려면 무엇이 필요한가요?
-->
B
EOA : 사람이 소유하는 계정 - private key ✅ / transaction sign ✅
CA : 스마트 컨트랙트 계정 - private key ❌ / transaction sign ❌
transaction을 시작하려면 private key가 존재해야 하는데, 이 때 CA는 private key가 존재하지 않기에 실행할 수 없다. 그렇기에 EOA의 호출에 의해 CA가 실행된다. 
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
# B) TX-A만 처리되고 TX-B는 무시된다 (또는 그 반대)
C) 두 트랜잭션 모두 실패하고 Alice의 자산이 동결된다
D) 네트워크가 자동으로 TX-B의 nonce를 6으로 변경한다

**답변:**
<!--정답과 함께, nonce가 "트랜잭션 재사용 공격"을 어떻게 방지하는지 설명하세요.
-->
B 
nonce : number used once의 말로 n번째 transaction을 작성하는 번호표의 의미임. 
그래서 transaction이 성사될 때 nonce라는 번호표가 같이 가게 되는거고, 이 때 같은 번호표를 가지고 추가적인 거래를 제제함으로써 코인의 복제를 제제하는 것이다. 

---

## 문제 5: [이론] World State (객관식)

World State에 대한 설명 중 올바른 것은?

**보기:**
A) World State는 최신 100개 블록의 트랜잭션만 저장한다
# B) World State는 모든 계정의 현재 상태(주소 -> 상태 매핑)를 나타낸다
C) World State는 EOA의 정보만 저장하고 CA 정보는 별도로 관리한다
D) World State는 각 노드마다 다른 값을 가질 수 있다

**답변:**
<!--
정답과 함께, World State가 "전화번호부"에 비유되는 이유를 설명하세요.
-->
1. 전화번호부와 World State는 key-value 쌍으로 저장되는 부분이 비슷하다. World State같은 경우 key : Account address, value : Account state로 볼 수 있다. 
2. 전화번호가 바뀌게 된다면 내용을 덮어쓴다. World State 또한 이전의 내역을 저장하는 것이 아니고 현재의 값을 저장하기 때문에 유사한 점이 있다.
3. 전화번호를 저장할 때 사용되는 메모, 직업 등의 역할은 World State 안에 CA는 추가정보인 Code Hash, Storage Root의 정보가 존재하기 때문이다.
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
count : state variable - 1. Storage 에 저장된다.  2. 컨트랙트가 존재하는 동안  3. 매우 비쌈(모든 이더리움 노드가 이 값을 저장해야 하기 때문에 비용이 비싸다)
result : local variable - 1. Memory에 저장된다.   2. 함수 실행하는 동안만     3. 쌈
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
가장 근본적인 문제는 State inconsistency이다. 이 때 half-finished와 같은 절반만 성공하는 거래가 나올 수 있다. 이 때 내가 1ETH를 보내는 대가로 3000USDT를 받는다고 가정돼 있다면, 이 거래에서 나는 1ETH를 전송했지만, 3000USDT는 받지 못한 상태의 half-finished상태가 발생할 수 있다. 이러한 경우를 방지하는 것은 atomic을 통해서 완전한 성공 또는 완전한 실패로 transaction을 처리하는 것이다. 

---

## 문제 8: [이론] 계정 구조 설명 (단답형)

EOA에는 `codeHash`와 `storageRoot`가 왜 의미가 없나요?

**답변:**
<!--
EOA와 CA의 구조적 차이를 설명하면서 답변하세요.
힌트: EOA에 코드가 있나요? 저장소가 필요한가요?
-->
EOA : 사람의 고유키를 갖고 있는 계정. 
CA : 네트워크에 배포하는 고유키가 없는 계정.

EOA의 계정에는 잔고(balance)와 nonce만이 존재하므로 코드가 존재하지 않는다.
+ EOA에도 codeHash, storageRoot 필드는 존재함. 하지만, 실제 코드와 저장소가 없어서 비어 있는 값임. 
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
읽기 전용 함수인 getter 함수를 생성한다. 이 함수는 변수와 같은 이름을 갖고, 외부에서 값을 조회할 수 있다.


**2) `view` 키워드의 의미:**
`getCount()` 함수에 `view`가 붙은 이유는 무엇인가요? `view`를 제거하면 어떻게 될까요?

**답변:**
<!--
view 함수의 특성을 설명하세요.
-->
view 함수는 블록체인의 상태를 읽을 수는 있지만, 상태를 변경할 수는 없도록 하기 위해서이다. 
제거하게 된다면 결괏값에서는 이상은 없다. 하지만, 상태를 변경할 수 있게 되고 이를 통해 gas가 소비되는 상황이 발생한다. 이 이유는 view함수가 있다면 단순히 노드에 물어보는 eth_call형식으로 gas가 소비되지 않는 반면에 view함수가 없다면 transaction으로 실행되어 gas를 소비한다. 
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
실패하게 된다. Ethereum의 atomicity의 특성에 의하면 성공 혹은 실패의 상황만 나온다. 그렇기에 5번 째의 decrease를 실행하게 된다면 uint256 자료형의 특성상 underflow가 발생한다. 

0.8.26버전에서는 require를 작성하지 않아도 자동적으로 음수가 되어 underflow가 되는 현상을 예방한다고 한다. 하지만, 그렇지 않다면 2^256 -1의 수가 출력되게 된다.

**질문 2:** 왜 `decrement()` 함수에 `require(count > 0, ...)` 조건이 필요한가요?

**답변:**
<!--
이 조건이 없으면 어떤 문제가 발생하는지 설명하세요.
힌트: uint256의 특성을 고려하세요.
-->
0.8.26버전에서는 require를 작성하지 않아도 자동적으로 음수가 되어 underflow가 되는 현상을 예방한다고 한다. 하지만, 그렇지 않다면 2^256 -1의 수가 출력되게 된다.
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
