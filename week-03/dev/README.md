# Week 3: 스마트 컨트랙트 보안 패턴

## 학습 목표

이번 주차에서는 스마트 컨트랙트 보안의 핵심 개념을 배웁니다:

1. **재진입 공격 (Reentrancy Attack) 이해**
   - 외부 호출 시 발생할 수 있는 취약점
   - The DAO 해킹 사례 분석

2. **CEI (Checks-Effects-Interactions) 패턴**
   - 안전한 함수 작성 순서
   - 상태 변경과 외부 호출의 올바른 배치

3. **OpenZeppelin ReentrancyGuard**
   - 검증된 라이브러리 활용
   - `nonReentrant` modifier 사용법

---

## The DAO 해킹 사례 (2016)

2016년 6월, 이더리움 역사상 가장 유명한 해킹 사건이 발생했습니다.

- **피해 금액**: 약 $60M (당시 이더리움 시가총액의 약 14%)
- **원인**: 재진입 취약점 (Reentrancy Vulnerability)
- **결과**: 이더리움 하드포크 → Ethereum(ETH)과 Ethereum Classic(ETC)으로 분리

공격자는 DAO 컨트랙트의 `withdraw` 함수가 잔액을 업데이트하기 전에 외부 호출을 수행한다는 점을 악용했습니다. `receive()` 함수에서 다시 `withdraw()`를 호출하여 반복적으로 자금을 인출했습니다.

**교훈**: 외부 호출 전에 반드시 상태를 업데이트하세요!

---

## 파일 구조

```
week-03/dev/
├── src/
│   ├── Vault.sol       # ❌ 취약한 버전 (BAD - 교육용)
│   └── VaultSecure.sol # ✅ 구현 대상 (GOOD - 여러분이 완성)
├── test/
│   └── Vault.t.sol     # 테스트 스위트 (TDD)
└── README.md           # 이 파일
```

### 파일 설명

| 파일 | 설명 | 수정 여부 |
|------|------|----------|
| `Vault.sol` | 재진입에 취약한 예시 코드. **절대 프로덕션에서 사용하지 마세요!** | 읽기 전용 |
| `VaultSecure.sol` | 여러분이 구현할 안전한 버전. TODO 주석을 따라 완성하세요. | **수정 대상** |
| `Vault.t.sol` | 모든 테스트가 포함된 TDD 테스트 파일. 테스트를 읽고 예상 동작을 파악하세요. | 읽기 전용 |

---

## TDD (Test-Driven Development) 접근법

이 과제는 TDD 방식으로 진행됩니다:

### 1단계: 테스트 읽기

먼저 `test/Vault.t.sol`의 테스트들을 읽어보세요:

```bash
# 테스트 파일 확인
cat week-03/dev/test/Vault.t.sol
```

각 테스트 함수의 이름이 예상 동작을 설명합니다:
- `test_Deposit_IncreasesUserBalance()` → 입금 시 잔액 증가
- `test_Withdraw_DecreasesUserBalance()` → 출금 시 잔액 감소
- `test_RevertWhen_WithdrawExceedsBalance()` → 잔액 초과 출금 시 revert
- `test_ReentrancyAttack_CannotDrainVault()` → **재진입 공격 방어** (핵심!)

### 2단계: 구현하기

`src/VaultSecure.sol`의 TODO 주석을 따라 구현하세요:
- `deposit()` 함수
- `withdraw()` 함수 (재진입에 안전하게!)

### 3단계: 테스트 실행

```bash
# Week 3 테스트만 실행
forge test --match-path week-03/dev/test/Vault.t.sol -vv

# 특정 테스트만 실행
forge test --match-test test_ReentrancyAttack -vv

# 가스 리포트 포함
forge test --match-path week-03/dev/test/Vault.t.sol --gas-report
```

### 4단계: 모든 테스트 통과 확인

