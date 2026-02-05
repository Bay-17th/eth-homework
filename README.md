# Bay-17th 이더리움 온보딩 - 과제 제출

이더리움 온보딩 프로그램의 과제 제출 저장소입니다.

## 목차

- [빠른 시작](#빠른-시작)
- [주차별 과제](#주차별-과제)
- [제출 방법](#제출-방법)
- [도움 받기](#도움-받기)

## 빠른 시작

### 저장소 클론

```bash
git clone --recurse-submodules https://github.com/your-org/eth-homework.git
cd eth-homework
```

> **Note:** `--recurse-submodules` 옵션을 사용해야 Foundry 라이브러리가 함께 다운로드됩니다.

### 개발 환경 설정

1. [Foundry](https://book.getfoundry.sh/getting-started/installation) 설치:
   ```bash
   curl -L https://foundry.paradigm.xyz | bash
   foundryup
   ```

2. 의존성 설치:
   ```bash
   forge install
   ```

3. 빌드 테스트:
   ```bash
   forge build
   ```

## 주차별 과제

| 주차 | 이론 | 개발 | 주제 |
|:----:|:----:|:----:|------|
| [Week 1](./week-01/) | Quiz | Counter | 블록체인 기초 & Solidity 입문 |
| [Week 2](./week-02/) | Quiz | ERC20 | 이더리움 구조 & 토큰 표준 |
| [Week 3](./week-03/) | Quiz | Vault | 트랜잭션 & 보안 기초 |
| [Week 4](./week-04/) | Quiz | NFT | 스마트 컨트랙트 심화 |
| [Week 5](./week-05/) | Quiz | DEX | DeFi 기초 |
| [Week 6](./week-06/) | - | Final | 최종 프로젝트 |

각 주차 폴더에는 다음이 포함됩니다:
- `theory/`: 이론 퀴즈 템플릿
- `dev/`: 개발 과제 (src, test, script)

## 제출 방법

### 1. 브랜치 생성

자신의 GitHub 사용자명과 주차를 조합하여 브랜치를 만듭니다:

```bash
git checkout -b username/week-01
```

### 2. 과제 완성

- **이론**: `week-XX/theory/` 폴더의 템플릿을 복사하여 답안 작성
- **개발**: `week-XX/dev/src/` 폴더의 TODO를 구현

### 3. 테스트 확인

```bash
# 개발 과제 테스트
forge test

# 특정 주차만 테스트
forge test --match-path "week-01/*"
```

### 4. 커밋 & 푸시

```bash
git add .
git commit -m "feat(week-01): complete counter assignment"
git push -u origin username/week-01
```

### 5. Pull Request 생성

GitHub에서 Pull Request를 생성합니다. PR 템플릿에 따라 배운 점과 어려웠던 점을 작성해주세요.

자세한 제출 가이드는 [CONTRIBUTING.md](./CONTRIBUTING.md)를 참조하세요.

## 도움 받기

과제 수행 중 어려움이 있다면:

1. **Issue 생성**: [질문 템플릿](./.github/ISSUE_TEMPLATE/help-request.md)을 사용해 질문을 올려주세요.
2. **동기들과 토론**: 같은 주차를 진행하는 동기들과 함께 고민해보세요.
3. **리뷰어에게 질문**: PR 코멘트로 리뷰어에게 직접 질문할 수 있습니다.

## 프로젝트 구조

```
eth-homework/
├── README.md                 # 이 파일
├── CONTRIBUTING.md           # 상세 제출 가이드
├── foundry.toml              # Foundry 설정
├── .env.example              # 환경변수 예시
├── lib/                      # Foundry 라이브러리 (forge-std)
├── week-01/
│   ├── theory/               # 이론 퀴즈
│   │   └── quiz-01-template.md
│   └── dev/                  # 개발 과제
│       ├── src/              # 구현할 컨트랙트
│       ├── test/             # 제공되는 테스트
│       └── script/           # 배포 스크립트
├── week-02/ ... week-06/     # 각 주차별 동일 구조
└── .github/
    ├── PULL_REQUEST_TEMPLATE.md
    └── ISSUE_TEMPLATE/
        └── help-request.md
```

---

Made with by Bay-17th
