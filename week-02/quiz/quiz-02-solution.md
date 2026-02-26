# Week 2 퀴즈 답안

## 문제 1: 트랜잭션 필드

**답변: B**

gasPrice는 가스 1개당 내야 할 wei 가격이고, gasLimit은 최대로 쓸 수 있는 가스양이다.

총 가스 비용은 이렇게 계산한다:
총 비용 = 실제 사용한 gas × gasPrice

예를 들어 21,000 gas를 쓰고 gasPrice가 20 Gwei면
21,000 × 20 = 420,000 Gwei = 0.00042 ETH가 든다.

---

## 문제 2: nonce의 역할

**답변: B**

이더리움은 nonce 순서대로 트랜잭션을 처리한다. TX-A(nonce=5)가 먼저 처리돼야 TX-B(nonce=6)가 처리된다.

gasPrice가 높아도 nonce 순서를 뛰어넘을 순 없다. nonce는 계정이 본인 트랜잭션을 몇 번 냈는지 카운트하는 거라서, 한 번 쓰면 못 쓴다. 이걸로 누가 내 트랜잭션을 복사해서 여러 번 볂는 재사용 공격을 막을 수 있다.

---

## 문제 3: 디지털 서명

**답변: A (인증)**

디지털 서명이 보장하는 세 가지는 이렇다:

1. 인증 - 누가 서명했는지 확인 가능. 내 개인키로만 서명할 수 있어서 남이 위조 못 한다
2. 무결성 - 데이터가 중간에 변조됐는지 확인 가능
3. 부인 방지 - 서명한 사람이 나중에 부인 못 함

여기서 묻는 위조 방지는 인증에 해당한다.

---

## 문제 4: 키 유도

**답변: C**

Private Key에서 Public Key를 만들고, Public Key에서 Address를 만든다. 반대로는 못 만든다.

왜 반대로 못 하냐면:
- Private Key -> Public Key: 타원곡선 수학으로 만드는데, 계산은 쉬워도 역으로 푸는 건 지금 컴퓨터로는 불가능함 (이산로그 문제)
- Public Key -> Address: 해시 함수 쓰는데, 해시는 원래 역으로 못 푸는 구조

그래서 Address만 가지고는 Public Key도 못 알아내고, Public Key만으로도 Private Key 못 알아낸다.

---

## 문제 5: nonce가 필요한 이유

nonce가 없으면 내가 본낸 트랜잭션을 누가 복사해서 여러 번 네트워크에 뿌릴 수 있다. 내 서명은 유효하니까 같은 트랜잭션이 계속 실행되서 돈이 계속 빠져나갈 수 있다.

nonce는 내 계정이 트랜잭션을 몇 번 냈는지 세는 역할을 한다. 한 번 쓴 nonce는 다시 못 쓰게 해서 이런 재사용 공격을 막는다.

---

## 문제 6: Private Key 보안

은행은 비밀번호 유출되면 계좌 동결시키고 거래 취소할 수 있다. 블록체인은 그게 안 된다.

블록체인은 코드가 곧 법이라서, 한 번 실행된 거래는 되돌릴 수 없다. Private Key 가진 사람이 계좌 주인이고, 그 사람이 한 거래는 무조건 유효하다. 그래서 Private Key 유출되면 그냥 돈 다 털리는 거고 막을 방법이 없다.

---

## 문제 7: EIP-1559

예전에는 사용자가 gasPrice를 직접 정해서 내야 했다. 네트워크 막히면 비싸게 내야 되는데, 얼마나 내야 할지 맞추기 어려웠다.

EIP-1559 이후에는 baseFee와 priorityFee로 나뉘었다:
- baseFee: 네트워크 상황에 따라 자동으로 정해지는 기본 수수료. 이건 burn(소각)된다
- priorityFee: 채굴자한테 주는 팁

총 수수료 = baseFee + priorityFee

이제 사용자는 maxFeePerGas랑 maxPriorityFeePerGas만 설정하면 되서 훨씬 편해졌다.

---

## 문제 8: SimpleStorage 테스트

```solidity
function test_DepositUpdatesBalance() public {
    vm.prank(user);
    storage_.deposit{value: 1 ether}();
    assertEq(storage_.getBalance(user), 1 ether);
}
```

- vm.prank(user): 다음 호출을 user가 하는 것처럼 만들어줌
- deposit{value: 1 ether}(): ETH 1개를 같이 볂는 문법
- 1 ether: Solidity에서 1 ether = 10^18 wei

---

## 문제 9: require 조건

문제점: withdraw 함수에 잔액 확인하는 게 없다

왜 문제냐면: 잔액 1 ether만 있어도 withdraw(100 ether) 호출할 수 있다. Solidity 0.8 이전에는 언더플로우나서 오히려 잔액이 엄청 늘어나는 심각한 버그였다.

고친 코드:
```solidity
function withdraw(uint256 amount) public {
    require(balances[msg.sender] >= amount, "Insufficient balance");
    balances[msg.sender] -= amount;
    payable(msg.sender).transfer(amount);
}
```

---

## 문제 10: 테스트 실패 이유

질문 1: 입금 안 하고 바로 출금해서 잔액이 0인데 1 ether 출금하려 해서 Insufficient balance 에러로 실패한다.

질문 2: 이렇게 고치면 된다
```solidity
function test_WithdrawFails() public {
    vm.expectRevert("Insufficient balance");
    storage_.withdraw(1 ether);
}
```

vm.expectRevert를 쓰면 다음 호출이 저 에러 메시지로 실패할 것을 기대한다. 실제로 실패하면 테스트 통과, 안 실패하면 테스트 실패다.

---

## 자기 평가

- 트랜잭션 필드 이해함
- 디지털 서명 세 가지 보장 설명 가능
- Private Key 보안 중요성 이해함
- Foundry 테스트 패턴 사용 가능
- require 조건 필요성 이해함
