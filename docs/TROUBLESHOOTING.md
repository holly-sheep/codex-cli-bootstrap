# 문제 해결

설치 중 자주 만나는 문제와 해결 방법입니다.

## `codex: command not found`가 나올 때

### 1. 새 터미널을 열어보기

설치 직후에는 PATH 변경이 바로 반영되지 않을 수 있습니다. 터미널을 완전히 닫고 새로 열어보세요.

### 2. 직접 설치 경로 확인

빠른 설치 경로를 사용했다면 기본 설치 위치는 아래입니다.

```bash
$HOME/.local/bin/codex
```

아래 명령으로 직접 실행해볼 수 있습니다.

```bash
$HOME/.local/bin/codex --version
```

### 3. PATH에 추가

위 명령은 되는데 `codex`만 안 된다면 PATH에 설치 폴더를 추가합니다.

```bash
export PATH="$HOME/.local/bin:$PATH"
```

계속 유지하려면 사용하는 셸 설정 파일에도 추가합니다.

```bash
printf '\nexport PATH="$HOME/.local/bin:$PATH"\n' >> ~/.zshrc
```

bash를 쓴다면:

```bash
printf '\nexport PATH="$HOME/.local/bin:$PATH"\n' >> ~/.bashrc
```

## 공급망 동결 에러가 나올 때

아래와 비슷한 메시지가 나오면 정상적으로 차단된 것입니다.

```text
Package installation and update steps are currently disabled.
```

전체 개발 환경 설치는 패키지 매니저를 호출하기 때문에 명시적 허용이 필요합니다.

macOS:

```bash
CODEX_BOOTSTRAP_ALLOW_PACKAGE_INSTALLS=1 bash scripts/macos/install.sh
```

Linux/WSL:

```bash
CODEX_BOOTSTRAP_ALLOW_PACKAGE_INSTALLS=1 bash scripts/linux/install.sh
```

Windows PowerShell:

Windows에서는 먼저 파일 탐색기에서 `README.md`와 `scripts` 폴더가 바로 보이는 폴더 주소를 `Ctrl+C`로 복사한 뒤, 관리자 권한 Windows PowerShell에 아래 3줄을 입력합니다. 첫 줄의 따옴표 안에는 복사한 폴더 경로를 붙여넣습니다.

```powershell
Set-Location -LiteralPath "여기에_복사한_폴더_경로를_붙여넣으세요"
$env:CODEX_BOOTSTRAP_ALLOW_PACKAGE_INSTALLS = "1"
powershell -ExecutionPolicy Bypass -File .\scripts\windows\install.ps1
```

왜 막히는지는 [공급망 동결 안내](SUPPLY-CHAIN-FREEZE.md)를 보세요.

## macOS에서 Xcode Command Line Tools 창이 뜰 때

정상입니다. Apple 개발 도구가 아직 없어서 설치 UI가 열린 것입니다.

1. 안내에 따라 설치를 완료합니다.
2. 터미널을 새로 엽니다.
3. 설치 명령을 다시 실행합니다.

## macOS에서 Homebrew가 설치됐는데 `brew`를 못 찾을 때

새 터미널을 열어보세요. 그래도 안 되면 Homebrew가 안내하는 `shellenv` 명령을 실행해야 할 수 있습니다.

Apple Silicon Mac 예시:

```bash
eval "$(/opt/homebrew/bin/brew shellenv)"
```

Intel Mac 예시:

```bash
eval "$(/usr/local/bin/brew shellenv)"
```

## Windows에서 `winget is required`가 나올 때

`winget`은 어려운 개발 도구가 아닙니다. Windows가 프로그램을 자동 설치할 때 쓰는 Microsoft 기본 설치 도우미입니다.

사용자가 `winget` 명령을 배울 필요는 없습니다. 아래만 하면 됩니다.

1. Microsoft Store를 엽니다.
2. **App Installer**를 검색합니다.
3. **App Installer**를 설치하거나 업데이트합니다.
4. PowerShell을 완전히 닫았다가 새로 엽니다.
5. 파일 탐색기에서 `README.md`와 `scripts` 폴더가 보이는 폴더 주소를 `Ctrl+C`로 복사합니다.
6. 관리자 권한 PowerShell에 아래 3줄을 입력합니다. 첫 줄의 따옴표 안에는 방금 복사한 폴더 경로를 붙여넣습니다.

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

그래도 안 되면 Windows 업데이트가 밀려 있을 수 있습니다. Windows 업데이트를 먼저 진행한 뒤 다시 시도하세요.

## Windows에 WSL2나 Ubuntu가 아직 없을 때

빠른 설치 명령은 이미 Linux/WSL 셸이 준비된 사람을 위한 경로입니다. Windows 초보자는 [Windows 완전 초보자용 설치 순서](WINDOWS-BEGINNER.md)를 먼저 따라가세요.

