#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
TEST_ROOT="$(mktemp -d)"
MOCK_BIN="$TEST_ROOT/mock-bin"
INSTALL_DIR="$TEST_ROOT/install-bin"
ASSET_DIR="$TEST_ROOT/assets"
OUTPUT_FILE="$TEST_ROOT/output.txt"
TEST_LOG="$TEST_ROOT/commands.log"

mkdir -p "$MOCK_BIN" "$INSTALL_DIR" "$ASSET_DIR/source" "$ASSET_DIR/tarballs"
: > "$TEST_LOG"

cleanup() {
  rm -rf "$TEST_ROOT"
}

trap 'status=$?; if [[ $status -ne 0 ]]; then [[ -f "$OUTPUT_FILE" ]] && cat "$OUTPUT_FILE"; [[ -f "$TEST_LOG" ]] && cat "$TEST_LOG"; fi; cleanup; exit $status' EXIT

cat > "$ASSET_DIR/source/codex-x86_64-unknown-linux-musl" <<'EOF'
#!/usr/bin/env bash
if [[ "${1-}" == "--version" ]]; then
  printf 'codex 0.130.0-test\n'
else
  printf 'codex test binary\n'
fi
EOF
chmod +x "$ASSET_DIR/source/codex-x86_64-unknown-linux-musl"

tar -czf "$ASSET_DIR/tarballs/codex-x86_64-unknown-linux-musl.tar.gz" -C "$ASSET_DIR/source" codex-x86_64-unknown-linux-musl
EXPECTED_SHA="$(sha256sum "$ASSET_DIR/tarballs/codex-x86_64-unknown-linux-musl.tar.gz" | awk '{print $1}')"

cat > "$MOCK_BIN/uname" <<'EOF'
#!/usr/bin/env bash
if [[ "${1-}" == "-s" ]]; then
  printf 'Linux\n'
elif [[ "${1-}" == "-m" ]]; then
  printf 'x86_64\n'
else
  /usr/bin/uname "$@"
fi
EOF
chmod +x "$MOCK_BIN/uname"

cat > "$MOCK_BIN/curl" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
printf 'curl %s\n' "$*" >> "$TEST_LOG"
output=""
previous=""
for arg in "$@"; do
  if [[ "$previous" == "-o" ]]; then
    output="$arg"
    break
  fi
  previous="$arg"
done
if [[ -z "$output" ]]; then
  printf 'curl mock expected -o output\n' >&2
  exit 1
fi
cp "$ASSET_TARBALL" "$output"
EOF
chmod +x "$MOCK_BIN/curl"

for forbidden in npm brew apt-get winget sudo xcode-select; do
  cat > "$MOCK_BIN/$forbidden" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
printf 'FORBIDDEN %s %s\n' "$(basename "$0")" "$*" >> "$TEST_LOG"
exit 99
EOF
  chmod +x "$MOCK_BIN/$forbidden"
done

PATH="$MOCK_BIN:/usr/bin:/bin" \
TEST_LOG="$TEST_LOG" \
ASSET_TARBALL="$ASSET_DIR/tarballs/codex-x86_64-unknown-linux-musl.tar.gz" \
CODEX_INSTALL_DIR="$INSTALL_DIR" \
CODEX_RELEASE_TAG="test-v0.130.0" \
CODEX_RELEASE_SHA256="$EXPECTED_SHA" \
bash "$REPO_ROOT/scripts/codex/install-release.sh" >"$OUTPUT_FILE" 2>&1

grep -q 'Downloading Codex CLI release asset: codex-x86_64-unknown-linux-musl.tar.gz' "$OUTPUT_FILE"
grep -q 'Codex CLI installed' "$OUTPUT_FILE"
grep -q 'codex 0.130.0-test' "$OUTPUT_FILE"
grep -q 'github.com/openai/codex/releases/download/test-v0.130.0/codex-x86_64-unknown-linux-musl.tar.gz' "$TEST_LOG"
if grep -q '^FORBIDDEN ' "$TEST_LOG"; then
  cat "$TEST_LOG"
  echo "Direct release installer must not call package managers or system installers." >&2
  exit 1
fi
"$INSTALL_DIR/codex" --version | grep -q 'codex 0.130.0-test'

printf 'Codex release installer smoke test passed.\n'
