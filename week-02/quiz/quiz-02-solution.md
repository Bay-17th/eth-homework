# Week 2 퀴즈: Transaction/서명 + Foundry

**제출 방법:**
1. 이 파일을 복사하여 `quiz-02-solution.md`로 저장
2. 각 문제에 답변 작성 (왜 그런지 설명 포함)
3. Pull Request 생성 (`quiz_submission` 템플릿 사용)

**평가 기준:**
- 정답 여부보다 **개념 이해도**를 중점 평가합니다
- "왜"에 대한 설명이 충분한지 확인합니다
- 코드 문제는 문법보다 논리적 정확성을 평가합니다

---

## 문제 1: [이론] 트랜잭션 필드 (객관식)

다음 중 이더리움 트랜잭션에서 `gasPrice`와 `gasLimit`의 관계를 올바르게 설명한 것은?

**보기:**
A) gasPrice는 최대 사용량, gasLimit은 단위당 가격이다
B) gasPrice는 단위당 가격, gasLimit은 최대 사용량이다
C) 둘 다 같은 의미이며 호환되어 사용된다
D) gasLimit이 높을수록 트랜잭션이 빨리 처리된다

**답변:**
B) gasPrice는 단위당 가격, gasLimit은 최대 사용량이다

**설명:**
- gasLimit (가스 한도): 이 트랜잭션을 실행하기 위해 사용할 수 있는 가스의 최대 총량입니다. 트랜잭션이 복잡할수록 더 많은 연산이 필요하므로 gasLimit을 넉넉하게 설정해야 합니다. 실행 중 가스가 이 한도를 초과하면 Out of Gas 에러와 함께 트랜잭션은 실패(Revert)합니다.
- gasPrice (가스 가격): 가스 1단위당 지불할 **ETH의 가격(단위: Gwei)**입니다. 가격을 높게 설정할수록 채굴자(검증자)에게 더 큰 인센티브를 주므로 트랜잭션이 빨리 처리될 확률이 높아집니다.

**총 가스 비용 공식:**

* Legacy 트랜잭션:

  ```
  총 비용 = gasUsed × gasPrice
  ```

* EIP-1559 이후:

  ```
  총 비용 = gasUsed × effectiveGasPrice
  ```

  여기서:

  ```
  effectiveGasPrice = baseFee + priorityFee
  ```

---

## 문제 2: [이론] nonce의 역할 (객관식)

다음 상황에서 어떤 일이 발생하나요?

```
Alice가 다음 두 트랜잭션을 동시에 네트워크에 브로드캐스트합니다:
- TX-A: nonce=5, Bob에게 1 ETH (gasPrice: 50 Gwei)
- TX-B: nonce=6, Charlie에게 2 ETH (gasPrice: 100 Gwei)

Alice의 현재 nonce: 5
```

**보기:**
A) TX-B가 gasPrice가 높아서 먼저 처리되고, TX-A는 나중에 처리된다
B) TX-A가 먼저 처리되어야 TX-B가 처리될 수 있다. gasPrice와 무관하게 순서대로 처리된다
C) 두 트랜잭션이 동시에 처리된다
D) 둘 다 실패하고 Alice의 계정이 잠긴다

**답변:**
B) TX-A가 먼저 처리되어야 TX-B가 처리될 수 있다. gasPrice와 무관하게 순서대로 처리된다

**설명:**
이더리움 네트워크는 계정별로 트랜잭션의 **순서(Sequence)**를 엄격하게 지킵니다.
- Alice의 현재 nonce가 5라면, 네트워크는 오직 nonce=5인 트랜잭션(TX-A)만을 기다립니다.
- TX-B(nonce=6)의 가스비가 아무리 비싸도, 앞선 번호인 5번이 처리되기 전까지는 "미래의 트랜잭션"으로 간주되어 대기 상태(Pending Pool)에 머무릅니다.
- TX-A가 블록에 포함되어 처리되면 Alice의 nonce가 6으로 증가하고, 그 후에 TX-B가 유효한 트랜잭션으로 인정받아 처리될 수 있습니다.

---

## 문제 3: [이론] 디지털 서명 (객관식)

디지털 서명(ECDSA)이 보장하는 세 가지 속성 중, "누군가 내 트랜잭션을 위조할 수 없다"를 보장하는 것은?

**보기:**
A) 인증 (Authentication)
B) 무결성 (Integrity)
C) 부인 방지 (Non-repudiation)
D) 암호화 (Encryption)

**답변:**
A) 인증 (Authentication)

**설명:**
* 디지털 서명(ECDSA)은 다음 세 가지 보안 속성을 보장합니다:
1. 인증 (Authentication): "이 트랜잭션은 해당 개인키를 가진 사람(본인)이 생성한 것이 맞다." 즉, 타인이 내 개인키 없이 내 이름으로 트랜잭션을 **위조(Forgery)**하여 서명을 생성하는 것을 방지합니다.
2. 무결성 (Integrity): "전송 중에 내용이 변조되지 않았다." 데이터가 단 1비트라도 바뀌면 서명 검증이 실패하므로 데이터의 원본성을 보장합니다.
3. 부인 방지 (Non-repudiation): "송신자는 나중에 자기가 보낸 사실을 부인할 수 없다." 서명은 송신자의 개인키로만 생성 가능하기 때문에 발신 사실을 오리발 내밀 수 없습니다.

