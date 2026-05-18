# 초보자용 설치 안내

이 문서는 터미널이나 GitHub가 익숙하지 않은 사람을 위한 단계별 안내입니다.

## 설치 전에 알아둘 것

모르는 단어가 나와도 괜찮습니다. 아래 정도만 이해하면 됩니다.

- **PowerShell**: Windows에서 명령어를 입력하는 앱입니다. 시작 메뉴에서 `PowerShell`로 검색해서 엽니다.
- **터미널**: 명령어를 입력하는 앱입니다.
  - macOS: `터미널` 앱
  - Windows: 처음에는 `PowerShell`, 설치 후에는 `Ubuntu` 앱
- **winget**: Windows가 프로그램을 자동 설치할 때 쓰는 Microsoft 기본 설치 도우미입니다. 이름을 외우거나 직접 사용할 필요는 없습니다.
- **WSL**: Windows 안에서 Linux를 실행하게 해주는 기능입니다.
- **Ubuntu**: Windows에서 Codex를 안정적으로 쓰기 위해 사용하는 Linux 앱입니다. 설치 후에는 시작 메뉴에서 앱처럼 열 수 있습니다.
- **Codex CLI**: 터미널에서 실행하는 코딩 도우미입니다.

## 가장 쉬운 경로

사용하는 컴퓨터에 따라 시작 위치가 다릅니다.

