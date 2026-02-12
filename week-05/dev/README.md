# Week 5: RainbowKit 지갑 연결

이번 주에는 RainbowKit을 사용하여 dApp에 지갑 연결 기능을 추가하는 방법을 배웁니다.

## 학습 목표

이번 주를 마치면 다음을 할 수 있습니다:

- [x] RainbowKit의 역할과 wagmi와의 관계를 이해한다
- [x] WalletConnect Project ID를 발급받고 설정한다
- [x] ConnectButton으로 지갑 연결 UI를 구현한다
- [x] ConnectButton.Custom으로 커스텀 UI를 만든다
- [x] useSwitchChain으로 네트워크를 전환한다
- [x] 트랜잭션 상태를 사용자에게 표시한다

## 사전 준비

1. Week 4에서 만든 프로젝트 또는 frontend-template
2. WalletConnect Cloud 계정 (무료)
3. Sepolia 테스트넷 ETH

## 실습 내용

### 1. WalletConnect Project ID 설정

1. [WalletConnect Cloud](https://cloud.walletconnect.com) 접속
2. 회원가입 후 새 프로젝트 생성
3. `config/wagmi.ts`에서 Project ID 교체

```typescript
const WALLETCONNECT_PROJECT_ID = 'your-actual-project-id';
```

### 2. ETH 전송 기능 구현

지갑 연결 후 다른 주소로 ETH를 전송하는 기능을 구현합니다.

**해야 할 것:**
1. 받는 주소 입력 필드
2. 금액 입력 필드
3. 전송 버튼
4. 트랜잭션 상태 표시 (대기 중, 확인 중, 완료)

### 3. 커스텀 ConnectButton (선택)

프로젝트 디자인에 맞는 커스텀 지갑 연결 버튼을 만들어보세요.

```typescript
<ConnectButton.Custom>
  {({ account, chain, openConnectModal, ... }) => (
    // 나만의 UI
  )}
</ConnectButton.Custom>
```

### 4. 추가 과제 (선택)

- [ ] 네트워크 전환 버튼 구현
- [ ] 잔액 변화 감지 및 표시
- [ ] 트랜잭션 히스토리 표시
- [ ] 반응형 디자인 적용

## 참고 자료

- [RainbowKit 가이드](/eth-materials/week-05/dev/rainbowkit-guide.md)
- [RainbowKit 공식 문서](https://www.rainbowkit.com)
- [wagmi 가이드](/eth-materials/week-04/dev/wagmi-basics.md)

## Sepolia 테스트넷 ETH

실습에 필요한 테스트 ETH는 아래 Faucet에서 받을 수 있습니다:

- [Alchemy Faucet](https://sepoliafaucet.com)
- [Infura Faucet](https://www.infura.io/faucet/sepolia)
- [QuickNode Faucet](https://faucet.quicknode.com/ethereum/sepolia)

## 제출

1. 지갑 연결 + ETH 전송 기능이 구현된 프론트엔드 코드
2. 동작 스크린샷 또는 짧은 데모 영상
3. (선택) 커스텀 ConnectButton 구현

---

> **팁:** RainbowKit은 지갑 연결 UI만 담당합니다. 실제 트랜잭션은 모두 wagmi로 처리하세요!
