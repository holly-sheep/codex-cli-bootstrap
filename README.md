# Codex CLI Bootstrap

`macOS`와 `Windows` 사용자가 `Codex CLI`를 쓰기 전에 필요한 기본 도구를 자동으로 설치하는 레포입니다.

## 설치되는 항목

- `macOS`
  - `Homebrew` (없을 때만)
  - `Git` (없을 때만)
  - `Codex CLI` (`brew install --cask codex`)
- `Windows`
  - `Git for Windows`
  - `Node.js LTS`
  - 사용자 전용 `npm global prefix`
  - `Codex CLI` (`npm install -g @openai/codex`)

## 지원 환경

- `macOS 13+`
- `Windows 10/11` with `winget`

## 사용 방법

### macOS

```bash
git clone https://github.com/hollysheep-ai/codex-cli-bootstrap.git
cd codex-cli-bootstrap
bash scripts/macos/install.sh
```

### Windows

```powershell
git clone https://github.com/hollysheep-ai/codex-cli-bootstrap.git
cd codex-cli-bootstrap
powershell -ExecutionPolicy Bypass -File .\scripts\windows\install.ps1
```

## 설치 후

1. 새 터미널을 엽니다.
2. `codex`를 실행합니다.
3. `Sign in with ChatGPT` 또는 API 키 방식으로 로그인합니다.

## 동작 방식

- 스크립트는 이미 설치된 구성 요소를 감지하고 필요한 것만 설치합니다.
- `Windows`에서는 관리자 권한 없이 `Codex CLI`를 설치할 수 있도록 `npm` 전역 설치 경로를 사용자 폴더로 바꿉니다.
- 설치가 끝나면 `git --version`, `node --version`(Windows), `codex --version`을 확인합니다.

## 주의 사항

- `Windows` 스크립트는 `winget`이 필요합니다. 없다면 Microsoft `App Installer`를 먼저 최신 상태로 맞춰야 합니다.
- `macOS` 스크립트는 공식 `Homebrew` 설치 스크립트를 사용하므로 인터넷 연결이 필요합니다.
- 이 레포는 `Codex CLI` 설치와 선행 도구 준비까지만 자동화합니다. 계정 로그인과 실제 모델 설정은 사용자 단계입니다.

## 검증

GitHub Actions에서 아래를 검사하도록 포함했습니다.

- `bash` 문법 검사
- `PowerShell` 파서 검사

## 라이선스

`MIT`