- **Windows 사용자이고 WSL/Ubuntu가 뭔지 모른다면:** 먼저 [Windows 완전 초보자용 설치 순서](WINDOWS-BEGINNER.md)를 따라 하세요.
- **macOS 사용자라면:** [macOS에서 설치하기](#macos에서-설치하기)를 보세요.
- **이미 Linux 또는 WSL Ubuntu를 쓰고 있다면:** [Linux 또는 WSL Ubuntu에서 설치하기](#linux-또는-wsl-ubuntu에서-설치하기)를 보세요.

Windows 초보자는 아래의 `bash scripts/codex/install-release.sh` 명령부터 실행하지 마세요. 그 명령은 macOS 터미널, Linux 터미널, 또는 이미 준비된 Ubuntu 앱 안에서 실행하는 명령입니다.

## 저장소 파일 받기

### 방법 A: ZIP으로 받기 — Git을 몰라도 되는 방법

처음이라면 이 방법을 추천합니다.

1. 브라우저에서 이 주소를 엽니다: https://github.com/holly-sheep/codex-cli-bootstrap
2. 초록색 **Code** 버튼을 누릅니다.
3. **Download ZIP**을 누릅니다.
4. 다운로드된 ZIP 파일을 마우스 오른쪽 클릭하고 **모두 압축 풀기**를 누릅니다.
5. 압축을 푼 뒤, `README.md`와 `scripts` 폴더가 바로 보이는 폴더를 엽니다.
   - 폴더 이름은 `codex-cli-bootstrap-main` 또는 비슷한 이름일 수 있습니다.
   - `scripts` 폴더가 보이지 않으면 한 단계 더 안쪽 폴더를 열어보세요.

Windows에서 그 폴더로 PowerShell 열기:

1. `README.md`와 `scripts` 폴더가 바로 보이는 폴더를 엽니다.
2. 파일 탐색기 위쪽 주소 표시줄을 클릭하고 폴더 경로를 복사합니다.
   - 예: `C:\Users\내이름\Downloads\codex-cli-bootstrap-main`
3. Windows 시작 버튼을 누르고 `PowerShell`을 검색합니다.
4. **Windows PowerShell**을 마우스 오른쪽 클릭하고 **관리자 권한으로 실행**을 누릅니다.
5. 이제 아래 Windows 설치 명령 3줄을 입력하면 됩니다. 첫 줄의 따옴표 안에는 방금 복사한 폴더 경로를 붙여넣습니다.

macOS에서 그 폴더로 터미널 열기:

1. Finder에서 압축을 푼 폴더를 엽니다.
2. 터미널에 `cd `를 입력합니다. `cd` 뒤에 공백이 있어야 합니다.
3. Finder의 폴더를 터미널 창으로 드래그합니다.
4. Enter를 누릅니다.

### 방법 B: Git으로 받기

Git을 이미 알고 있다면 터미널에서 아래를 입력합니다.

```bash
git clone https://github.com/holly-sheep/codex-cli-bootstrap.git
cd codex-cli-bootstrap
```

## macOS에서 설치하기

### Codex CLI만 설치

아래 명령은 macOS 터미널에 입력합니다.

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

아래 명령은 Linux 터미널 또는 이미 준비된 Ubuntu 앱 안에서 실행합니다. Windows PowerShell에 붙여넣는 명령이 아닙니다.

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

완전 처음이라면 이 섹션보다 [Windows 완전 초보자용 설치 순서](WINDOWS-BEGINNER.md)를 먼저 보는 것을 추천합니다.

Windows에서는 Codex CLI를 Windows 본체가 아니라 **WSL2의 Ubuntu 안에 설치**합니다.

`winget`, `WSL2`, `Ubuntu`가 뭔지 몰라도 괜찮습니다. 이 섹션부터 따라 하면 됩니다. 스크립트가 필요한 것을 확인하고, 설치가 안 된 것이 있으면 다음 행동을 알려줍니다.

### 권장 흐름

1. 먼저 위의 [ZIP으로 받기](#방법-a-zip으로-받기--git을-몰라도-되는-방법)를 따라 저장소 파일을 받습니다.
2. `README.md`와 `scripts` 폴더가 바로 보이는 폴더 경로를 복사합니다.
3. 관리자 권한 Windows PowerShell을 엽니다.
4. 아래 3줄을 **Windows PowerShell**에 입력하고 Enter를 누릅니다. 첫 줄의 따옴표 안에는 방금 복사한 폴더 경로를 붙여넣습니다.

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

> 위 명령은 Windows PowerShell에 붙여넣는 명령입니다. Ubuntu 앱에 입력하는 명령이 아닙니다.
>
> `.\scripts\windows\install.ps1` 파일을 찾을 수 없다는 메시지가 나오면, 현재 PowerShell 위치가 잘못된 것입니다. `README.md`와 `scripts` 폴더가 바로 보이는 폴더로 이동한 뒤 다시 실행하세요.

PowerShell을 직접 열어야 한다면:

1. Windows 시작 버튼을 누릅니다.
2. `PowerShell`을 검색합니다.
3. **Windows PowerShell**을 마우스 오른쪽 클릭합니다.
4. **관리자 권한으로 실행**을 누릅니다.
5. 파일 탐색기에서 `README.md`와 `scripts` 폴더가 보이는 폴더 주소를 `Ctrl+C`로 복사한 뒤, Windows 설치 명령 3줄을 입력합니다. 첫 줄의 따옴표 안에는 복사한 폴더 경로를 붙여넣습니다.

### WSL2나 Ubuntu가 아예 없는 경우

그대로 Windows PowerShell 설치 명령을 실행하면 됩니다. 설치 스크립트가 Ubuntu 설치를 시작한 뒤, 필요한 다음 행동을 메시지로 알려줍니다.

대부분의 첫 설치 흐름은 아래와 같습니다.

1. PowerShell에서 Windows 설치 명령 실행
2. Windows 기본 설치 도우미가 준비되어 있는지 확인됨
3. WSL/Ubuntu 설치가 시작됨
4. Windows가 재부팅을 요구하면 재부팅
5. Windows 시작 메뉴에서 **Ubuntu**를 검색해서 실행
6. Ubuntu가 처음 열리면 새 사용자 이름과 비밀번호 생성
   - Windows 계정과 달라도 됩니다.
   - 사용자 이름은 영어 소문자로 만드는 것을 추천합니다. 예: `user`
   - 비밀번호를 입력할 때 화면에 아무 글자도 안 보일 수 있지만 정상입니다.
7. 다시 Windows PowerShell을 관리자 권한으로 열고, 파일 탐색기에서 `README.md`와 `scripts` 폴더가 보이는 폴더 주소를 `Ctrl+C`로 복사한 뒤, 같은 3줄 설치 명령 재실행. 첫 줄의 따옴표 안에는 복사한 폴더 경로를 붙여넣습니다.
8. 설치 완료 후 Ubuntu에서 `codex` 실행

중간에 `winget`이라는 단어가 보여도 겁먹지 않아도 됩니다. Windows에서 프로그램 설치를 대신해주는 도구 이름입니다.

### 설치 중 재부팅이나 Ubuntu 초기화가 필요한 경우

Windows에서 WSL 또는 Ubuntu를 처음 설치하는 경우 다음이 필요할 수 있습니다.

- Windows 재부팅
- Ubuntu 앱을 한 번 열어서 Linux 사용자 이름과 비밀번호 만들기
- 파일 탐색기에서 폴더 주소를 다시 `Ctrl+C`로 복사한 뒤, 3줄 설치 명령 다시 실행하기

설치가 끝나면 Codex는 Windows PowerShell이 아니라 Ubuntu 앱에서 실행합니다.

1. Windows 시작 메뉴를 엽니다.
2. `Ubuntu`를 검색합니다.
3. **Ubuntu** 앱을 엽니다.
4. 아래 명령을 입력합니다.

```bash
codex
```

## 설치 후 무엇을 하면 되나요?

1. 새 터미널을 엽니다.
   - Windows: Ubuntu 앱을 엽니다.
   - macOS: 터미널 앱을 엽니다.
2. 아래 명령으로 설치를 확인합니다.

```bash
codex --version
```

3. 아래 명령으로 Codex를 실행합니다.

```bash
codex
```

4. 로그인 안내가 나오면 화면에 나온 웹사이트 주소나 안내를 그대로 따라 본인 ChatGPT/OpenAI 계정으로 로그인합니다.
5. 프로젝트 폴더에서 사용하는 방법은 프로젝트별 안내가 있을 때 따라 하면 됩니다.

## 막히면 먼저 확인할 것

- Windows 사용자는 먼저 [Windows에서 설치하기](#windows에서-설치하기)를 따라왔는지 확인합니다.
- 명령어를 복사할 때 앞뒤 따옴표가 이상하게 바뀌지 않았는지 확인합니다.
- Windows에서는 PowerShell과 Ubuntu를 구분합니다.
- `codex`가 안 잡히면 새 터미널 또는 Ubuntu 앱을 다시 열어봅니다.
- 그래도 안 되면 [문제 해결](TROUBLESHOOTING.md)을 확인합니다.
