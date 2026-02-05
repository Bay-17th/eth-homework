# Week 2: Foundry 테스트

> SimpleStorage 컨트랙트를 완성하여 Foundry 테스트 기법을 학습합니다.

---

## 학습 목표

이 과제를 완료하면 다음을 이해하게 됩니다:

- `mapping`을 사용한 데이터 저장
- `event`와 `emit`으로 로그 기록
- `payable` 함수와 ETH 전송
- Foundry의 테스트 패턴 (setUp, assert, vm.prank)

---

## 파일 구조

```
week-02/dev/
├── src/
│   └── SimpleStorage.sol  # 과제 파일 (TODO를 구현하세요)
├── test/
│   └── SimpleStorage.t.sol  # 테스트 파일 (수정하지 마세요)
├── script/
│   └── .gitkeep
└── README.md              # 이 파일
```

---

## 과제 안내

### 구현할 함수 (SimpleStorage.sol)

| 함수 | 설명 | 힌트 |
|------|------|------|
| `deposit()` | msg.value를 잔액에 추가 | `balances[msg.sender] += msg.value;` |
| `withdraw(amount)` | 잔액에서 amount 출금 | `require`, `transfer`, `emit` |

### TODO 완성 방법

1. `src/SimpleStorage.sol` 파일을 엽니다
2. `// TODO:` 주석이 있는 부분을 찾습니다
3. 힌트를 참고하여 로직을 구현합니다
4. 테스트를 실행하여 확인합니다

---

## 테스트 실행

### 프로젝트 루트에서 실행

```bash
# eth-homework 디렉토리에서
cd eth-homework

# Week 2 테스트만 실행
forge test --match-path week-02/dev/test/SimpleStorage.t.sol -vv

# 모든 테스트 실행
forge test -vv
```

### 가스 리포트

```bash
# 가스 사용량 확인
forge test --gas-report
```

### 테스트 출력 해석

```
[PASS] test_Deposit_UpdatesBalance()      # 입금 시 잔액 업데이트
[PASS] test_Deposit_EmitsEvent()          # 입금 시 이벤트 발생
[PASS] test_Withdraw_UpdatesBalance()     # 출금 시 잔액 업데이트
[PASS] test_Withdraw_TransfersEther()     # 출금 시 ETH 전송
[PASS] test_RevertWhen_WithdrawExceedsBalance()  # 잔액 부족 시 revert
[PASS] test_Withdraw_EmitsEvent()         # 출금 시 이벤트 발생
[PASS] testFuzz_Deposit(amount)           # Fuzz 테스트 (다양한 입력)
```

모든 테스트가 `[PASS]`로 표시되면 과제 완료입니다!

---

## Foundry Cheatcodes 참고

테스트 파일에서 사용된 Foundry cheatcodes:

| Cheatcode | 설명 |
|-----------|------|
| `vm.deal(addr, amount)` | addr에 ETH 지급 |
| `vm.prank(addr)` | 다음 호출의 msg.sender를 addr로 변경 |
| `vm.expectRevert(msg)` | 다음 호출이 msg로 revert될 것을 예상 |
| `vm.expectEmit(...)` | 다음 호출에서 특정 이벤트가 발생할 것을 예상 |
| `vm.assume(cond)` | Fuzz 테스트에서 cond를 만족하는 입력만 사용 |

---

## 통과 기준

- [ ] 7개 테스트 모두 통과
- [ ] `forge build` 시 컴파일 에러 없음
- [ ] PR 제출 시 CI 통과

---

## 참고 자료

- [Foundry 테스트 가이드](../../../eth-materials/week-02/dev/foundry-testing.md)
- [Foundry Book - Testing](https://book.getfoundry.sh/forge/tests)
- [Foundry Cheatcodes Reference](https://book.getfoundry.sh/cheatcodes/)

---

## 도움이 필요하면

1. `foundry-testing.md` 가이드를 먼저 읽어보세요
2. 테스트 파일의 주석을 확인하세요 (기대하는 동작이 설명되어 있습니다)
3. Slack에서 질문하세요

---

*[메인 README로 돌아가기](../../README.md)*
