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
B
트랜잭션에 실패한 경우, 원자성의 의미인 "전부 실행되거나 아무것도 실행되지 않는다"라는 원칙으로 인해 잔액은 변하지 않지만, 트랜잭션 시도로 인해 gas fee는 소모된다.

---

## 문제 2: [이론] 결정론적 실행 (객관식)

이더리움 EVM이 "결정론적(deterministic)"으로 실행된다는 것의 핵심 이유는 무엇인가요?

**보기:**
A) 모든 노드가 같은 하드웨어를 사용해야 해서
B) 같은 입력(트랜잭션)이 주어지면 모든 노드가 같은 결과(상태)를 도출해야 하므로
C) 중앙 서버가 모든 계산을 수행하고 결과를 배포해서
D) 트랜잭션이 항상 1초 안에 처리되어야 해서

**답변:**
B
동일한 input이 주어지면 시간과 노드에 상관없이 동일한 output이 도출되어야한다. 즉, 중앙 관리의 존재가 없어도 합의가 이루어지는 특성 때문이다.
결정론적이지 않으면 불일치로 인해 합의가 이루어지지 못하고 변조의 위험성이 존재한다.

---

## 문제 3: [이론] EOA vs CA (객관식)

다음 중 EOA(Externally Owned Account)와 CA(Contract Account)의 차이를 올바르게 설명한 것은?

**보기:**
A) EOA는 코드를 실행할 수 있고, CA는 코드를 실행할 수 없다
B) EOA만 트랜잭션을 시작할 수 있고, CA는 EOA에 의해 호출될 때만 실행된다
C) CA만 ETH를 보유할 수 있고, EOA는 ETH를 보유할 수 없다
D) EOA와 CA는 동일한 기능을 가지며 이름만 다르다

**답변:**
B
CA는 개인키가 존재하지 않는다. 스마트 컨트랙트 코드만 가지고 있고 때문에, EOA가 보낸 트랜잭션에 의해 호출된다.

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
B
nonce는 트랜잭션의 순서를 보장하고 중복 처리를 방지한다. 즉, 트랜잭션 재사용 공격을 방지한다. 보통 gas fee가 높은 트랜잭션이 우선시된다.
그래서 TX-A는 처리되고, TX-B는 무시된다(혹은 그 반대).

---

## 문제 5: [이론] World State (객관식)

World State에 대한 설명 중 올바른 것은?

**보기:**
A) World State는 최신 100개 블록의 트랜잭션만 저장한다
B) World State는 모든 계정의 현재 상태(주소 -> 상태 매핑)를 나타낸다
C) World State는 EOA의 정보만 저장하고 CA 정보는 별도로 관리한다
D) World State는 각 노드마다 다른 값을 가질 수 있다

**답변:**
B
이더리움 네트워크에 존재하는 모든 주소와 해당하는 상태정보들을 저장하는 매핑 데이터베이스다. 즉, 인덱스로 검색하면 해당하는 번호가 나오는 전화번호부에 비유 가능하다.


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
상태변수는 함수 외부에서 선언된 변수로, 블록체인 값에 영속적으로 저장된다. 이에 비해 지역 변수는 함수 내부에서 정의된 변수로, 영속적으로 저장되지 않는다.
1. 상태 변수 - Storage, 지역 변수 - Memory
2. 상태뱐수는 트랜잭션이 종료되도 영구적으로 유지되지만, 지역 변수는 즉시 소멸된다.
3. storage에 저장되고 블록체인에 기록되는 상태 변수가 더 높다.

---

## 문제 7: [이론] 원자성의 이유 (단답형)

이더리움에서 트랜잭션이 "원자적(atomic)"으로 처리되어야 하는 이유는 무엇인가요?

**왜** 부분적으로 성공하는 트랜잭션을 허용하면 문제가 될까요? 구체적인 예시와 함께 설명하세요.

**답변:**
만약 완전히가 아닌 부분적으로 성공한 경우, 금융 거래에서 심각한 불일치가 발생한다. 부분적으로 성공한 경우 자산의 마이너스가 발생하는데 입금은 되지 않는 경우가 발생하여 데이터 사이의 불일치로 신뢰가 저하되는 일이 발생할 수 있다.

---

## 문제 8: [이론] 계정 구조 설명 (단답형)

EOA에는 `codeHash`와 `storageRoot`가 왜 의미가 없나요?

**답변:**
EOA는 개인키를 관리하는 주소로 실행 가능한 코드와 영구적인 상태 저장 공간이 존재하지 않는다. EOA는 잔액과 nonce를 관리하는 데 집중된 구조를 가진다.

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
해당 변수 값을 외부에서도 접근 및 사용이 가능하다.

**2) `view` 키워드의 의미:**
`getCount()` 함수에 `view`가 붙은 이유는 무엇인가요? `view`를 제거하면 어떻게 될까요?

**답변:**
상태만 읽는 경우, 변경하거나 저장하는 일이 없으므로 가스 사용을 막을 수 있다.

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
에러가 발생한다.
5번의 decrement()가 호출이 될 때 uint256에서 0보다 낮은 값은 허용되지 않기 때문이다.

**질문 2:** 왜 `decrement()` 함수에 `require(count > 0, ...)` 조건이 필요한가요?

**답변:**
uint 특성상, 0이 최소값으로 만약 0보다 작은 값으로 조정된다면 unsafe 처리 시 언더플로우 현상이 발생 가능하다.

---

## 자기 평가

모든 문제를 풀었다면, 아래 체크리스트로 자기 평가를 해보세요:

- [O] 상태 머신과 원자성 개념을 이해했다
- [O] EOA와 CA의 차이를 설명할 수 있다
- [O] 계정 상태의 4가지 필드(nonce, balance, storageRoot, codeHash)를 이해했다
- [O] Solidity 기본 문법(public, view, require)을 이해했다
- [O] 상태 변수와 지역 변수의 차이를 설명할 수 있다

---

## 참고 자료

- 이론: `eth-materials/week-01/theory/slides.md`
- 코드: `eth-homework/week-01/dev/src/Counter.sol`
- 용어: `eth-materials/resources/glossary.md`
