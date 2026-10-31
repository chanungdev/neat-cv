# neat-cv

Typst 기반 이력서·경력기술서 PDF 생성기. YAML 데이터만 수정하면 됩니다.

## 사용법

[Typst](https://github.com/typst/typst) 설치 후 레포 루트에서:

```sh
typst compile --root . --font-path fonts templates/resume.typ out/resume.pdf
typst compile --root . --font-path fonts templates/career-detail.typ out/career-detail.pdf

# 저장할 때마다 자동 재생성
typst watch --root . --font-path fonts templates/resume.typ out/resume.pdf
```

VS Code에서는 [Tinymist](https://marketplace.visualstudio.com/items?itemName=myriad-dreamin.tinymist) 확장으로 미리볼 수 있습니다. 레포 루트를 열면 `.vscode/settings.json`의 폰트 경로가 적용됩니다.

## 폰트

`fonts/`에 포함:

- [Pretendard](https://github.com/orioncactus/pretendard) v1.3.9 (Regular, Medium, Bold). SIL OFL 1.1 (`fonts/OFL.txt`)

## 아이콘

연락처 아이콘은 [Tabler Icons](https://tabler.io/icons) (MIT)를 [`@preview/iconify`](https://typst.app/universe/package/iconify) 패키지로 사용합니다. 패키지는 첫 빌드 때 자동으로 내려받습니다 (인터넷 필요).

`icons/tabler.json`에는 쓰는 아이콘만 들어 있습니다. 아이콘을 추가하려면 [icones.js.org](https://icones.js.org/collection/tabler)에서 이름을 찾아 `icons=` 목록에 넣고 다시 받으세요:

```sh
curl -s "https://api.iconify.design/tabler.json?icons=device-mobile,mail,home,brand-github,brand-linkedin" -o icons/tabler.json
```

## 데이터

`data/career.yaml`은 가상 샘플입니다. 다른 파일을 쓰려면 `--input data=`로 경로를 넘깁니다.
경로는 **`/`로 시작하는 `--root` 기준 경로**여야 합니다 (`/` 없으면 `templates/` 기준).

```sh
typst compile --root . --font-path fonts --input data=/data/my-career.yaml templates/resume.typ out/resume.pdf
```

### 작성법

샘플을 복사해서 내용을 바꾸는 것이 가장 빠릅니다.

```sh
cp neat-cv/data/career.yaml career.yaml   # private 레포에서
```

| 필드 | 설명 |
|---|---|
| `profile.name`, `title` | 이름, 직함 (이름 옆 강조색) |
| `profile.headline` | 이름 아래 한 줄 소개. "누구이고 무엇을 잘하는가" |
| `profile.contacts` | `{ type, value }` 목록. type: `phone`, `email`, `homepage`, `github`, `linkedin` |
| `profile.summary` | 소개 문단 |
| `skills` | `{ category, items: [...] }` 목록 |
| `experience` | `{ company, role, period, highlights }` 목록. 직무(role)는 강조색. `highlights`(주요 수행 내역 목록)는 선택 |
| `projects` | 아래 참고 |
| `education` | `{ school, major, period }` 목록 |
| `certifications` | `{ name, issuer, date }` 목록 (선택). 없으면 자격증 섹션을 출력하지 않음 |

`projects` 항목:

| 필드 | 이력서 | 경력기술서 | 설명 |
|---|:-:|:-:|---|
| `name`, `period`, `client`, `role` | ✅ | ✅ | 프로젝트명, 기간, 고객사, 역할 |
| `impact` | ✅ | ✅ | 성과 한 줄. 요약 표와 각 프로젝트 첫 줄에 표시 |
| `stack` | | ✅ | 기술 스택 목록 |
| `summary` | | ✅ | 프로젝트 개요 |
| `highlights` | | ✅ | 담당 업무 및 성과 목록. "결과: 방법" 순서 권장 |

작성 팁:

- **경력과 프로젝트 역할 분리**: 경력 `highlights`에는 역할·범위·조직 기여를, 프로젝트 `impact`/`highlights`에는 정량 성과를 써서 이력서에서 같은 내용이 반복되지 않게 합니다.
- **강조**: `skills.items`, `impact`, `highlights`(경력·프로젝트)에서 `*텍스트*`로 감싸면 강조색 굵게 표시됩니다. 숫자 위주로 쓰세요.
- 값이 `*`로 시작하면 YAML 문법과 겹치므로 따옴표로 감쌉니다: `"*Vue 3*"`, `"*로딩 4.2초 → 1.8초*: 번들 분할"`
- 기간 등 YAML이 숫자로 해석할 수 있는 값(`2025.03`)은 `2025.03 – 2025.12`처럼 문장 형태로 쓰거나 따옴표로 감쌉니다.
- 고객사명은 NDA를 확인하고 필요하면 `대형 홈쇼핑사`처럼 익명화하세요.
- 프로젝트 항목은 페이지 사이에서 쪼개지지 않습니다. 남은 공간이 모자라면 제목부터 다음 페이지로 넘어갑니다.

### private 레포에서 사용하기

실제 이력은 private 레포에 두고, 이 레포를 submodule로 가져다 쓰는 구성을 권장합니다.
Typst는 `--root` 밖의 파일을 읽을 수 없으므로 root를 private 레포 루트로 지정합니다.

```
my-career/              ← private 레포 (root)
├── career.yaml
└── neat-cv/            ← git submodule add https://github.com/chanungdev/neat-cv
```

```sh
typst compile --root . --font-path neat-cv/fonts --input data=/career.yaml \
  neat-cv/templates/resume.typ out/resume.pdf
```

VS Code 미리보기도 쓰려면 private 레포의 `.vscode/settings.json`에 아래를 추가합니다:

```json
{
  "tinymist.fontPaths": ["${workspaceFolder}/neat-cv/fonts"],
  "tinymist.typstExtraArgs": ["--input", "data=/career.yaml"]
}
```
