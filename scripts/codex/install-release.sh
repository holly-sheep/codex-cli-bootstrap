#!/usr/bin/env bash
set -euo pipefail

DEFAULT_CODEX_RELEASE_TAG="rust-v0.130.0"
TMP_DIR=""

cleanup() {
  if [[ -n "$TMP_DIR" ]]; then
    rm -rf "$TMP_DIR"
  fi
}

info() {
  printf '[INFO] %s\n' "$1"
}

error() {
  printf '[ERROR] %s\n' "$1" >&2
}

require_command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    error "$1 is required for direct Codex release installation."
    exit 1
  fi
}

detect_target() {
  local os
  local arch

  os="$(uname -s)"
  arch="$(uname -m)"

  case "$os:$arch" in
    Darwin:arm64|Darwin:aarch64)
      printf 'aarch64-apple-darwin'
      ;;
    Darwin:x86_64)
      printf 'x86_64-apple-darwin'
      ;;
    Linux:aarch64|Linux:arm64)
      printf 'aarch64-unknown-linux-musl'
      ;;
    Linux:x86_64)
      printf 'x86_64-unknown-linux-musl'
      ;;
    *)
      error "Unsupported platform: $os $arch"
      exit 1
      ;;
  esac
}

default_sha256_for_asset() {
  case "$1" in
    codex-aarch64-apple-darwin.tar.gz)
      printf 'bc50a4b7f9a0c8ca99179189e4659b601107830770e21547dc0c246bce733577'
      ;;
    codex-aarch64-unknown-linux-musl.tar.gz)
      printf '1d7e00f2c22c3016b5bcb71c61010947b022a90e2901bc6baafe82256492c767'
      ;;
    codex-x86_64-apple-darwin.tar.gz)
      printf 'feddb116bd96d7d83f8bb19b34fbabe6843cc64461baf2e49c017e1206ad5e67'
      ;;
    codex-x86_64-unknown-linux-musl.tar.gz)
      printf '16779e7b7857508a768a36d7d4e084eec336ec23946ed70a9b09489b8f861190'
      ;;
    *)
      return 1
      ;;
  esac
}

sha256_file() {
  if command -v shasum >/dev/null 2>&1; then
    shasum -a 256 "$1" | awk '{print $1}'
    return 0
  fi

  if command -v sha256sum >/dev/null 2>&1; then
    sha256sum "$1" | awk '{print $1}'
    return 0
  fi

  error "shasum or sha256sum is required for checksum verification."
  exit 1
}

resolve_expected_sha256() {
  local tag="$1"
  local asset="$2"
  local expected_sha256

  if [[ -n "${CODEX_RELEASE_SHA256:-}" ]]; then
    expected_sha256="${CODEX_RELEASE_SHA256#sha256:}"
    validate_sha256 "$expected_sha256"
    printf '%s' "$expected_sha256"
    return 0
  fi

  if [[ "$tag" == "$DEFAULT_CODEX_RELEASE_TAG" ]]; then
    expected_sha256="$(default_sha256_for_asset "$asset")"
    validate_sha256 "$expected_sha256"
    printf '%s' "$expected_sha256"
    return 0
  fi

  error "CODEX_RELEASE_SHA256 is required when overriding CODEX_RELEASE_TAG."
  exit 1
}

validate_sha256() {
  if [[ ! "$1" =~ ^[0-9a-f]{64}$ ]]; then
    error "SHA-256 digest must be 64 lowercase hex characters, optionally prefixed with sha256:."
    exit 1
  fi
}

validate_archive_contents() {
  local archive="$1"
  local expected_member="$2"
  local members

  members="$(tar -tzf "$archive")"
  if [[ "$members" != "$expected_member" ]]; then
    error "Unexpected archive contents for $archive"
    error "Expected exactly one entry: $expected_member"
    error "Actual entries:"
    printf '%s\n' "$members" >&2
    exit 1
  fi
}

ensure_path_hint() {
  local install_dir="$1"

  case ":$PATH:" in
    *":$install_dir:"*)
      return 0
      ;;
  esac

  printf '\n'
  info "Add this to your shell profile if codex is not found:"
  printf '  export PATH="%s:$PATH"\n' "$install_dir"
}

main() {
  require_command curl
  require_command tar
  require_command awk
  require_command mktemp

  local target
  local asset
  local tag
  local expected_sha256
  local install_dir
  local tmp_dir
  local archive
  local extract_dir
  local extracted_binary
  local url
  local actual_sha256

  target="$(detect_target)"
  asset="codex-${target}.tar.gz"
  tag="${CODEX_RELEASE_TAG:-$DEFAULT_CODEX_RELEASE_TAG}"
  expected_sha256="$(resolve_expected_sha256 "$tag" "$asset")"
  install_dir="${CODEX_INSTALL_DIR:-$HOME/.local/bin}"
  url="https://github.com/openai/codex/releases/download/${tag}/${asset}"

  TMP_DIR="$(mktemp -d)"
  archive="$TMP_DIR/$asset"
  extract_dir="$TMP_DIR/extract"
  mkdir -p "$extract_dir" "$install_dir"
  trap cleanup EXIT

  info "Downloading Codex CLI release asset: $asset"
  curl -fL "$url" -o "$archive"

  actual_sha256="$(sha256_file "$archive")"
  if [[ "$actual_sha256" != "$expected_sha256" ]]; then
    error "Checksum mismatch for $asset"
    error "Expected: $expected_sha256"
    error "Actual:   $actual_sha256"
    exit 1
  fi

  validate_archive_contents "$archive" "codex-$target"
  tar -xzf "$archive" -C "$extract_dir"
  extracted_binary="$extract_dir/codex-$target"
  if [[ ! -f "$extracted_binary" ]]; then
    error "Expected binary was not found after extraction: codex-$target"
    exit 1
  fi

  cp "$extracted_binary" "$install_dir/codex"
  chmod 0755 "$install_dir/codex"

  info "Codex CLI installed to $install_dir/codex"
  "$install_dir/codex" --version
  ensure_path_hint "$install_dir"
}

main "$@"
