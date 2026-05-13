#!/usr/bin/env bash
set -euo pipefail

if [[ "$(uname -s)" != "Linux" ]]; then
  echo "[ERROR] This installer only supports Linux or WSL."
  exit 1
fi

info() {
  printf '[INFO] %s\n' "$1"
}

warn() {
  printf '[WARN] %s\n' "$1"
}

assert_package_installs_allowed() {
  if [[ "${CODEX_BOOTSTRAP_ALLOW_PACKAGE_INSTALLS:-}" == "1" ]]; then
    return 0
  fi

  echo "[ERROR] Package installation and update steps are currently disabled."
  echo "[ERROR] This would call package managers such as apt, NodeSource, or npm."
  echo "[ERROR] Set CODEX_BOOTSTRAP_ALLOW_PACKAGE_INSTALLS=1 only after you intentionally lift the supply-chain freeze."
  exit 2
}

require_sudo() {
  if ! command -v sudo >/dev/null 2>&1; then
    echo "[ERROR] sudo is required."
    exit 1
  fi
}

ensure_apt_packages() {
  info "Installing baseline development packages..."
  assert_package_installs_allowed
  sudo apt-get update
  sudo apt-get install -y \
    build-essential \
    ca-certificates \
    curl \
    git \
    python3 \
    python3-pip \
    python3-venv \
    ripgrep
}

ensure_nodejs() {
  local needs_node=1

  if command -v node >/dev/null 2>&1; then
    local major
    major="$(node -p 'process.versions.node.split(".")[0]')"
    if [[ "$major" -ge 20 ]]; then
      needs_node=0
      info "Node.js already installed: $(node --version)"
    else
      warn "Node.js $(node --version) is too old. Upgrading to 20 LTS."
    fi
  fi

  if [[ "$needs_node" -eq 1 ]]; then
    info "Installing Node.js 20 LTS..."
    assert_package_installs_allowed
    curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
    sudo apt-get install -y nodejs
  fi

  info "Node.js ready: $(node --version)"
  info "npm ready: $(npm --version)"
}

ensure_npm_prefix() {
  local npm_prefix
  npm_prefix="$HOME/.local/npm-global"

  mkdir -p "$npm_prefix"
  npm config set prefix "$npm_prefix"

  for shell_rc in "$HOME/.bashrc" "$HOME/.zshrc" "$HOME/.profile"; do
    if [[ ! -f "$shell_rc" ]]; then
      touch "$shell_rc"
    fi

    if ! grep -Fq 'export PATH="$HOME/.local/npm-global/bin:$PATH"' "$shell_rc"; then
      printf '\nexport PATH="$HOME/.local/npm-global/bin:$PATH"\n' >> "$shell_rc"
    fi
  done

  export PATH="$HOME/.local/npm-global/bin:$PATH"
  info "npm global prefix set to $npm_prefix"
}

ensure_codex() {
  if command -v codex >/dev/null 2>&1; then
    info "Codex CLI already installed: $(codex --version | head -n 1)"
    return 0
  fi

  info "Installing Codex CLI..."
  assert_package_installs_allowed
  npm install -g @openai/codex
  info "Codex CLI installed: $(codex --version | head -n 1)"
}

main() {
  info "Starting Linux/WSL Codex bootstrap..."
  require_sudo
  ensure_apt_packages
  ensure_nodejs
  ensure_npm_prefix
  ensure_codex

  printf '\n'
  info "Installation complete."
  printf 'Checks:\n'
  printf '  git: %s\n' "$(git --version)"
  printf '  python: %s\n' "$(python3 --version)"
  printf '  g++: %s\n' "$(g++ --version | head -n 1)"
  printf '  rg: %s\n' "$(rg --version | head -n 1)"
  printf '  node: %s\n' "$(node --version)"
  printf '  codex: %s\n' "$(codex --version | head -n 1)"
  printf '\n'
  printf 'Next steps:\n'
  printf '  1. Open a new shell if `codex` is not found immediately.\n'
  printf '  2. Run: codex\n'
  printf '  3. Sign in with ChatGPT or configure API authentication.\n'
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  main "$@"
fi
