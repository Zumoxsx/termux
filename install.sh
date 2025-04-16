#!/usr/bin/env bash

# -e: Exit immediately if a command fails
# -u: Treat unset variables as an error
# -o pipefail: Pipeline fails if any command fails
set -euo pipefail

# Colors for output
readonly R='\033[1;31m'
readonly G='\033[1;32m'
readonly Y='\033[1;33m'
readonly B='\033[1;34m'
readonly M='\033[1;35m'
readonly C='\033[1;36m'
readonly W='\033[1;37m'
readonly E='\033[0m'

# Configuration
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly CONFIG_DIR="$HOME/.config"
readonly BACKUP_DIR="$HOME/.config_backup_$(date +%Y%m%d_%H%M%S)"

# Dependencies
readonly REQUIRED_CMDS=("git" "cp" "rm" "mkdir" "nvim")

# Functions
error() {
  echo -e "${R}[ERROR]${E} $1" >&2
  exit 1
}

warning() {
  echo -e "${Y}[WARNING]${E} $1"
}

info() {
  echo -e "${B}[INFO]${E} $1"
}

success() {
  echo -e "${G}[SUCCESS]${E} $1"
}

check_dependencies() {
  for cmd in "${REQUIRED_CMDS[@]}"; do
    if ! command -v "$cmd" &>/dev/null; then
      error "Missing required command: $cmd"
    fi
  done
}

create_backup() {
  local target="$1"
  local backup_path="$BACKUP_DIR/${target##*/}_$(date +%H%M%S)"

  info "Creating backup of $target in $backup_path"
  mkdir -p "$(dirname "$backup_path")"
  cp -r "$target" "$backup_path" || warning "Failed to backup $target"
}

safe_copy() {
  local src="$1"
  local dest="$2"

  if [ ! -e "$src" ]; then
    warning "Source $src does not exist, skipping"
    return
  fi

  if [ -e "$dest" ]; then
    create_backup "$dest"
    rm -rf "$dest"
  fi

  mkdir -p "$(dirname "$dest")"
  cp -r "$src" "$dest" && success "Copied $src to $dest"
}

setup_configs() {
  info "Setting up configuration files..."

  # LSD config
  safe_copy "$SCRIPT_DIR/configs/lsd" "$CONFIG_DIR/lsd"

  # Termux config
  if [ -d "$HOME/.termux" ]; then
    safe_copy "$SCRIPT_DIR/configs/termux" "$HOME/.termux"
  fi

  # Dotfiles
  safe_copy "$SCRIPT_DIR/configs/bashrc" "$HOME/.bashrc"
  safe_copy "$SCRIPT_DIR/configs/.zumo.txt" "$HOME/.zumo.txt"
  safe_copy "$SCRIPT_DIR/configs/.tmux.conf" "$HOME/.tmux.conf"

  # Neovim setup
  setup_neovim

}

setup_neovim() {
  if [ ! -d "$CONFIG_DIR/nvim" ]; then
    info "Setting up Neovim configuration..."

    if git clone --depth=1  https://github.com/NvChad/starter "$CONFIG_DIR/nvim"; then
      nvim --headless +qall 2>/dev/null || true

      if [ -d "$SCRIPT_DIR/configs/nvim" ]; then
        safe_copy "$SCRIPT_DIR/configs/nvim/chadrc.lua" "$CONFIG_DIR/nvim/lua/chadrc.lua"
        safe_copy "$SCRIPT_DIR/configs/nvim/mappings.lua" "$CONFIG_DIR/nvim/lua/mappings.lua"
        termux-reload-settings
        rm /data/data/com.termux/files/usr/etc/motd 2>/dev/null

      fi

      success "Neovim configuration completed"
    else
      warning "Failed to clone NvChad starter template"
    fi
  else
    info "Neovim configuration already exists, skipping..."
  fi
}

main() {
  echo -e "${M}=== Config Setup Script ===${E}"
  check_dependencies
  setup_configs
  echo -e "${M}=== Script completed ===${E}"
}

main "$@"
