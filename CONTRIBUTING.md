# 과제 제출 가이드

이 문서는 이더리움 온보딩 과제의 제출 방법을 상세히 설명합니다.

## 목차

- [브랜치 명명 규칙](#브랜치-명명-규칙)
- [제출 프로세스](#제출-프로세스)
- [제출물 종류](#제출물-종류)
- [커밋 메시지 규칙](#커밋-메시지-규칙)
- [주의사항](#주의사항)

## 브랜치 명명 규칙

### 형식

```
{github-username}/week-{주차번호}
```

### 예시

| GitHub 사용자명 | 주차 | 브랜치명 |
|----------------|------|----------|
| ahwlsqja | 1주차 | `ahwlsqja/week-01` |
| nubro999 | 3주차 | `nubro999/week-03` |
| student123 | 2주차 | `student123/week-02` |

### 규칙

- 주차 번호는 두 자리 숫자로 작성 (01, 02, ... 06)
- 브랜치명은 모두 소문자 사용
- GitHub 사용자명은 정확히 입력

## 제출 프로세스

### Step 1: 저장소 클론 (최초 1회)

```bash
git clone --recurse-submodules https://github.com/your-org/eth-homework.git
cd eth-homework
```

이미 클론했다면 최신 상태로 업데이트:

```bash
git checkout main
git pull origin main
git submodule update --init --recursive
```

### Step 2: 브랜치 생성

```bash
git checkout -b {username}/week-{XX}
```

예시:
```bash
git checkout -b ahwlsqja/week-01
```

### Step 3: 과제 수행

해당 주차의 과제를 완성합니다:
- 이론: `week-XX/theory/` 폴더의 퀴즈 답안 작성
- 개발: `week-XX/dev/src/` 폴더의 컨트랙트 구현

### Step 4: 테스트 실행

개발 과제는 반드시 테스트를 통과해야 합니다:

```bash
# 전체 테스트
forge test

# 특정 파일만 테스트
forge test --match-path "week-01/dev/test/*.sol"

# 상세 출력 (-vvv)
forge test -vvv
```

### Step 5: 커밋

```bash
git add .
git commit -m "feat(week-01): complete counter assignment"
```

### Step 6: 푸시

```bash
git push -u origin {username}/week-{XX}
```

### Step 7: Pull Request 생성

1. GitHub 저장소 페이지로 이동
2. "Compare & pull request" 버튼 클릭
3. PR 템플릿에 따라 내용 작성
   - 구현한 내용 설명
   - 배운 점 기록
   - 어려웠던 점과 해결 방법
4. "Create pull request" 클릭

PR 템플릿은 자동으로 로드됩니다. 성찰적 학습을 위해 빈칸을 모두 채워주세요.

## 제출물 종류

### 이론 과제 (Theory)

| 항목 | 설명 |
|------|------|
| 위치 | `week-XX/theory/` |
| 형식 | Markdown 파일 |
| 제출 | `quiz-XX-template.md`를 복사하여 `quiz-XX-solution.md`로 저장 |

### 개발 과제 (Dev)

| 항목 | 설명 |
|------|------|
| 위치 | `week-XX/dev/src/` |
| 형식 | Solidity 파일 (.sol) |
| 검증 | `forge test` 통과 필수 |

## 커밋 메시지 규칙

### 형식

```
{type}(week-{XX}): {간단한 설명}
```

### Type 종류

| Type | 용도 |
|------|------|
| `feat` | 새로운 기능 구현 |
| `fix` | 버그 수정 |
| `docs` | 문서 작성/수정 |
| `refactor` | 코드 리팩토링 |
| `test` | 테스트 추가 |

### 예시

```bash
git commit -m "feat(week-01): implement Counter increment function"
git commit -m "fix(week-02): correct token transfer logic"
git commit -m "docs(week-03): add solution for theory quiz"
```

## 주의사항

### 절대 커밋하면 안 되는 파일

다음 파일들은 `.gitignore`에 포함되어 있지만, 실수로 추가하지 않도록 주의하세요:

| 파일/폴더 | 이유 |
|-----------|------|
| `.env` | 개인 API 키, Private Key 포함 |
| `out/` | 빌드 결과물 (컴파일 시 자동 생성) |
| `cache/` | Foundry 캐시 |
| `broadcast/` | 배포 기록 (테스트넷 제외) |

### 체크리스트

PR 제출 전 확인사항:

- [ ] 브랜치명이 `{username}/week-{XX}` 형식인가?
- [ ] `forge build`가 에러 없이 완료되는가?
- [ ] `forge test`가 모두 통과하는가?
- [ ] `.env` 파일이 커밋에 포함되지 않았는가?
- [ ] PR 템플릿의 모든 항목을 작성했는가?

### 도움 요청

과제 수행 중 막히는 부분이 있다면:

1. [Issue 생성](https://github.com/your-org/eth-homework/issues/new?template=help-request.md)
2. 같은 주차 동기들과 토론
3. PR에 코멘트로 질문

---

질문이 있으시면 Issue를 통해 문의해주세요!
