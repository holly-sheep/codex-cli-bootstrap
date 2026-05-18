# 초보자용 설치 안내

이 문서는 터미널이나 GitHub가 익숙하지 않은 사람을 위한 단계별 안내입니다.

## 설치 전에 알아둘 것

- **터미널**: 명령어를 입력하는 앱입니다.
  - macOS: `터미널` 앱
  - Windows: `PowerShell`, 이후에는 `Ubuntu` 앱
- **Codex CLI**: 터미널에서 실행하는 코딩 도우미입니다.
- **WSL**: Windows 안에서 Linux를 실행하게 해주는 기능입니다.
- **Ubuntu**: Windows에서 Codex를 안정적으로 쓰기 위해 사용하는 Linux 환경입니다.

## 가장 쉬운 경로

처음이라면 전체 개발 환경보다 **Codex CLI만 설치하는 빠른 경로**를 먼저 추천합니다.

```bash
bash scripts/codex/install-release.sh
```

단, 이 명령을 실행하려면 먼저 이 저장소 파일을 받아야 합니다.

## 저장소 파일 받기

### 방법 A: Git으로 받기

터미널에서 아래를 입력합니다.

```bash
git clone https://github.com/holly-sheep/codex-cli-bootstrap.git
cd codex-cli-bootstrap
```

### 방법 B: ZIP으로 받기

Git을 아직 설치하지 않았거나 명령어가 어렵다면 ZIP으로 받아도 됩니다.

1. GitHub 저장소 페이지를 엽니다.
2. 초록색 **Code** 버튼을 누릅니다.
3. **Download ZIP**을 누릅니다.
4. 다운로드된 ZIP 파일의 압축을 풉니다.
5. 터미널에서 압축을 푼 폴더로 이동합니다.

macOS에서 폴더 이동이 어렵다면:

1. Finder에서 압축을 푼 폴더를 엽니다.
2. 터미널에 `cd `를 입력합니다. `cd` 뒤에 공백이 있어야 합니다.
3. Finder의 폴더를 터미널 창으로 드래그합니다.
4. Enter를 누릅니다.

## macOS에서 설치하기

### Codex CLI만 설치

```bash
bash scripts/codex/install-release.sh
```

설치 확인:

```bash
codex --version
```

실행:

```bash
codex
```

### 개발 도구까지 전체 설치

전체 설치는 Homebrew와 패키지를 설치할 수 있으므로 명시적으로 허용해야 합니다.

```bash
CODEX_BOOTSTRAP_ALLOW_PACKAGE_INSTALLS=1 bash scripts/macos/install.sh
```

설치 도중 Apple의 Xcode Command Line Tools 설치 창이 뜰 수 있습니다. 설치를 완료한 뒤 같은 명령을 다시 실행하세요.

## Linux 또는 WSL Ubuntu에서 설치하기

### Codex CLI만 설치

```bash
bash scripts/codex/install-release.sh
```

### 개발 도구까지 전체 설치

```bash
CODEX_BOOTSTRAP_ALLOW_PACKAGE_INSTALLS=1 bash scripts/linux/install.sh
```

중간에 비밀번호를 물어보면 현재 Ubuntu/Linux 사용자 비밀번호를 입력합니다. 입력 중에는 화면에 글자가 보이지 않을 수 있지만 정상입니다.

## Windows에서 설치하기

Windows에서는 Codex CLI를 Windows 본체가 아니라 **WSL2의 Ubuntu 안에 설치**합니다.

WSL2나 Ubuntu가 아직 없는 사람도 이 섹션부터 따라 하면 됩니다. 스크립트가 WSL2 설정과 Ubuntu 설치를 시작해주고, 필요한 경우 재부팅이나 Ubuntu 초기화를 안내합니다.

### 권장 흐름

1. 시작 메뉴에서 **PowerShell**을 검색합니다.
2. 가능하면 **관리자 권한으로 실행**합니다.
3. 저장소 폴더로 이동합니다.
4. 아래 명령을 실행합니다.

```powershell
$env:CODEX_BOOTSTRAP_ALLOW_PACKAGE_INSTALLS = "1"
powershell -ExecutionPolicy Bypass -File .\scripts\windows\install.ps1
```

### WSL2나 Ubuntu가 아예 없는 경우

그대로 Windows PowerShell 설치 명령을 실행하면 됩니다. 설치 스크립트가 Ubuntu 설치를 시작한 뒤, 필요한 다음 행동을 메시지로 알려줍니다.

대부분의 첫 설치 흐름은 아래와 같습니다.

1. PowerShell에서 Windows 설치 명령 실행
2. WSL/Ubuntu 설치가 시작됨
3. Windows가 재부팅을 요구하면 재부팅
4. 시작 메뉴에서 **Ubuntu** 실행
5. Linux 사용자 이름과 비밀번호 생성
6. 다시 저장소 폴더로 돌아와 같은 PowerShell 설치 명령 재실행
7. 설치 완료 후 Ubuntu에서 `codex` 실행

### 설치 중 재부팅이나 Ubuntu 초기화가 필요한 경우

Windows에서 WSL 또는 Ubuntu를 처음 설치하는 경우 다음이 필요할 수 있습니다.

- Windows 재부팅
- Ubuntu 앱을 한 번 열어서 Linux 사용자 이름과 비밀번호 만들기
- 같은 설치 명령 다시 실행하기

설치가 끝나면 Windows PowerShell이 아니라 **Ubuntu**를 열고 실행합니다.

```bash
codex
```

## 설치 후 무엇을 하면 되나요?

1. 새 터미널을 엽니다.
2. `codex --version`으로 설치를 확인합니다.
3. `codex`를 실행합니다.
4. 로그인 안내가 나오면 본인 계정으로 로그인합니다.
5. 프로젝트 폴더에서 Codex를 사용합니다.

예시:

```bash
cd 내프로젝트폴더
codex
```

## 막히면 먼저 확인할 것

- 명령어를 복사할 때 앞뒤 따옴표가 이상하게 바뀌지 않았는지 확인합니다.
- Windows에서는 PowerShell과 Ubuntu를 구분합니다.
- `codex`가 안 잡히면 새 터미널을 열어봅니다.
- 그래도 안 되면 [문제 해결](TROUBLESHOOTING.md)을 확인합니다.
