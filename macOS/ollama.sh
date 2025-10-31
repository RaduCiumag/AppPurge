#!/bin/bash

# Configuration
BLUE='\033[1;34m'
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Utilities
log() {
    echo -e "${BLUE}macOS / Ollama${NC} > ${1}"
}
success() {
    echo -e "${BLUE}macOS / Ollama${NC} > ${GREEN}${1}${NC}"
}
warning() {
    echo -e "${BLUE}macOS / Ollama${NC} > ${YELLOW}${1}${NC}"
}
error() {
    echo -e "${BLUE}macOS / Ollama${NC} > ${RED}${1}${NC}"
}
safe_kill() {
    local pattern="$1"
    local process_count=$(pgrep -f "$pattern" | wc -l)
    if [[ $process_count -gt 0 ]]; then
        log "Stopping processes with pattern: '$pattern'"
        pkill -f "$pattern" 2>/dev/null || true
    fi
}
safe_remove() {
    local path="$1"
    if [[ -e "$path" ]]; then
        rm -rf "$path" 2>/dev/null || {
            error "Failed to remove '$path'. Please check permissions."
            return 1
        }
        success "Successfully removed '$path'!"
    fi
}

# Do work
if [[ "$OSTYPE" != "darwin"* ]]; then
    error "This script is intended for macOS systems only."
    exit 1
fi

log "Ollama removal started ..."

safe_kill "ollama"
safe_kill "Ollama"

if command -v brew &>/dev/null; then
    if brew list | grep -q ollama; then
        log "Ollama found in Homebrew, uninstalling..."
        brew uninstall ollama 2>/dev/null || true
        brew untap ollama/tap 2>/dev/null || true
    fi
fi

clean_dirs=(
    "/Applications/Ollama.app"
    "/usr/local/bin/ollama"
    "$HOME/Applications/Ollama.app"
    "$HOME/.ollama"
    "$HOME/Library/Application Support/Ollama"
    "$HOME/Library/Caches/ollama"
    "$HOME/Library/Caches/com.electron.ollama"
    "$HOME/Library/Preferences/com.electron.ollama.plist"
)
for clean_dir in "${clean_dirs[@]}"; do
    safe_remove "$clean_dir"
done

if pgrep -f "ollama" > /dev/null; then
    warning "Some Ollama processes still running. Please restart your terminal or system."
fi

success "${GREEN}Ollama removal complete!${NC}"
