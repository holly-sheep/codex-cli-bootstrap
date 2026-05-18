# Windows 완전 초보자용 설치 순서

이 문서는 `winget`, `WSL`, `Ubuntu`, `PowerShell`, `Git`을 하나도 몰라도 따라 할 수 있게 만든 Windows 전용 안내입니다.

## 먼저 결론

Windows 사용자는 아래 순서만 따라 하세요.

1. GitHub에서 ZIP 파일 받기
2. 압축 풀기
3. `README.md`와 `scripts` 폴더가 보이는 폴더 찾기
4. 그 폴더 주소를 `Ctrl+C`로 복사하기
5. 관리자 권한 PowerShell 열기
6. PowerShell에 3줄 설치 명령 입력하기
7. 재부팅이나 Ubuntu 사용자 만들기 안내가 나오면 그대로 하기
8. 필요하면 폴더 주소를 다시 복사하고 같은 3줄 설치 명령 다시 입력하기
9. 설치가 끝나면 Ubuntu 앱에서 `codex` 실행하기

## 0. 용어는 몰라도 됩니다

- **PowerShell**: Windows에서 명령어를 입력하는 앱입니다.
- **winget**: Windows가 프로그램 설치를 도와주는 Microsoft 기본 도구입니다. 직접 배울 필요 없습니다.
- **WSL**: Windows 안에서 Linux를 실행하게 해주는 기능입니다.
- **Ubuntu**: WSL 안에서 열리는 Linux 앱입니다. Codex는 설치 후 여기에서 실행합니다.
- **Git**: 파일을 내려받는 개발 도구입니다. 몰라도 됩니다. 이 문서는 ZIP 다운로드 기준으로 설명합니다.

## 1. GitHub에서 ZIP 파일 받기

1. 브라우저에서 아래 주소를 엽니다.

   https://github.com/holly-sheep/codex-cli-bootstrap

2. 초록색 **Code** 버튼을 누릅니다.
3. **Download ZIP**을 누릅니다.
4. 다운로드가 끝나면 ZIP 파일을 찾습니다. 보통 **다운로드** 폴더에 있습니다.

## 2. ZIP 압축 풀기

1. 다운로드한 ZIP 파일을 마우스 오른쪽 클릭합니다.
2. **모두 압축 풀기**를 누릅니다.
3. 압축 풀기가 끝나면 새 폴더가 열립니다.
4. 폴더 이름은 `codex-cli-bootstrap-main`처럼 보일 수 있습니다. 이름이 조금 달라도 괜찮습니다.

## 3. 올바른 폴더 찾기

설치 명령은 반드시 **`README.md`와 `scripts` 폴더가 바로 보이는 폴더**에서 실행해야 합니다.

올바른 폴더 안에는 대략 아래처럼 보입니다.

```text
README.md
LICENSE
scripts
tests
docs
```

`scripts` 폴더가 보이지 않으면 한 단계 더 안쪽 폴더를 열어보세요.

## 4. 폴더 경로 복사하기

1. `README.md`와 `scripts` 폴더가 보이는 상태에서, 파일 탐색기 위쪽 주소 표시줄을 클릭합니다.
2. 주소가 글자로 바뀌면 전체를 복사합니다.
3. 예시는 아래와 비슷합니다.

```text
C:\Users\내이름\Downloads\codex-cli-bootstrap-main
```

## 5. 관리자 권한 PowerShell 열기

1. Windows 시작 버튼을 누릅니다.
2. `PowerShell`을 검색합니다.
3. **Windows PowerShell**을 마우스 오른쪽 클릭합니다.
4. **관리자 권한으로 실행**을 누릅니다.
5. “이 앱이 디바이스를 변경할 수 있도록 허용하시겠어요?” 같은 창이 뜨면 **예**를 누릅니다.

## 6. PowerShell에서 저장소 폴더로 이동하기

방금 폴더 경로를 복사했다면, 다음 단계에서 첫 줄의 따옴표 안에 그 경로를 붙여넣습니다.

## 7. Windows 설치 명령 실행하기

