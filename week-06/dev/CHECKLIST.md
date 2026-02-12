# Week 6: 최종 프로젝트 체크리스트

나만의 dApp을 자유롭게 만들어보세요. 아래 체크리스트를 모두 만족해야 합니다.

---

## Technical Checklist (기술 요구사항)

### Smart Contract

- [ ] Solidity 0.8.26 이상 사용
- [ ] 최소 1개 이상의 상태 변수
- [ ] 최소 2개 이상의 public/external 함수
- [ ] 모든 상태 변경 함수에 이벤트 발생
- [ ] Foundry 테스트 작성 (최소 5개 테스트)
- [ ] CEI 패턴 또는 ReentrancyGuard 적용 (해당 시)

### Frontend

- [ ] Next.js App Router 사용
- [ ] wagmi + RainbowKit으로 지갑 연결
- [ ] 컨트랙트 상태 읽기 (useReadContract)
- [ ] 컨트랙트 상태 쓰기 (useWriteContract)
- [ ] 트랜잭션 대기 상태 표시 (pending indicator)
- [ ] 에러 처리 및 사용자 피드백

### Deployment

- [ ] Sepolia 테스트넷에 배포
- [ ] 배포된 컨트랙트 주소 README에 기재
- [ ] Etherscan에서 컨트랙트 검증 (선택)

---

## Functional Checklist (기능 요구사항)

### User Flow

- [ ] 지갑 연결 기능
- [ ] 메인 기능 1개 이상 (예: 토큰 전송, 투표, 기록 저장)
- [ ] 사용자 잔액 또는 상태 표시
- [ ] 트랜잭션 히스토리 또는 결과 표시

### UX/UI

- [ ] 반응형 레이아웃 (모바일/데스크톱)
- [ ] 로딩 상태 표시
- [ ] 에러 메시지 표시
- [ ] 한국어 UI (선택)

---

## Submission (제출)

### 1. 코드 구조

```
week-06/dev/
├── contracts/           # Solidity 컨트랙트
│   └── YourContract.sol
├── test/                # Foundry 테스트
│   └── YourContract.t.sol
├── frontend/            # Next.js 프론트엔드
│   ├── app/
│   ├── components/
│   └── config/
└── README.md            # 프로젝트 설명
```

### 2. README.md 필수 내용

다음 정보를 포함해야 합니다:

- 프로젝트 소개 (무엇을 만들었나?)
- 기술 스택
- 설치 및 실행 방법
- 배포된 컨트랙트 주소 (Sepolia)
- 스크린샷 또는 데모 링크

### 3. PR 생성 시

1. 이 체크리스트를 PR 본문에 복사
2. 완료된 항목 체크 (`- [x]`)
3. 리뷰어에게 데모 영상 또는 스크린샷 첨부

---

## 평가 기준

| 항목 | 비중 | 설명 |
|------|------|------|
| 기술 요구사항 | 40% | 체크리스트 충족도 |
| 기능 요구사항 | 30% | 사용자 관점에서 완성도 |
| 코드 품질 | 20% | 주석, 네이밍, 구조 |
| 창의성 | 10% | 독창적인 아이디어 가산점 |

---

## 도움이 필요하면?

- [wagmi 가이드](/eth-materials/week-04/dev/wagmi-basics.md)
- [RainbowKit 가이드](/eth-materials/week-05/dev/rainbowkit-guide.md)
- [최종 프로젝트 가이드](/eth-materials/week-06/dev/final-project.md)
- Slack 채널에서 질문하기

---

> **팁:** 간단하게 시작하세요! 기능이 완벽하지 않아도 됩니다.
> 핵심 기능 하나를 제대로 동작하게 만드는 것이 중요합니다.
