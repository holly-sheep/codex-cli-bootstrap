# 공급망 동결 안내

이 저장소의 전체 설치 스크립트는 기본값으로 패키지 설치와 업데이트를 막아둡니다.

## 왜 막아두었나요?

개발 환경 설치는 여러 외부 저장소와 패키지 매니저를 호출합니다.

예를 들면:

- Homebrew
- apt
- NodeSource 설치 스크립트
- npm 전역 설치
- winget
- WSL/Ubuntu 설치

이런 경로는 편리하지만, 공급망 리스크가 있는 시기에는 의도하지 않은 새 패키지나 변경된 설치 스크립트를 가져올 수 있습니다. 그래서 이 저장소는 사용자가 명시적으로 허용하기 전에는 전체 설치를 멈춥니다.

## 기본값으로 차단되는 작업

- `xcode-select --install`
- `brew install`, `brew install --cask`
- `apt-get update`, `apt-get install`
- NodeSource 설치 스크립트 실행
- `npm install -g @openai/codex`
- `winget install`
- 신규 WSL/Ubuntu 설치 또는 WSL 버전 업그레이드

## 전체 설치를 허용하는 방법

위 작업을 진행해도 된다고 판단한 경우에만 아래 환경 변수를 붙여 실행하세요.

macOS:

```bash
CODEX_BOOTSTRAP_ALLOW_PACKAGE_INSTALLS=1 bash scripts/macos/install.sh
```

Linux/WSL:

```bash
CODEX_BOOTSTRAP_ALLOW_PACKAGE_INSTALLS=1 bash scripts/linux/install.sh
```

Windows PowerShell:

```powershell
$env:CODEX_BOOTSTRAP_ALLOW_PACKAGE_INSTALLS = "1"
powershell -ExecutionPolicy Bypass -File .\scripts\windows\install.ps1
```

## Codex CLI만 설치하는 임시 안전 경로

패키지 매니저를 쓰지 않고 OpenAI 공식 GitHub Release의 Codex CLI binary를 직접 설치할 수 있습니다.

```bash
bash scripts/codex/install-release.sh
```

이 경로는 전체 개발 환경 설치가 아닙니다. Codex CLI 실행 파일만 설치합니다.

필요한 기본 도구:

- `curl`
- `tar`
- `shasum` 또는 `sha256sum`

기본 설치 위치:

```text
$HOME/.local/bin/codex
```

설치 위치를 바꾸려면:

```bash
CODEX_INSTALL_DIR="$HOME/bin" bash scripts/codex/install-release.sh
```

## 현재 고정된 Codex Release

기본값은 검증된 release `rust-v0.130.0`입니다.

| Platform | Asset | SHA-256 |
| --- | --- | --- |
| macOS arm64 | `codex-aarch64-apple-darwin.tar.gz` | `bc50a4b7f9a0c8ca99179189e4659b601107830770e21547dc0c246bce733577` |
| macOS x86_64 | `codex-x86_64-apple-darwin.tar.gz` | `feddb116bd96d7d83f8bb19b34fbabe6843cc64461baf2e49c017e1206ad5e67` |
| Linux arm64 | `codex-aarch64-unknown-linux-musl.tar.gz` | `1d7e00f2c22c3016b5bcb71c61010947b022a90e2901bc6baafe82256492c767` |
| Linux x86_64 | `codex-x86_64-unknown-linux-musl.tar.gz` | `16779e7b7857508a768a36d7d4e084eec336ec23946ed70a9b09489b8f861190` |

## 다른 Release를 쓰려면

태그만 바꾸면 안 됩니다. 반드시 SHA-256도 함께 지정해야 합니다.

```bash
CODEX_RELEASE_TAG="<approved-release-tag>" \
CODEX_RELEASE_SHA256="<approved-64-char-sha256>" \
bash scripts/codex/install-release.sh
```

## Digest 갱신 원칙

- OpenAI 공식 `openai/codex` release의 tag, asset name, GitHub API `digest` 값을 근거로 남깁니다.
- `latest`, alpha/pre-release, branch URL처럼 바뀔 수 있는 대상을 자동 추적하지 않습니다.
- digest를 바꿀 때는 `scripts/codex/install-release.sh`와 이 문서의 표를 함께 갱신합니다.
- 공식 release에 포함된 `install.sh` 또는 `install.ps1`도 바로 실행하지 말고 내용을 확인한 뒤 사용합니다.
