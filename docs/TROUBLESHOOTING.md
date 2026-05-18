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

```powershell
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

`winget`은 Microsoft의 App Installer에 포함되어 있습니다.

1. Microsoft Store를 엽니다.
2. **App Installer**를 검색합니다.
3. 설치 또는 업데이트합니다.
4. PowerShell을 새로 열고 다시 실행합니다.

## Windows에 WSL2나 Ubuntu가 아직 없을 때

README의 [Windows PowerShell](../README.md#windows-powershell) 섹션으로 가서 전체 설치 명령을 실행하세요. 빠른 설치 명령은 이미 Linux/WSL 셸이 준비된 사람을 위한 경로입니다.

처음 Windows 환경에서는 아래 순서가 정상입니다.

1. 관리자 권한 PowerShell에서 Windows 설치 명령 실행
2. 스크립트가 WSL2와 Ubuntu 설치를 시작
3. 재부팅 안내가 나오면 재부팅
4. 시작 메뉴에서 Ubuntu 실행
5. Linux 사용자 이름과 비밀번호 생성
6. 같은 PowerShell 설치 명령 다시 실행
7. 설치 완료 후 Ubuntu에서 `codex` 실행

## Windows에서 WSL 설치 후 다시 실행하라고 할 때

처음 WSL/Ubuntu를 설치할 때는 한 번에 끝나지 않을 수 있습니다.

1. Windows를 재부팅하라는 안내가 있으면 재부팅합니다.
2. 시작 메뉴에서 **Ubuntu**를 엽니다.
3. Linux 사용자 이름과 비밀번호를 만듭니다.
4. 저장소 폴더로 돌아가 설치 명령을 다시 실행합니다.

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
