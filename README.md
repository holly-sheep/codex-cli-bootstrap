# Codex CLI Bootstrap

`macOS`와 `Windows` 사용자가 `Codex CLI`를 바로 쓰기 전에 필요한 개발 환경을 자동으로 준비하는 레포입니다.

이 레포는 단순히 `Codex CLI`만 설치하지 않습니다. 실제로 바로 개발 작업을 시작할 수 있도록 기본 개발 도구까지 같이 맞춥니다.

## 공급망 동결 안내

현재 패키지 공급망 리스크가 있는 동안 이 설치 스크립트는 기본값으로 패키지 설치와 업데이트를 중단합니다.

차단되는 작업:

- `xcode-select --install`
- `brew install`, `brew install --cask`
- `apt-get update`, `apt-get install`
- NodeSource 설치 스크립트 실행
- `npm install -g @openai/codex`
- `winget install`
- 신규 `WSL`/`Ubuntu` 설치 또는 WSL 버전 업그레이드

공급망 동결을 해제한 뒤에만 아래 환경 변수를 명시적으로 설정해서 실행하세요.

macOS/Linux:

```bash
CODEX_BOOTSTRAP_ALLOW_PACKAGE_INSTALLS=1 bash scripts/macos/install.sh
CODEX_BOOTSTRAP_ALLOW_PACKAGE_INSTALLS=1 bash scripts/linux/install.sh
```

Windows PowerShell:

```powershell
$env:CODEX_BOOTSTRAP_ALLOW_PACKAGE_INSTALLS = "1"
powershell -ExecutionPolicy Bypass -File .\scripts\windows\install.ps1
```

## 설치되는 항목

### macOS

- `Xcode Command Line Tools`
- `Homebrew` (없을 때만)
- `Git`
- `Python 3`
- `ripgrep`
- `Codex CLI`

### Windows

Windows는 `WSL2 + Ubuntu`를 기본 경로로 사용합니다.

- `winget` (`Microsoft App Installer`)
- `Git for Windows`
- `WSL2`
- `Ubuntu` 배포판
- WSL 내부 `Git`
- WSL 내부 `curl` / `ca-certificates`
- WSL 내부 `build-essential`
- WSL 내부 `Python 3`, `python3-venv`, `python3-pip`
- WSL 내부 `ripgrep`
- WSL 내부 `Node.js 20 LTS`
- WSL 내부 `Codex CLI`

## 왜 Python과 C++ 개발 도구까지 넣었나

`Codex CLI` 자체는 주로 `Node.js` 기반으로 동작합니다. 하지만 실제 개발 환경에서는 아래가 자주 필요합니다.

- `Python`
  - Python 프로젝트 실행
  - 가상환경 생성
  - 스크립트 자동화
- `build-essential` 또는 `Xcode Command Line Tools`
  - `gcc` / `g++` / `make`
  - 네이티브 모듈 빌드
  - 일부 `npm` 패키지나 Python 패키지 컴파일
- `ripgrep`
  - 대형 코드베이스 검색

즉, `Codex`를 설치만 해놓고 실제 프로젝트에서 바로 막히지 않도록 베이스라인을 같이 준비하는 구성입니다.

## 지원 환경

- `macOS 13+`
- `Windows 10/11`
- `Windows`에서는 BIOS/UEFI 가상화와 WSL 사용이 가능한 상태여야 합니다.

## 사용 방법

`Git`이 아직 없는 Windows 사용자도 시작할 수 있도록 ZIP 다운로드 방식으로 써도 됩니다.

### 1. 레포 받기

선택 1:

```bash
git clone https://github.com/hollysheep-ai/codex-cli-bootstrap.git
cd codex-cli-bootstrap
```

선택 2:

- GitHub 레포에서 `Code > Download ZIP`
- 압축 해제
- 해당 폴더로 이동

### 2. macOS 설치

터미널에서 실행:

```bash
bash scripts/macos/install.sh
```

### 3. Windows 설치

중요:

- 첫 실행은 `PowerShell`을 관리자 권한으로 여는 편이 사실상 안전합니다.
- `winget`은 `Microsoft App Installer`를 통해 제공되어야 합니다.
- 첫 실행에서 `WSL2` 기능 설치나 `Ubuntu` 초기화 때문에 재부팅 또는 사용자 생성이 필요할 수 있습니다.
- 기존 `Ubuntu` 배포판이 `WSL1`이면 설치 중 `WSL2`로 업그레이드합니다.
- 그런 경우 안내에 따라 `Ubuntu`를 한 번 열어 Linux 사용자 생성을 끝낸 뒤, 같은 스크립트를 다시 실행하면 됩니다.

PowerShell에서 실행:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\windows\install.ps1
```

## 설치 후 사용

### macOS

새 터미널을 열고:

```bash
codex
```

### Windows

`Ubuntu` 또는 원하는 WSL 셸을 열고:

```bash
codex
```

## 설치 후 확인

### macOS

```bash
git --version
python3 --version
rg --version
codex --version
```

### Windows / WSL

```bash
git --version
python3 --version
g++ --version
rg --version
node --version
codex --version
```

## 동작 방식

- `macOS`는 로컬 셸 환경에 직접 설치합니다.
- `Windows`는 `WSL2`와 `Ubuntu`를 준비한 뒤, 실제 개발 도구 설치는 `Ubuntu` 안에서 수행합니다.
- `Windows` 쪽 `Codex CLI`도 `Windows` 본체가 아니라 `WSL` 안에 설치됩니다.

## 주의 사항

- `macOS`에서 `Xcode Command Line Tools`가 없으면 Apple 설치 UI가 열릴 수 있습니다.
- `Windows`에서 `WSL2` 첫 설치나 버전 업그레이드는 재부팅이 필요할 수 있습니다.
- `Windows`에서 `winget`이 없다면 먼저 `Microsoft Store`의 `App Installer`를 설치하거나 업데이트해야 합니다.
- `Codex CLI` 로그인은 자동화하지 않습니다. 설치 후 사용자가 직접 로그인해야 합니다.

## 검증

GitHub Actions에서 아래를 검사합니다.

- `bash` 문법 검사
- `PowerShell` 파서 검사
- Linux 설치 스모크 테스트
- Windows WSL distro 선택 로직 테스트

## 라이선스

`MIT`
