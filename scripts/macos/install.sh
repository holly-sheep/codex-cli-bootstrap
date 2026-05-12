#!/usr/bin/env bash
set -euo pipefail

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "[ERROR] This installer only supports macOS."
  exit 1
fi

info() {
  printf '[INFO] %s\n' "$1"
}

resolve_brew() {
  if command -v brew >/dev/null 2>&1; then
    return 0
  fi

  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
    return 0
  fi

  if [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
    return 0
  fi

  return 1
}

ensure_xcode_clt() {
  if xcode-select -p >/dev/null 2>&1; then
    info "Xcode Command Line Tools already installed."
    return 0
  fi

  info "Requesting Xcode Command Line Tools installation..."
  xcode-select --install || true
  echo "[WARN] Complete the Xcode Command Line Tools installation, then rerun this script."
  exit 0
}

ensure_homebrew() {
  if resolve_brew; then
    info "Homebrew already installed."
    return 0
  fi

  info "Installing Homebrew..."
  NONINTERACTIVE=1 /bin/bash -c \
    "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  if ! resolve_brew; then
    echo "[ERROR] Homebrew installation finished, but brew is still not on PATH."
    exit 1
  fi
}

ensure_base_packages() {
  info "Installing baseline development packages..."
  brew install git python ripgrep
  info "Git ready: $(git --version)"
  info "Python ready: $(python3 --version)"
  info "ripgrep ready: $(rg --version | head -n 1)"
}

ensure_codex() {
  if command -v codex >/dev/null 2>&1; then
    info "Codex CLI already installed: $(codex --version | head -n 1)"
    return 0
  fi

  info "Installing Codex CLI..."
  brew install --cask codex
  info "Codex CLI installed: $(codex --version | head -n 1)"
}

main() {
  info "Starting macOS Codex bootstrap..."
  ensure_xcode_clt
  ensure_homebrew
  ensure_base_packages
  ensure_codex

  printf '\n'
  info "Installation complete."
  printf 'Checks:\n'
  printf '  git: %s\n' "$(git --version)"
  printf '  python: %s\n' "$(python3 --version)"
  printf '  rg: %s\n' "$(rg --version | head -n 1)"
  printf '  codex: %s\n' "$(codex --version | head -n 1)"
  printf '\n'
  printf 'Next steps:\n'
  printf '  1. Open a new terminal if `codex` is not found immediately.\n'
  printf '  2. Run: codex\n'
  printf '  3. Sign in with ChatGPT or configure API authentication.\n'
}

main "$@"
