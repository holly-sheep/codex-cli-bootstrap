# Codex CLI Bootstrap

처음 개발 환경을 만드는 사람도 **Codex CLI를 안전하게 설치하고 실행**할 수 있게 도와주는 설치 도구입니다.

Codex CLI는 터미널에서 사용하는 OpenAI의 코딩 도우미입니다. 이 저장소는 Codex CLI만 설치하는 방법과, 개발에 자주 필요한 기본 도구까지 한 번에 준비하는 방법을 함께 제공합니다.

## 먼저 여기서 시작하세요

| 내 상황 | 어디로 가야 하나요? | 설명 |
| --- | --- | --- |
| **Windows를 쓰고 있고 WSL/Ubuntu/winget이 뭔지 모름** | [Windows 완전 초보자용 설치 순서](docs/WINDOWS-BEGINNER.md) | Windows 사용자는 여기부터 시작하세요. |
| Windows에 WSL2/Ubuntu가 아직 없음 | [Windows PowerShell에서 전체 설치](#windows-powershell) | Windows 설치 스크립트가 WSL2와 Ubuntu 준비까지 안내합니다. |
| macOS를 쓰고 있고 Codex CLI만 빨리 설치하고 싶음 | [빠른 설치](#빠른-설치-codex-cli만-설치) | macOS 터미널에서 실행하는 가장 작은 설치 경로입니다. |
| 이미 Linux 또는 WSL Ubuntu를 쓸 줄 앎 | [빠른 설치](#빠른-설치-codex-cli만-설치) | 이미 Linux/WSL 환경이 준비된 사람용입니다. |
| 설치 중 에러가 남 | [문제 해결](docs/TROUBLESHOOTING.md) | 자주 막히는 상황별 해결 방법을 모았습니다. |

> Windows 초보자라면 `bash scripts/codex/install-release.sh`부터 실행하지 마세요. 먼저 Windows 안내를 따라 WSL2와 Ubuntu를 준비해야 합니다.

## Windows 사용자는 이것만 알면 됩니다

Windows에서 `winget`, `WSL`, `Ubuntu`라는 단어를 몰라도 괜찮습니다.

- `winget`: Windows가 프로그램을 자동 설치할 때 쓰는 Microsoft 기본 설치 도우미입니다. 사용자가 직접 배울 필요는 없습니다.
- `WSL`: Windows 안에서 Linux를 실행하게 해주는 기능입니다.
- `Ubuntu`: WSL 안에서 열리는 Linux 앱입니다. 설치 후 Codex는 여기에서 실행합니다.
- `PowerShell`: Windows 시작 메뉴에서 검색해서 여는 명령어 앱입니다. 처음 설치할 때는 **관리자 권한으로 실행**을 추천합니다.

Windows 사용자는 먼저 [Windows 완전 초보자용 설치 순서](docs/WINDOWS-BEGINNER.md)를 따라 하세요. 화면에서 무엇을 열고, 어느 폴더에서, 어떤 명령을 붙여넣는지 순서대로 설명합니다.

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

> Windows에 WSL2나 Ubuntu가 아직 없다면 이 빠른 설치부터 실행하지 마세요. 먼저 [Windows PowerShell에서 전체 설치](#windows-powershell)로 가서 WSL2와 Ubuntu를 준비하세요.

### 1. 저장소 받기

Git을 알고 있다면:

```bash
git clone https://github.com/holly-sheep/codex-cli-bootstrap.git
cd codex-cli-bootstrap
```

Git이 아직 어렵다면 ZIP으로 받아도 됩니다.

1. 브라우저에서 이 주소를 엽니다: https://github.com/holly-sheep/codex-cli-bootstrap
2. 초록색 **Code** 버튼을 누릅니다.
3. **Download ZIP**을 누릅니다.
4. 다운로드된 ZIP 파일의 압축을 풉니다.
5. 압축을 푼 뒤, `README.md`와 `scripts` 폴더가 바로 보이는 폴더를 엽니다. 폴더 이름은 `codex-cli-bootstrap-main`처럼 보일 수도 있습니다.
6. `scripts` 폴더가 보이지 않으면 한 단계 더 안쪽 폴더를 열어보세요.
7. Windows에서는 그 폴더 안의 빈 곳을 `Shift + 마우스 오른쪽 클릭`한 뒤 **터미널에서 열기** 또는 **PowerShell 창 열기**를 선택할 수 있습니다. 단, 처음 WSL 설치는 관리자 권한 PowerShell이 더 안전합니다.

자세한 화면 흐름은 [초보자용 설치 안내](docs/BEGINNER-GUIDE.md)를 보세요.

### 2. 설치 실행

아래 명령은 macOS 터미널, Linux 터미널, 또는 이미 준비된 Ubuntu 앱 안에서 실행하는 명령입니다. Windows PowerShell에 붙여넣는 명령이 아닙니다.

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

WSL2나 Ubuntu가 아직 없어도 여기로 오면 됩니다. 이 Windows 설치 스크립트는 가능한 경우 아래 순서로 준비합니다.

1. Windows 기본 설치 도우미(`winget`)가 있는지 확인
2. Git for Windows 설치
3. WSL2 기본값 설정
4. Ubuntu가 없으면 Ubuntu 설치 시작
5. Ubuntu가 WSL1이면 WSL2로 업그레이드
6. Ubuntu 안에서 Linux 개발 도구와 Codex CLI 설치

관리자 권한 PowerShell에서 실행하는 것을 권장합니다. `winget`이 뭔지 몰라도 됩니다. 없으면 스크립트가 멈추고 Microsoft Store의 **App Installer**를 설치/업데이트하라고 알려줍니다.

관리자 PowerShell을 직접 열었다면 먼저 저장소 폴더로 이동해야 합니다.

1. 파일 탐색기에서 압축을 푼 폴더를 엽니다.
2. `README.md`와 `scripts` 폴더가 바로 보이는지 확인합니다.
3. 파일 탐색기 위쪽 주소 표시줄을 클릭하고 `Ctrl+C`로 폴더 경로를 복사합니다.
4. 관리자 PowerShell에 아래 3줄을 붙여넣되, 첫 줄의 따옴표 안에는 방금 복사한 폴더 경로를 붙여넣습니다.

```powershell
Set-Location -LiteralPath "여기에_복사한_폴더_경로를_붙여넣으세요"
$env:CODEX_BOOTSTRAP_ALLOW_PACKAGE_INSTALLS = "1"
powershell -ExecutionPolicy Bypass -File .\scripts\windows\install.ps1
```

예시는 아래처럼 보입니다.

```powershell
Set-Location -LiteralPath "C:\Users\내이름\Downloads\codex-cli-bootstrap-main"
$env:CODEX_BOOTSTRAP_ALLOW_PACKAGE_INSTALLS = "1"
powershell -ExecutionPolicy Bypass -File .\scripts\windows\install.ps1
```

위 명령은 **Windows PowerShell**에 입력합니다. Ubuntu 앱에 입력하는 명령이 아닙니다.

Windows에서는 Codex CLI가 Windows 본체가 아니라 **WSL Ubuntu 안에 설치**됩니다. 설치 후에는 Ubuntu를 열고 `codex`를 실행하세요.

`.\scripts\windows\install.ps1` 파일을 찾을 수 없다는 메시지가 나오면 PowerShell 위치가 잘못된 것입니다. `README.md`와 `scripts` 폴더가 바로 보이는 폴더로 이동한 뒤 다시 실행하세요.

처음 설치 중 재부팅하라고 나오거나 Ubuntu 사용자 이름/비밀번호를 만들라고 나오면 정상입니다. 그 과정을 끝낸 뒤 아래 순서로 다시 실행하세요.

다시 실행해야 할 때는 매번 아래 순서를 반복하세요.

1. 파일 탐색기에서 압축을 푼 폴더를 다시 엽니다.
2. `README.md`와 `scripts` 폴더가 바로 보이는지 확인합니다.
3. 파일 탐색기 위쪽 주소 표시줄을 클릭하고 `Ctrl+C`로 복사합니다.
4. 관리자 권한 Windows PowerShell을 엽니다.
5. 아래 3줄을 입력합니다. 첫 줄의 따옴표 안에는 방금 복사한 폴더 경로를 붙여넣습니다.

```powershell
Set-Location -LiteralPath "여기에_복사한_폴더_경로를_붙여넣으세요"
$env:CODEX_BOOTSTRAP_ALLOW_PACKAGE_INSTALLS = "1"
powershell -ExecutionPolicy Bypass -File .\scripts\windows\install.ps1
```

예시는 아래처럼 보입니다.

```powershell
Set-Location -LiteralPath "C:\Users\내이름\Downloads\codex-cli-bootstrap-main"
$env:CODEX_BOOTSTRAP_ALLOW_PACKAGE_INSTALLS = "1"
powershell -ExecutionPolicy Bypass -File .\scripts\windows\install.ps1
```

## 설치 후 첫 실행

macOS 또는 Linux/WSL 터미널에서:

```bash
codex
```

Windows에서는 시작 메뉴에서 **Ubuntu**를 열고 아래 명령을 입력합니다.

```bash
codex
```

처음 실행하면 로그인 안내가 나올 수 있습니다. 화면에 웹사이트 주소나 로그인 안내가 보이면 그대로 따라 하세요. 브라우저가 열리면 본인의 ChatGPT/OpenAI 계정으로 로그인합니다. 로그인 후 터미널 또는 Ubuntu 창으로 돌아오면 Codex를 사용할 수 있습니다.

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

- [Windows 완전 초보자용 설치 순서](docs/WINDOWS-BEGINNER.md)
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