이미 저장소 폴더를 열어둔 상태라면, `README.md`와 `scripts` 폴더가 바로 보이는 폴더 주소를 `Ctrl+C`로 복사한 뒤 관리자 권한 Windows PowerShell에 아래 3줄을 입력하세요. 첫 줄의 따옴표 안에는 복사한 폴더 경로를 붙여넣습니다. GitHub ZIP으로 받은 경우 폴더 이름은 `codex-cli-bootstrap-main`처럼 보일 수 있습니다.

관리자 PowerShell을 열었는데 저장소 폴더가 아니라면, 파일 탐색기에서 `README.md`와 `scripts` 폴더가 보이는 폴더 주소를 `Ctrl+C`로 복사한 뒤 아래 3줄을 입력합니다. 첫 줄의 따옴표 안에는 복사한 폴더 경로를 붙여넣습니다.

```powershell
Set-Location -LiteralPath "여기에_복사한_폴더_경로를_붙여넣으세요"
$env:CODEX_BOOTSTRAP_ALLOW_PACKAGE_INSTALLS = "1"
powershell -ExecutionPolicy Bypass -File .\scripts\windows\install.ps1
```

이 명령은 **Windows PowerShell**에 붙여넣는 명령입니다. Ubuntu 앱에 입력하는 명령이 아닙니다.

`.\scripts\windows\install.ps1` 파일을 찾을 수 없다는 메시지가 나오면 PowerShell 위치가 잘못된 것입니다. 파일 탐색기에서 `README.md`와 `scripts` 폴더가 바로 보이는 폴더 주소를 다시 `Ctrl+C`로 복사한 뒤, 위 3줄을 다시 입력하세요. 첫 줄의 따옴표 안에는 복사한 폴더 경로를 붙여넣습니다.

처음 Windows 환경에서는 아래 순서가 정상입니다.

1. 관리자 권한 PowerShell에서 Windows 설치 명령 실행
2. 스크립트가 Windows 기본 설치 도우미와 WSL2 상태를 확인
3. 스크립트가 WSL2와 Ubuntu 설치를 시작
4. 재부팅 안내가 나오면 재부팅
5. Windows 시작 메뉴에서 Ubuntu 실행
6. Ubuntu에서 새 사용자 이름과 비밀번호 생성
   - Windows 계정과 달라도 됩니다.
   - 비밀번호를 입력할 때 화면에 글자가 안 보여도 정상입니다.
7. 파일 탐색기에서 `README.md`와 `scripts` 폴더가 보이는 폴더 주소를 다시 `Ctrl+C`로 복사한 뒤, 같은 3줄 PowerShell 설치 명령 다시 실행
8. 설치 완료 후 Ubuntu에서 `codex` 실행

## Windows에서 WSL 설치 후 다시 실행하라고 할 때

처음 WSL/Ubuntu를 설치할 때는 한 번에 끝나지 않을 수 있습니다.

1. Windows를 재부팅하라는 안내가 있으면 재부팅합니다.
2. 시작 메뉴에서 **Ubuntu**를 엽니다.
3. Linux 사용자 이름과 비밀번호를 만듭니다.
4. 파일 탐색기에서 `README.md`와 `scripts` 폴더가 보이는 폴더 주소를 `Ctrl+C`로 복사합니다.
5. 관리자 권한 PowerShell을 열고 아래 3줄을 입력합니다. 첫 줄의 따옴표 안에는 복사한 폴더 경로를 붙여넣습니다.

```powershell
Set-Location -LiteralPath "여기에_복사한_폴더_경로를_붙여넣으세요"
$env:CODEX_BOOTSTRAP_ALLOW_PACKAGE_INSTALLS = "1"
powershell -ExecutionPolicy Bypass -File .\scripts\windows\install.ps1
```

## Windows에서 `codex`를 PowerShell에서 못 찾을 때

이 저장소는 Windows에서 Codex CLI를 WSL Ubuntu 안에 설치합니다. PowerShell이 아니라 **Ubuntu**를 열고 실행하세요.

```bash
codex
```

## Linux/WSL에서 비밀번호를 입력해도 화면에 안 보일 때

정상입니다. `sudo` 비밀번호 입력 중에는 글자가 화면에 표시되지 않습니다. 그대로 입력하고 Enter를 누르세요.

## 체크섬 불일치 에러가 날 때

빠른 설치 경로는 다운로드한 파일의 SHA-256을 검증합니다. 체크섬이 다르면 설치를 멈춥니다.

이 경우:

1. 같은 명령을 한 번 더 실행해봅니다.
2. 계속 실패하면 release 파일이 바뀌었거나 네트워크/캐시 문제가 있을 수 있습니다.
3. `scripts/codex/install-release.sh`의 digest를 임의로 바꾸지 마세요.
4. [공급망 동결 안내](SUPPLY-CHAIN-FREEZE.md)의 digest 갱신 원칙에 따라 검토 후 바꿔야 합니다.

## Codex 로그인에서 막힐 때

이 저장소는 Codex CLI 설치만 담당합니다. 로그인 방식은 Codex CLI와 OpenAI 계정 상태에 따라 달라질 수 있습니다.

먼저 아래를 확인하세요.

```bash
codex --version
codex
```

로그인 화면이나 안내 URL이 나오면 그 안내를 따르세요.