---

## 문제 4: [이론] 키 유도 (객관식)

다음 중 키 유도 과정에서 올바른 방향을 설명한 것은?

**보기:**
A) Public Key -> Private Key -> Address 순으로 유도된다
B) Address -> Public Key -> Private Key 순으로 역추적 가능하다
C) Private Key -> Public Key -> Address 순으로 유도되며, 역방향은 불가능하다
D) 세 값은 독립적으로 생성되며 서로 연관이 없다

**답변:**
C) Private Key -> Public Key -> Address 순으로 유도되며, 역방향은 불가능하다

**설명:**
이더리움의 계정 생성 과정은 **단방향 함수(One-way Function)**들의 연속입니다.
- Private Key ($k$): 무작위로 생성된 256비트 정수.
- Public Key ($K$): 타원곡선 곱셈 ($K = k \times G$)을 통해 유도됩니다. 이 연산은 이산 대수 문제(Discrete Logarithm Problem)의 난이도에 기반하여, $K$에서 $k$를 역추적하는 것이 계산적으로 불가능합니다.
- Address ($A$): 공개키의 해시값($Keccak\text{-}256(K)$)의 뒤쪽 20바이트를 잘라서 만듭니다. 해시 함수 역시 역연산이 불가능합니다.

---

## 문제 5: [이론] nonce의 필요성 (단답형)

이더리움에서 **왜** nonce가 필요한가요?

만약 nonce가 없다면 어떤 공격이 가능해질까요? 구체적인 예시와 함께 설명하세요.

**답변:**
nonce는 **이중 지불(Double Spending) 및 재사용 공격(Replay Attack)**을 방지하기 위해 필수적입니다.
만약 nonce가 없다면, Alice가 Bob에게 "1 ETH 송금" 서명 데이터를 보냈을 때, Bob이 이 데이터를 복사해서 네트워크에 10번 전송하면 Alice의 계좌에서 10 ETH가 빠져나가는 사고가 발생합니다. nonce가 있으면 각 트랜잭션이 고유한 번호를 가지므로, 이미 처리된 nonce 5번 트랜잭션을 다시 보내더라도 네트워크는 "이미 사용된 번호"라며 거절합니다.

---

## 문제 6: [이론] Private Key 보안 (단답형)

2022년 Ronin Bridge 해킹에서 약 $625M이 탈취되었습니다.

**왜** Private Key 유출이 이렇게 치명적인가요? 은행 계좌 비밀번호 유출과 비교해서 설명하세요.

**답변:**
블록체인은 중앙 관리자가 없는 탈중앙화 시스템이기 때문입니다. 은행 비밀번호가 유출되면 은행에 전화해서 계좌를 동결하거나 거래를 취소할 수 있지만, 블록체인에는 이를 통제할 주체가 없습니다. 개인키는 자산에 대한 유일하고 절대적인 소유권을 증명하므로, 한 번 유출되어 자산이 전송되면 그 누구도 되돌릴 수 없습니다.

---

## 문제 7: [이론] EIP-1559 이해 (단답형)

EIP-1559 이전과 이후의 가스 수수료 메커니즘의 가장 큰 차이점은 무엇인가요?

**힌트:** `baseFee`와 `priorityFee`의 역할을 설명하면서 답변하세요.

**답변:**
가장 큰 차이점은 가스비가 **기본료(Base Fee)**와 **우선료(Priority Fee)**로 분리되었다는 점입니다.
- 이전: 사용자가 하나의 가스 가격(Gas Price)을 입찰 경쟁 방식으로 제시했습니다.
- 이후 (EIP-1559): 네트워크 혼잡도에 따라 알고리즘적으로 결정되는 **기본료(Base Fee)**는 소각(Burn)되고, 채굴자에게 팁으로 주는 **우선료(Priority Fee)**만 사용자가 추가로 설정합니다. 이로 인해 가스비 예측이 훨씬 쉬워졌습니다.

---

## 문제 8: [코드] SimpleStorage 테스트 (빈칸 채우기)

다음 테스트 코드의 빈칸을 채워서 deposit 기능을 테스트하세요:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import "forge-std/Test.sol";
import "../src/SimpleStorage.sol";

contract SimpleStorageTest is Test {
    SimpleStorage public storage_;
    address public user = address(0x1);

    function setUp() public {
        storage_ = new SimpleStorage();
        // user에게 10 ETH 부여
        vm.deal(user, 10 ether);
    }

    function test_DepositUpdatesBalance() public {
        // Arrange: user 관점에서 실행
        _______________________;  // TODO: user로 전환하는 코드

        // Act: 1 ETH 입금
        _______________________;  // TODO: 1 ether를 입금하는 코드

        // Assert: 잔액 확인
        assertEq(storage_.getBalance(user), ______);  // TODO: 예상 잔액
    }
}
```

**답변:**
```solidity
function test_DepositUpdatesBalance() public {
        // Arrange: user 관점에서 실행
        vm.prank(user);

        // Act: 1 ETH 입금
        storage_.deposit{value: 1 ether}();

        // Assert: 잔액 확인
        assertEq(storage_.getBalance(user), 1 ether);
    }
