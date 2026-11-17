# Sushiden-Guide

# 🍣 스시덴도감 (SUSHIDEN DOGAM)

> 첫 알바, 레벨 1부터 시작하자! — 스시덴고쿠 신입 알바생을 위한 레트로 게임형 생존 도감

## 1. 구현한 페이지

| 화면 | 주소 | 기능 |
|---|---|---|
| 홈 | `#/` | 히어로, 오늘의 팁, 스테이지, 추천 공략, 최근 글 |
| 생존도감 | `#/stages` | 5개 스테이지 선택 |
| 분야별 목록 | `#/stage/start` 등 | 카테고리별 공략 자동 표시 |
| 공략 상세 | `#/guide/first-day` 등 | 단계별 가이드, 목차, 로컬 체크리스트, 관련 공략 |
| 검색 | `#/search?q=면접` | 제목·내용·카테고리 검색 |
| 경험 공유 | `#/community` | 분류, 검색, 목록, 상세 |
| 글 작성 | `#/write` | Supabase 연결 시 로그인 회원 작성 |
| 도감 소개 | `#/about` | 소개, 이용 방법, 문의 |
| 로그인 | `#/auth` | Supabase 이메일 로그인, 회원가입, 비밀번호 재설정 |

**중요:** 기본 실행은 **시연 모드**입니다. 검색, 공략, 이동, 체크리스트는 작동하지만, 실제 회원가입·공유 게시글 저장·댓글·문의 전송은 Supabase 연결 전에는 비활성화됩니다. 예시 게시글은 실제 회원 글이 아닙니다.

## 2. 실제 회원가입·게시판 기능 연결

GitHub Pages는 정적 호스팅이므로 WordPress 플러그인을 사용할 수 없습니다. 대신 [Supabase](https://supabase.com/)의 인증·Postgres 데이터베이스를 사용합니다.

1. Supabase에서 프로젝트 생성.
2. SQL Editor에서 `docs/supabase.sql` 실행. (기존 정책이 있는 DB에서 재실행 시 정책 중복 오류가 날 수 있으니 새 프로젝트 권장.)
3. `.env.example`을 `.env`로 복사하고 `VITE_SUPABASE_URL`, `VITE_SUPABASE_ANON_KEY` 입력. **service_role 키를 넣지 마세요.**
4. Supabase Authentication > Providers에서 Email 활성화. Authentication > URL Configuration에 배포 주소 및 redirect URL 등록.
5. `npm run dev` 재시작.
6. 회원가입 → 이메일 확인(설정된 경우) → 로그인 → 글 작성·댓글·수정·삭제 테스트.

RLS(Row Level Security)가 작성자만 수정/삭제하도록 제한합니다. 운영 사이트에서는 CAPTCHA, 게시글 신고, 스팸 필터, 관리자 검수 정책을 추가하세요.

### 문의 양식 주의

SQL의 기본 정책은 **로그인 사용자만 문의 제출**을 허용합니다. 익명 방문자의 문의까지 받으려면 CAPTCHA와 서버리스 함수(예: Supabase Edge Functions) 또는 Formspree 같은 외부 문의 서비스가 필요합니다. 브라우저에 비밀 API 키를 넣지 마세요. 문의 내용은 공개 조회되지 않습니다.

## 3. 콘텐츠 수정

- `src/data.js` → `stages`: 5개 카테고리 정보
- `src/data.js` → `guides`: 공략 제목, 설명, 단계, 팁, 체크리스트
- `src/data.js` → `tips`: 오늘의 생존 팁
- `src/data.js` → `samplePosts`: 시연용 게시글
- `src/style.css`: 색상·레이아웃·반응형 디자인
- `src/main.js`: 페이지 구성, 라우팅, 인증·게시판 로직

공략은 `guides` 배열에 항목을 추가하면 자동으로 해당 카테고리에 표시됩니다. 현재 공략은 예시이며 **스시덴고쿠의 실제 운영 규정이 아닙니다.**

## 4. 법령·정보 검증

급여·근로 글은 일반적인 학습용 안내입니다. 최저임금, 주휴수당, 휴게시간 등 법령은 바뀔 수 있으므로 게시 전 [고용노동부](https://www.moel.go.kr/)와 [국가법령정보센터](https://www.law.go.kr/)에서 최신 기준을 확인하고, 공략 데이터에 검토 기준일과 출처를 추가하는 것이 좋습니다.

## 5. 사용 기술 및 제한

- Vite / HTML / CSS / JavaScript / Supabase JS SDK
- 해시 라우터(`#/...`)로 GitHub Pages 새로고침 시 404 방지
- 반응형 그리드, 키보드 포커스 표시, 텍스트 이스케이프 처리
- 아이콘은 현재 이모지와 CSS 일러스트로 구현 (정식 픽셀 아트 PNG/SVG로 추후 교체 가능)
- 체크리스트는 **현재 브라우저 localStorage**에만 저장되며 기기 간 동기화되지 않음
- 게시글 목록은 최근 100개까지 로드. 대규모 운영 시 서버 페이지네이션 필요
- Supabase 이메일 인증 및 비밀번호 재설정은 Supabase 프로젝트 설정과 이메일 템플릿에 따라 동작
- 문의 메일 발송 기능은 구현되지 않으며 DB에 접수되는 방식
