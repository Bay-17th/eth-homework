# 코드 문제 템플릿

> **참고:** 이 템플릿을 복사하여 주차별 퀴즈에 사용하세요.
> 코드 문제는 **취약점 발견**과 **빈칸 채우기** 두 가지 형식이 있습니다.

---

## 형식 1: 취약점 찾기 (Bug Finding)

### 문제 [N]: [카테고리] (취약점 찾기)

다음 코드에서 보안 취약점을 찾으세요:

```solidity
// BAD CODE - 취약점 찾기
contract VulnerableContract {
    mapping(address => uint256) public balances;

    function withdraw(uint256 amount) public {
        require(balances[msg.sender] >= amount, "Insufficient");
        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Failed");
        balances[msg.sender] -= amount;  // ⚠️ 문제 위치
    }
}
```

**1) 발견한 취약점:**
<!-- 취약점 이름을 작성하세요 (예: 재진입 공격, 접근 제어 부재 등) -->


**2) 왜 이것이 문제인가:**
<!-- 이 취약점이 어떻게 악용될 수 있는지 설명하세요 -->


**3) 올바른 수정 방법:**
```solidity
// GOOD CODE - 수정된 버전을 작성하세요
```

---

## 형식 2: 빈칸 채우기 (Fill-in-the-Blank)

### 문제 [N]: [카테고리] (빈칸 채우기)

다음 코드의 빈칸을 채워서 [목표]를 달성하세요:

```solidity
// TODO: [필요한 import 또는 선언]
_________________________________________

contract SecureContract {
    // TODO: [필요한 변수 선언]
    _________________________________________

    function safeFunction() public {
        // TODO: [핵심 로직 구현]
        _________________________________________
    }
}
```

**답변:**
```solidity
// 완성된 코드를 여기에 작성하세요
```

**왜 이렇게 작성했나요:**
<!-- 코드 선택 이유를 설명하세요 -->


---

## 실제 예시: 재진입 방어

### 예시 1: 취약점 찾기

```markdown
## 문제 7: 재진입 공격 (취약점 찾기)

다음 코드에서 보안 취약점을 찾으세요:

```solidity
// BAD CODE - 취약점 찾기
contract Vault {
    mapping(address => uint256) public balances;

    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint256 amount) public {
        require(balances[msg.sender] >= amount, "Insufficient balance");

        // 외부 호출
        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Transfer failed");

        // 상태 변경
        balances[msg.sender] -= amount;
    }
}
```

**1) 발견한 취약점:**
<!-- 취약점 이름 -->

**2) 왜 이것이 문제인가:**
<!-- 문제가 발생하는 이유 -->

**3) 올바른 수정 방법:**
```solidity
// GOOD CODE - 수정된 버전
```
```

### 예시 2: 빈칸 채우기

```markdown
## 문제 8: ReentrancyGuard 적용 (빈칸 채우기)

다음 코드의 빈칸을 채워서 재진입 공격을 방어하세요:

```solidity
// TODO: OpenZeppelin 라이브러리 import
_________________________________________

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
// 완성된 코드를 여기에 작성
```

**왜 이렇게 작성했나요:**
<!-- 설명 -->
```

---

## 작성 가이드라인

### 취약점 찾기 문제 작성 시

1. **// BAD CODE** 주석으로 취약한 코드임을 명시
2. 취약점은 1-2개로 제한 (너무 많으면 혼란)
3. 취약점이 있는 줄 근처에 ⚠️ 힌트 가능
4. **// GOOD CODE** 섹션에서 수정 코드 작성 유도

### 빈칸 채우기 문제 작성 시

1. **// TODO:** 주석으로 채워야 할 부분 표시
2. **___________** 로 빈칸 표시
3. // 힌트: 를 통해 방향 제시 가능
4. 완성된 코드와 **이유 설명** 모두 요구

---

## 체크리스트

답변 작성 시 확인하세요:

- [ ] 취약점 이름을 정확히 식별했는가?
- [ ] 왜 문제인지 설명했는가? (공격 시나리오)
- [ ] 수정된 코드가 실행 가능한가? (문법 오류는 크게 감점하지 않음)
- [ ] 빈칸 채우기는 논리적으로 올바른가?
- [ ] 왜 그렇게 작성했는지 설명했는가?