```

**왜 이렇게 작성했나요:**
1. `vm.prank(user)`: Foundry의 치트코드로, "다음 한 줄의 코드는 user가 호출한 것처럼 실행하라"는 뜻입니다. msg.sender를 user로 조작합니다.
2. `deposit{value: 1 ether}()`: Solidity에서 함수 호출 시 ETH를 함께 보내려면 중괄호 {value: ...} 구문을 사용해야 합니다.
3. `1 ether`: 입금한 금액만큼 잔액이 늘어났는지 검증합니다.


---

## 문제 9: [코드] require 조건 (취약점 찾기)

다음 코드에서 잠재적 문제점을 찾으세요:

```solidity
// BAD CODE - 문제점 찾기
contract Wallet {
    mapping(address => uint256) public balances;

    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint256 amount) public {
        // 잔액 차감
        balances[msg.sender] -= amount;

        // ETH 전송
        payable(msg.sender).transfer(amount);
    }
}
```

**1) 발견한 문제점:**
`withdraw` 함수에서 사용자의 **잔액이 충분한지 확인하는 조건문(require)**이 빠져 있습니다.


**2) 왜 이것이 문제인가:**
Solidity 0.8.0 이상에서는 언더플로우 발생 시 자동으로 실패하지만, 만약 언더플로우가 발생하지 않는 상황(예: 다른 로직이 섞여 있거나 버전이 낮은 경우)이라면, 잔액보다 더 많은 돈을 출금할 수 있게 됩니다. 또한, balances 매핑에서 차감되기 전에 transfer가 실패할 경우의 처리가 미흡할 수 있습니다. (현재 코드는 0.8 버전이라 balances -= amount에서 언더플로우 에러가 발생하지만, 명시적인 에러 메시지가 없어 디버깅이 어렵습니다.)


**3) 올바른 수정 방법:**
```solidity
function withdraw(uint256 amount) public {
        // 출금 요청액이 잔액보다 큰지 먼저 검사
        require(balances[msg.sender] >= amount, "Insufficient balance");

        // 잔액 차감 (Effect)
        balances[msg.sender] -= amount;

        // ETH 전송 (Interaction)
        payable(msg.sender).transfer(amount);
    }
```

---

## 문제 10: [코드] 테스트 실패 이유 (코드 분석)

다음 테스트가 실패하는 이유를 분석하세요:

```solidity
contract SimpleStorageTest is Test {
    SimpleStorage public storage_;

    function setUp() public {
        storage_ = new SimpleStorage();
    }

    function test_WithdrawFails() public {
        // 입금 없이 바로 출금 시도
        storage_.withdraw(1 ether);
    }
}
```

**질문 1:** 이 테스트가 실패하는 이유는 무엇인가요?

**답변:**
이 테스트는 실패(Fail)합니다. `SimpleStorage` 컨트랙트에서, 잔액이 0인 상태에서 `withdraw(1 ether)`를 호출하면 언더플로우(Underflow) 에러나 require 조건 실패로 인해 트랜잭션이 **Revert(취소)**되기 때문입니다. 테스트 코드는 함수가 정상적으로 끝날 것을 기대했는데, 도중에 에러가 발생했으니 "테스트 실패"로 간주하는 것입니다.


**질문 2:** 이 테스트를 "출금 실패를 테스트하는 정상 테스트"로 바꾸려면 어떻게 수정해야 하나요?

**답변:**
```solidity
function test_WithdrawFails() public {
        // "다음 줄에서 에러(Revert)가 발생할 것을 기대함" 선언
        vm.expectRevert("Insufficient balance"); 
    
        // 입금 없이 바로 출금 시도 -> 여기서 에러가 발생하면 테스트 '성공'
        storage_.withdraw(1 ether);
    }
```

---

## 자기 평가

모든 문제를 풀었다면, 아래 체크리스트로 자기 평가를 해보세요:

- [x] 트랜잭션 필드(nonce, gasPrice, gasLimit 등)의 역할을 이해했다
- [x] 디지털 서명의 세 가지 보장(인증, 무결성, 부인 방지)을 설명할 수 있다
- [x] Private Key 보안의 중요성을 이해했다
- [x] Foundry 테스트 기본 패턴(vm.prank, vm.deal, assertEq)을 사용할 수 있다
- [x] require 조건의 필요성을 이해했다

---

## 참고 자료

- 이론: `eth-materials/week-02/theory/slides.md`
- 코드: `eth-homework/week-02/dev/src/SimpleStorage.sol`
- 테스트: `eth-homework/week-02/dev/test/SimpleStorage.t.sol`
- 용어: `eth-materials/resources/glossary.md`
