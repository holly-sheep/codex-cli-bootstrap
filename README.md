# Codex CLI Bootstrap

처음 개발 환경을 만드는 사람도 **Codex CLI를 안전하게 설치하고 실행**할 수 있게 도와주는 설치 도구입니다.

Codex CLI는 터미널에서 사용하는 OpenAI의 코딩 도우미입니다. 이 저장소는 Codex CLI만 설치하는 방법과, 개발에 자주 필요한 기본 도구까지 한 번에 준비하는 방법을 함께 제공합니다.

## 누구를 위한 저장소인가요?

- Codex CLI를 처음 써보는 사람
- macOS 또는 Windows에서 개발 환경을 처음 맞추는 사람
- `Git`, `Python`, `Node.js`, `WSL` 같은 단어가 아직 낯선 사람
- 팀원에게 “이거 따라 하면 Codex 쓸 수 있어요”라고 안내해야 하는 사람

## 먼저 선택하세요

| 상황 | 추천 경로 | 설명 |
| --- | --- | --- |
| 지금 바로 Codex CLI만 설치하고 싶음 | [빠른 설치](#빠른-설치-codex-cli만-설치) | 패키지 매니저를 거의 건드리지 않는 가장 작은 설치 경로입니다. |
| 새 컴퓨터에 개발 기본 도구까지 준비하고 싶음 | [전체 개발 환경 설치](#전체-개발-환경-설치) | Git, Python, ripgrep, Node.js, Codex CLI 등을 같이 준비합니다. |
| Windows를 처음 설정함 | [Windows 초보자 안내](docs/BEGINNER-GUIDE.md#windows에서-설치하기) | WSL/Ubuntu를 쓰는 방식이라 처음에는 단계가 조금 더 많습니다. |
| 설치 중 에러가 남 | [문제 해결](docs/TROUBLESHOOTING.md) | 자주 막히는 상황별 해결 방법을 모았습니다. |

> 현재 이 저장소의 전체 bootstrap 스크립트는 공급망 리스크를 줄이기 위해 기본값으로 패키지 설치를 막아둡니다. 자세한 이유는 [공급망 동결 안내](docs/SUPPLY-CHAIN-FREEZE.md)를 보세요.

## 이 저장소가 설치하거나 준비하는 것

### 빠른 설치 경로

- Codex CLI 실행 파일
- 기본 설치 위치: `$HOME/.local/bin/codex`
- macOS와 Linux/WSL 지원
- 다운로드한 파일의 SHA-256 체크섬 검증

### 전체 개발 환경 경로

macOS에서는 다음을 준비합니다.

- Xcode Command Line Tools
- Homebrew
- Git
- Python 3
- ripgrep
- Codex CLI

Windows에서는 `WSL2 + Ubuntu` 안에 개발 환경을 준비합니다.

- Git for Windows
- WSL2
- Ubuntu
- Ubuntu 내부 Git, Python 3, build-essential, ripgrep
- Ubuntu 내부 Node.js 20 LTS
- Ubuntu 내부 Codex CLI

## 빠른 설치: Codex CLI만 설치

이 방법은 macOS, Linux, 이미 준비된 WSL Ubuntu에서 사용할 수 있습니다.

### 1. 저장소 받기

Git을 알고 있다면:

```bash
git clone https://github.com/holly-sheep/codex-cli-bootstrap.git
cd codex-cli-bootstrap
```

Git이 아직 어렵다면:

1. GitHub 페이지에서 초록색 **Code** 버튼을 누릅니다.
2. **Download ZIP**을 누릅니다.
3. 압축을 풉니다.
4. 터미널에서 압축을 푼 폴더로 이동합니다.

자세한 화면 흐름은 [초보자용 설치 안내](docs/BEGINNER-GUIDE.md)를 보세요.

### 2. 설치 실행

```bash
bash scripts/codex/install-release.sh
```

설치가 끝난 뒤 아래처럼 확인합니다.

```bash
codex --version
```

`codex: command not found`가 나오면 [문제 해결](docs/TROUBLESHOOTING.md#codex-command-not-found가-나올-때)을 보세요.

## 전체 개발 환경 설치

전체 설치는 `brew`, `apt`, `npm`, `winget` 같은 패키지 매니저를 사용합니다. 그래서 기본값으로는 실행이 막혀 있습니다.

정말로 전체 설치를 진행하려면 아래처럼 `CODEX_BOOTSTRAP_ALLOW_PACKAGE_INSTALLS=1`을 명시해야 합니다.

### macOS

```bash
CODEX_BOOTSTRAP_ALLOW_PACKAGE_INSTALLS=1 bash scripts/macos/install.sh
```

### Linux 또는 WSL Ubuntu

```bash
CODEX_BOOTSTRAP_ALLOW_PACKAGE_INSTALLS=1 bash scripts/linux/install.sh
```

### Windows PowerShell

관리자 권한 PowerShell에서 실행하는 것을 권장합니다.

```powershell
$env:CODEX_BOOTSTRAP_ALLOW_PACKAGE_INSTALLS = "1"
powershell -ExecutionPolicy Bypass -File .\scripts\windows\install.ps1
```

Windows에서는 Codex CLI가 Windows 본체가 아니라 **WSL Ubuntu 안에 설치**됩니다. 설치 후에는 Ubuntu를 열고 `codex`를 실행하세요.

## 설치 후 첫 실행

macOS 또는 Linux/WSL 터미널에서:

```bash
codex
```

처음 실행하면 로그인이 필요할 수 있습니다. 안내에 따라 ChatGPT 계정으로 로그인하거나, 본인이 사용하는 인증 방식을 설정하세요.

## 설치 확인 명령어

macOS:

```bash
git --version
python3 --version
rg --version
codex --version
```

Linux/WSL:

```bash
git --version
python3 --version
g++ --version
rg --version
node --version
codex --version
```

## 문서 구조

- [초보자용 설치 안내](docs/BEGINNER-GUIDE.md)
- [공급망 동결 안내](docs/SUPPLY-CHAIN-FREEZE.md)
- [문제 해결](docs/TROUBLESHOOTING.md)

## 자주 하는 질문

### 왜 Windows는 WSL을 쓰나요?

Codex CLI와 개발 도구는 Linux 환경에서 더 일관되게 동작합니다. 그래서 Windows에서는 WSL2 위의 Ubuntu를 기본 개발 공간으로 사용합니다.

### 왜 Python이나 C++ 도구까지 설치하나요?

Codex CLI 자체만 실행하는 데 항상 필요한 것은 아닙니다. 하지만 실제 프로젝트를 열면 Python 스크립트, 네이티브 패키지 빌드, 코드 검색 도구가 자주 필요합니다. “설치는 됐는데 프로젝트에서 바로 막히는 상황”을 줄이기 위해 같이 준비합니다.

### 이 스크립트가 Codex 로그인을 대신해주나요?

아니요. 설치만 도와줍니다. Codex CLI 로그인은 사용자가 직접 진행해야 합니다.

## 검증

GitHub Actions에서 다음을 검사합니다.

- Bash 문법 검사
- PowerShell 파서 검사
- Linux 설치 스모크 테스트
- Codex release binary 설치 스모크 테스트
- Windows WSL 배포판 선택 로직 테스트

## 라이선스

MIT
