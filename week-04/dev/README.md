# Week 4: wagmi 연동 및 Web3 프론트엔드

이번 주에는 wagmi를 사용하여 Web3 프론트엔드를 개발하는 방법을 배웁니다.

## 학습 목표

이번 주를 마치면 다음을 할 수 있습니다:

- [x] wagmi의 핵심 개념(hooks, config, provider)을 이해한다
- [x] useAccount, useBalance 등 계정 관련 훅을 사용한다
- [x] useReadContract로 컨트랙트 상태를 읽는다
- [x] useWriteContract로 컨트랙트 함수를 호출한다
- [x] BigInt와 viem의 유틸리티 함수를 다룬다

## 사전 준비

1. Node.js 18+ 설치
2. MetaMask 또는 다른 Web3 지갑 설치
3. Sepolia 테스트넷 ETH (Faucet에서 받기)

## 실습 내용

### 1. 프론트엔드 템플릿 설정

`eth-materials/resources/frontend-template/` 폴더를 복사하여 시작합니다.

```bash
# 템플릿 복사
cp -r eth-materials/resources/frontend-template/ week-04/dev/my-dapp/

# 의존성 설치
cd week-04/dev/my-dapp
npm install

# 개발 서버 실행
npm run dev
```

### 2. Counter 컨트랙트 연동

지난 주에 배포한 Counter 컨트랙트(또는 예제 컨트랙트)와 연동합니다.

**해야 할 것:**
1. 컨트랙트 ABI를 프로젝트에 추가
2. useReadContract로 count 값 표시
3. useWriteContract로 increment/decrement 호출
4. 트랜잭션 상태(pending, confirming, success) 표시

### 3. 추가 과제 (선택)

- [ ] 이벤트 리스닝으로 실시간 업데이트 구현
- [ ] 에러 메시지를 사용자 친화적으로 표시
- [ ] 트랜잭션 히스토리 표시

## 참고 자료

- [wagmi 상세 가이드](/eth-materials/week-04/dev/wagmi-basics.md)
- [wagmi 공식 문서](https://wagmi.sh)
- [viem 공식 문서](https://viem.sh)

## 제출

1. Counter 컨트랙트와 연동된 프론트엔드 코드
2. 동작 스크린샷 또는 짧은 데모 영상
3. (선택) 추가 과제 구현 내용

---

> **팁:** 처음에는 복잡해 보이지만, useReadContract와 useWriteContract 두 개의 훅만 이해하면 대부분의 dApp을 만들 수 있습니다!