아래 3줄을 **Windows PowerShell**에 입력합니다. 첫 줄의 따옴표 안에는 방금 복사한 폴더 경로를 붙여넣으세요.

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

첫 줄은 PowerShell 위치를 설치 폴더로 옮기는 명령입니다.

중요:

- 이 명령은 **PowerShell**에 붙여넣는 명령입니다.
- 이 명령은 **Ubuntu 앱에 붙여넣는 명령이 아닙니다.**
- `bash scripts/...`로 시작하는 명령은 지금 단계에서 쓰지 않습니다.

## 8. 설치 중 안내가 나오면 이렇게 하세요

### 재부팅하라고 나오면

1. Windows를 재부팅합니다.
2. 다시 실행할 때는 아래 순서를 반복합니다.

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

### Ubuntu를 열어 사용자 이름과 비밀번호를 만들라고 나오면

1. Windows 시작 메뉴에서 `Ubuntu`를 검색해서 엽니다.
2. 새 사용자 이름을 만듭니다.
   - Windows 계정 이름과 달라도 됩니다.
   - 영어 소문자 이름을 추천합니다. 예: `user`
3. 새 비밀번호를 만듭니다.
   - 입력할 때 화면에 아무 글자도 안 보일 수 있습니다. 정상입니다.
   - 비밀번호를 입력하고 Enter, 한 번 더 입력하고 Enter를 누릅니다.
4. Ubuntu 창을 닫아도 됩니다.
5. 다시 실행할 때는 아래 순서를 반복합니다.

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

## 9. 설치가 끝난 뒤 Codex 실행하기

설치가 끝나면 Codex는 PowerShell이 아니라 **Ubuntu 앱**에서 실행합니다.

1. Windows 시작 메뉴를 엽니다.
2. `Ubuntu`를 검색합니다.
3. **Ubuntu** 앱을 엽니다.
4. 아래 명령을 입력합니다.

```bash
codex
```

처음 실행하면 로그인 안내가 나올 수 있습니다. 화면에 웹사이트 주소나 로그인 안내가 보이면 그대로 따라 하세요. 브라우저가 열리면 본인의 ChatGPT/OpenAI 계정으로 로그인합니다. 로그인 후 Ubuntu 창으로 돌아오면 Codex를 사용할 수 있습니다.

## 10. 자주 막히는 메시지

### `.\scripts\windows\install.ps1` 파일을 찾을 수 없다고 나올 때

PowerShell이 잘못된 폴더에 있는 것입니다.

해결:

1. 파일 탐색기에서 `README.md`와 `scripts` 폴더가 보이는 폴더를 다시 찾습니다.
2. 주소 표시줄에서 폴더 경로를 복사합니다.
3. 관리자 권한 PowerShell을 열고 아래 3줄을 입력합니다. 첫 줄의 따옴표 안에는 방금 복사한 폴더 경로를 붙여넣습니다.

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

### `winget is required`가 나올 때

`winget`은 Windows 설치 도우미입니다. 아래만 하면 됩니다.

1. Microsoft Store를 엽니다.
2. **App Installer**를 검색합니다.
3. 설치 또는 업데이트합니다.
4. PowerShell을 완전히 닫습니다.
5. 파일 탐색기에서 압축을 푼 폴더를 다시 엽니다.
6. `README.md`와 `scripts` 폴더가 바로 보이는지 확인합니다.
7. 파일 탐색기 위쪽 주소 표시줄을 클릭하고 `Ctrl+C`로 복사합니다.
8. 관리자 권한 Windows PowerShell을 새로 엽니다.
9. 아래 3줄을 입력합니다. 첫 줄의 따옴표 안에는 방금 복사한 폴더 경로를 붙여넣습니다.

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

### `codex`가 PowerShell에서 안 될 때

정상일 수 있습니다. Windows 설치에서는 Codex를 **Ubuntu 앱 안에 설치**합니다.

Windows 시작 메뉴에서 Ubuntu를 열고 아래 명령을 입력하세요.

```bash
codex
```
