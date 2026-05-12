#!/usr/bin/env bash
set -euo pipefail

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "[ERROR] This installer only supports macOS."
  exit 1
fi

info() {
  printf '[INFO] %s\n' "$1"
}

warn() {
  printf '[WARN] %s\n' "$1"
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

ensure_git() {
  if command -v git >/dev/null 2>&1; then
    info "Git already installed: $(git --version)"
    return 0
  fi

  info "Installing Git..."
  brew install git
  info "Git installed: $(git --version)"
}

ensure_codex() {
  if command -v codex >/dev/null 2>&1; then
    info "Codex CLI already installed: $(codex --version | head -n 1)"
    return 0
  fi

  info "Installing Codex CLI..."
  brew install --cask codex

  if ! command -v codex >/dev/null 2>&1; then
    warn "Codex CLI was installed, but the current shell cannot find it yet."
    warn "Open a new terminal and run: codex --version"
    return 0
  fi

  info "Codex CLI installed: $(codex --version | head -n 1)"
}

main() {
  info "Starting macOS Codex CLI bootstrap..."
  ensure_homebrew
  ensure_git
  ensure_codex

  printf '\n'
  info "Installation complete."
  printf 'Next steps:\n'
  printf '  1. Open a new terminal if `codex` is not found immediately.\n'
  printf '  2. Run: codex\n'
  printf '  3. Sign in with ChatGPT or configure API authentication.\n'
}

main "$@"
