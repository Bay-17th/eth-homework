# Week 6: 최종 프로젝트 - 나만의 dApp

6주간 배운 내용을 총동원하여 나만의 dApp을 만들어보세요!

## 개요

**자유 주제**로 dApp을 개발합니다. 컨트랙트부터 프론트엔드까지 직접 구현하고, Sepolia 테스트넷에 배포합니다.

**목표:**
- 스마트 컨트랙트 설계 및 구현
- Foundry로 테스트 작성
- wagmi + RainbowKit으로 프론트엔드 연동
- Sepolia 배포 및 검증

## 체크리스트

**반드시 [CHECKLIST.md](./CHECKLIST.md)의 모든 필수 항목을 충족해야 합니다.**

주요 항목:
- Smart Contract: Solidity 0.8.26+, 상태 변수, public 함수, 이벤트, 테스트 5개+
- Frontend: Next.js, wagmi, RainbowKit, 컨트랙트 연동, 에러 처리
- Deployment: Sepolia 배포, 컨트랙트 주소 README 기재

## 아이디어 예시

아이디어가 떠오르지 않는다면 아래 예시를 참고하세요:

### 1. 간단한 투표 시스템
- 후보자 등록
- 투표하기 (1인 1표)
- 결과 조회

```solidity
// 핵심 기능
mapping(address => bool) public hasVoted;
mapping(uint256 => uint256) public votes;
function vote(uint256 candidateId) external { ... }
```

### 2. 기부/펀딩 컨트랙트
- 목표 금액 설정
- ETH 기부하기
- 목표 달성 시 수령

```solidity
// 핵심 기능
uint256 public goal;
function donate() external payable { ... }
function withdraw() external { ... }
```

### 3. 메시지 저장소
- 메시지 작성 (on-chain)
- 메시지 목록 조회
- 작성자별 필터링

```solidity
// 핵심 기능
struct Message { address author; string content; uint256 timestamp; }
Message[] public messages;
function post(string calldata content) external { ... }
```

### 4. 간단한 NFT 민팅
- ERC721 기본 구현
- 민팅 기능
- 소유자 확인

```solidity
// 핵심 기능 (OpenZeppelin 사용 가능)
function mint() external { ... }
function tokenURI(uint256 tokenId) public view returns (string memory) { ... }
```

### 5. 에스크로 컨트랙트
- 구매자가 ETH 예치
- 판매자가 배송 후 확인
- 구매자 확인 후 ETH 지급

```solidity
// 핵심 기능
enum State { Created, Funded, Shipped, Completed }
State public state;
function fund() external payable { ... }
function confirmReceived() external { ... }
```

## 참고 자료

- [최종 프로젝트 상세 가이드](/eth-materials/week-06/dev/final-project.md)
- [wagmi 가이드](/eth-materials/week-04/dev/wagmi-basics.md)
- [RainbowKit 가이드](/eth-materials/week-05/dev/rainbowkit-guide.md)
- [프론트엔드 템플릿](/eth-materials/resources/frontend-template/)

## 제출 방법

1. `week-06/dev/` 폴더에 프로젝트 코드 작성
2. README.md에 프로젝트 설명, 기술 스택, 컨트랙트 주소 기재
3. [CHECKLIST.md](./CHECKLIST.md)를 PR 본문에 복사하고 완료 항목 체크
4. PR 생성

## 제출 마감

**마감일: [TBD]**

마감 후에는 PR을 생성할 수 없습니다. 여유를 두고 미리 제출하세요!

## 발표

최종 발표에서 프로젝트를 시연합니다:
- 5분 발표 + 2분 Q&A
- 데모 시연 필수
- 코드 설명 선택

---

> **응원의 말씀:**
> 6주간 열심히 달려왔습니다. 마지막 프로젝트는 여러분이 배운 모든 것을 보여줄 기회입니다.
> 완벽하지 않아도 괜찮습니다. 도전하고, 실패하고, 배우는 과정 자체가 가치 있습니다.
> 화이팅!
