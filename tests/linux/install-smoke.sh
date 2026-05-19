#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
TEST_ROOT="$(mktemp -d)"
TEST_HOME="$TEST_ROOT/home"
MOCK_BIN="$TEST_ROOT/mock-bin"
TEST_LOG="$TEST_ROOT/commands.log"
OUTPUT_FILE="$TEST_ROOT/output.txt"

mkdir -p "$TEST_HOME" "$MOCK_BIN"
: > "$TEST_LOG"

cleanup() {
  rm -rf "$TEST_ROOT"
}

trap 'status=$?; if [[ $status -ne 0 ]]; then [[ -f "$OUTPUT_FILE" ]] && cat "$OUTPUT_FILE"; [[ -f "$TEST_LOG" ]] && cat "$TEST_LOG"; fi; cleanup; exit $status' EXIT

cat > "$MOCK_BIN/sudo" <<'EOF'
#!/bin/bash
set -euo pipefail
if [[ "${1-}" == "-E" ]]; then
  shift
fi
"$@"
EOF
chmod +x "$MOCK_BIN/sudo"

cat > "$MOCK_BIN/apt-get" <<'EOF'
#!/bin/bash
set -euo pipefail
printf 'apt-get %s\n' "$*" >> "$TEST_LOG"
if [[ "$*" == *"nodejs"* ]]; then
  cat > "$MOCK_BIN/node" <<'NODEEOF'
#!/bin/bash
set -euo pipefail
if [[ "${1-}" == "--version" ]]; then
  printf 'v20.11.1\n'
elif [[ "${1-}" == "-p" ]]; then
  printf '20\n'
else
  printf 'node stub\n'
fi
NODEEOF
  chmod +x "$MOCK_BIN/node"
fi
EOF
chmod +x "$MOCK_BIN/apt-get"

cat > "$MOCK_BIN/curl" <<'EOF'
#!/bin/bash
set -euo pipefail
printf 'curl %s\n' "$*" >> "$TEST_LOG"
printf 'echo nodesource setup\n'
EOF
chmod +x "$MOCK_BIN/curl"

cat > "$MOCK_BIN/bash" <<'EOF'
#!/bin/bash
set -euo pipefail
printf 'bash %s\n' "$*" >> "$TEST_LOG"
if [[ "${1-}" == "-" ]]; then
  cat >/dev/null
  exit 0
fi
/bin/bash "$@"
EOF
chmod +x "$MOCK_BIN/bash"

cat > "$MOCK_BIN/node" <<'EOF'
#!/bin/bash
set -euo pipefail
if [[ "${1-}" == "--version" ]]; then
  printf 'v18.19.0\n'
elif [[ "${1-}" == "-p" ]]; then
  printf '18\n'
else
  printf 'node stub\n'
fi
EOF
chmod +x "$MOCK_BIN/node"

cat > "$MOCK_BIN/npm" <<'EOF'
#!/bin/bash
set -euo pipefail
printf 'npm %s\n' "$*" >> "$TEST_LOG"
if [[ "${1-}" == "--version" ]]; then
  printf '10.8.0\n'
  exit 0
fi
if [[ "${1-}" == "config" && "${2-}" == "set" && "${3-}" == "prefix" ]]; then
  exit 0
fi
if [[ "${1-}" == "install" && "${2-}" == "-g" && "${3-}" == "@openai/codex@0.130.0" ]]; then
  mkdir -p "$HOME/.local/npm-global/bin"
  cat > "$HOME/.local/npm-global/bin/codex" <<'CODEXEOF'
#!/bin/bash
printf 'codex 0.130.0\n'
CODEXEOF
  chmod +x "$HOME/.local/npm-global/bin/codex"
  exit 0
fi
printf 'Unexpected npm invocation: %s\n' "$*" >&2
exit 1
EOF
chmod +x "$MOCK_BIN/npm"

cat > "$MOCK_BIN/git" <<'EOF'
#!/bin/bash
printf 'git version 2.47.0\n'
EOF
chmod +x "$MOCK_BIN/git"

cat > "$MOCK_BIN/g++" <<'EOF'
#!/bin/bash
printf 'g++ (Ubuntu) 13.2.0\n'
EOF
chmod +x "$MOCK_BIN/g++"

cat > "$MOCK_BIN/rg" <<'EOF'
#!/bin/bash
printf 'ripgrep 14.1.0\n'
EOF
chmod +x "$MOCK_BIN/rg"

cat > "$MOCK_BIN/uname" <<'EOF'
#!/bin/bash
if [[ "${1-}" == "-s" ]]; then
  printf 'Linux\n'
else
  /usr/bin/uname "$@"
fi
EOF
chmod +x "$MOCK_BIN/uname"

HOME="$TEST_HOME" \
PATH="$MOCK_BIN:/usr/bin:/bin" \
TEST_LOG="$TEST_LOG" \
MOCK_BIN="$MOCK_BIN" \
/bin/bash "$REPO_ROOT/scripts/linux/install.sh" >"$OUTPUT_FILE" 2>&1 && {
  cat "$OUTPUT_FILE"
  echo "Installer should block package installs by default." >&2
  exit 1
}

grep -q 'Package installation and update steps are currently disabled' "$OUTPUT_FILE"
if [[ -s "$TEST_LOG" ]]; then
  cat "$TEST_LOG"
  echo "Blocked installer should not call package managers." >&2
  exit 1
fi

HOME="$TEST_HOME" \
PATH="$MOCK_BIN:/usr/bin:/bin" \
TEST_LOG="$TEST_LOG" \
MOCK_BIN="$MOCK_BIN" \
CODEX_BOOTSTRAP_ALLOW_PACKAGE_INSTALLS=1 \
/bin/bash "$REPO_ROOT/scripts/linux/install.sh" >"$OUTPUT_FILE" 2>&1

grep -q 'Installation complete\.' "$OUTPUT_FILE"
grep -q 'apt-get update' "$TEST_LOG"
grep -q 'apt-get install -y build-essential ca-certificates curl git python3 python3-pip python3-venv ripgrep' "$TEST_LOG"
grep -q 'curl -fsSL https://deb.nodesource.com/setup_20.x' "$TEST_LOG"
grep -q 'apt-get install -y nodejs' "$TEST_LOG"
grep -Eq 'npm config set prefix .*/home/.local/npm-global' "$TEST_LOG"
grep -q 'npm install -g @openai/codex@0.130.0' "$TEST_LOG"
grep -q 'export PATH="$HOME/.local/npm-global/bin:$PATH"' "$TEST_HOME/.bashrc"
grep -q 'export PATH="$HOME/.local/npm-global/bin:$PATH"' "$TEST_HOME/.zshrc"
grep -q 'export PATH="$HOME/.local/npm-global/bin:$PATH"' "$TEST_HOME/.profile"
grep -q 'codex 0.130.0' "$OUTPUT_FILE"

printf 'Linux installer smoke test passed.\n'
