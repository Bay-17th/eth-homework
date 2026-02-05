# Week 1: Solidity 기초

> Counter 컨트랙트를 완성하여 Solidity의 기본 문법을 학습합니다.

---

## 학습 목표

이 과제를 완료하면 다음을 이해하게 됩니다:

- 상태 변수(state variable) 선언과 사용
- `public`, `view` 함수의 차이점
- `require`를 사용한 조건 검사
- Foundry 테스트 실행 방법

---

## 파일 구조

```
week-01/dev/
├── src/
│   └── Counter.sol      # 과제 파일 (TODO를 구현하세요)
├── test/
│   └── Counter.t.sol    # 테스트 파일 (수정하지 마세요)
├── script/
│   └── .gitkeep
└── README.md            # 이 파일
```

---

## 과제 안내

### 구현할 함수 (Counter.sol)

| 함수 | 설명 | 힌트 |
|------|------|------|
| `increment()` | count를 1 증가 | `count += 1;` |
| `decrement()` | count를 1 감소 (0이면 revert) | `require(count > 0, ...)` |
| `reset()` | count를 0으로 초기화 | `count = 0;` |

### TODO 완성 방법

1. `src/Counter.sol` 파일을 엽니다
2. `// TODO:` 주석이 있는 부분을 찾습니다
3. 힌트를 참고하여 로직을 구현합니다
4. 테스트를 실행하여 확인합니다

---

## 테스트 실행

### 프로젝트 루트에서 실행

```bash
# eth-homework 디렉토리에서
cd eth-homework

# Week 1 테스트만 실행
forge test --match-path week-01/dev/test/Counter.t.sol -vv

# 모든 테스트 실행
forge test -vv
```

### 테스트 출력 해석

```
[PASS] test_InitialCount_IsZero()     # 초기값 0 확인
[PASS] test_Increment_IncreasesCount() # increment 동작 확인
[PASS] test_Decrement_DecreasesCount() # decrement 동작 확인
[PASS] test_RevertWhen_DecrementBelowZero() # 0에서 감소 시 revert
[PASS] test_Reset_SetsCountToZero()   # reset 동작 확인
```

모든 테스트가 `[PASS]`로 표시되면 과제 완료입니다!

---

## 통과 기준

- [ ] 5개 테스트 모두 통과
- [ ] `forge build` 시 컴파일 에러 없음
- [ ] PR 제출 시 CI 통과

---

## 참고 자료

- [Solidity 기초 문법 가이드](../../../eth-materials/week-01/dev/solidity-basics.md)
- [Solidity 공식 문서](https://docs.soliditylang.org/)
- [Foundry Book](https://book.getfoundry.sh/)

---

## 도움이 필요하면

1. `solidity-basics.md` 가이드를 먼저 읽어보세요
2. 테스트 파일의 주석을 확인하세요 (기대하는 동작이 설명되어 있습니다)
3. Slack에서 질문하세요

---

*[메인 README로 돌아가기](../../README.md)*