```
Running 12 tests for test/Vault.t.sol:VaultSecureTest
[PASS] test_Deposit_AccumulatesBalance()
[PASS] test_Deposit_EmitsDepositedEvent()
[PASS] test_Deposit_IncreasesContractBalance()
[PASS] test_Deposit_IncreasesUserBalance()
[PASS] test_GetBalance_ReturnsContractBalance()
[PASS] test_ReentrancyAttack_AttackerGetsOnlyOwnDeposit()
[PASS] test_ReentrancyAttack_CannotDrainVault()    ← 핵심!
[PASS] test_RevertWhen_WithdrawExceedsBalance()
[PASS] test_RevertWhen_WithdrawWithZeroBalance()
[PASS] test_Withdraw_DecreasesUserBalance()
[PASS] test_Withdraw_EmitsWithdrawnEvent()
[PASS] test_Withdraw_TransfersEtherToUser()
```

---

## 구현 선택지

`VaultSecure.sol`을 구현할 때 두 가지 방법 중 선택할 수 있습니다:

### 선택 1: CEI (Checks-Effects-Interactions) 패턴

코드 순서만 바꾸면 됩니다:

```solidity
function withdraw(uint256 amount) public {
    // 1. Checks (검증)
    require(balances[msg.sender] >= amount, "Insufficient balance");

    // 2. Effects (상태 변경) - 외부 호출 전에!
    balances[msg.sender] -= amount;

    // 3. Interactions (외부 호출) - 마지막에!
    (bool success, ) = msg.sender.call{value: amount}("");
    require(success, "Transfer failed");

    emit Withdrawn(msg.sender, amount);
}
```

**장점:**
- 가스 효율적 (추가 스토리지 연산 없음)
- 외부 라이브러리 의존성 없음

**단점:**
- 개발자가 순서를 직접 관리해야 함
- 복잡한 컨트랙트에서는 실수 가능성

### 선택 2: OpenZeppelin ReentrancyGuard

검증된 라이브러리의 modifier를 사용합니다:

```solidity
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract VaultSecure is ReentrancyGuard {
    function withdraw(uint256 amount) public nonReentrant {
        require(balances[msg.sender] >= amount, "Insufficient balance");

        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Transfer failed");

        balances[msg.sender] -= amount;
        emit Withdrawn(msg.sender, amount);
    }
}
```

**장점:**
- 명시적이고 안전함
- OpenZeppelin이 검증한 코드
- 실수 방지

**단점:**
- 약간의 가스 오버헤드 (~2,500 gas)
- 외부 의존성

### 권장 사항

1. **학습 목적**: CEI 패턴을 먼저 이해하고 구현해보세요
2. **프로덕션**: CEI + ReentrancyGuard 둘 다 사용하는 것이 안전합니다

---

## 디버깅 팁

### 테스트 실패 시

```bash
# 상세 출력으로 실행
forge test --match-path week-03/dev/test/Vault.t.sol -vvvv

# 특정 실패 테스트만
forge test --match-test test_ReentrancyAttack_CannotDrainVault -vvvv
```

### 흔한 실수

1. **Checks를 빠뜨림**: `require(balances[msg.sender] >= amount, ...)` 필수
2. **Effects 순서 잘못**: 상태 변경이 call() 후에 있으면 취약
3. **이벤트 누락**: `emit Withdrawn(...)` 잊지 마세요

---

## 추가 학습 자료

- [eth-materials/week-03/dev/security-patterns.md](../../materials/week-03/dev/security-patterns.md) - 보안 패턴 상세 가이드
- [SWC-107: Reentrancy](https://swcregistry.io/docs/SWC-107) - 공식 취약점 레지스트리
- [OpenZeppelin ReentrancyGuard](https://docs.openzeppelin.com/contracts/4.x/api/security#ReentrancyGuard)

---

## 체크리스트

과제 제출 전 확인하세요:

- [ ] `deposit()` 함수 구현 완료
- [ ] `withdraw()` 함수 구현 완료 (CEI 또는 ReentrancyGuard)
- [ ] 모든 테스트 통과 (`forge test --match-path week-03/dev/test/Vault.t.sol`)
- [ ] 특히 `test_ReentrancyAttack_CannotDrainVault` 통과
- [ ] 코드에 적절한 주석 추가
