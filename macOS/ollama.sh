#!/bin/bash

# Configuration
BLUE='\033[1;34m'
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Do work
LOG_PREFIX=${BLUE}'macOS / Ollama >'${NC}

echo -e "${LOG_PREFIX} ${YELLOW}Ollama removal started ...${NC}"

echo -e "${LOG_PREFIX} Stopping Ollama processes ..."
pkill -f ollama || true
killall Ollama 2>/dev/null || true

echo -e "${LOG_PREFIX} Uninstalling using Homebrew ..."
if command -v brew &> /dev/null; then
    brew uninstall ollama 2>/dev/null || true
    brew untap ollama/tap 2>/dev/null || true
fi

echo -e "${LOG_PREFIX} Cleaning Ollama application ..."
if [ -d "/Applications/Ollama.app" ]; then
    rm -rf /Applications/Ollama.app 2>/dev/null || true
fi
if [ -d "~/Applications/Ollama.app" ]; then
    rm -rf ~/Applications/Ollama.app 2>/dev/null || true
fi
if [ -f "/usr/local/bin/ollama" ]; then
    rm -f /usr/local/bin/ollama 2>/dev/null || true
fi

echo -e "${LOG_PREFIX} Cleaning Ollama data directories ..."
if [ -d "~/.ollama" ]; then
    rm -rf ~/.ollama 2>/dev/null || true
fi
if [ -d "~/Library/Application Support/Ollama" ]; then
    rm -rf ~/Library/Application\ Support/Ollama 2>/dev/null || true
fi
if [ -d "~/Library/Caches/ollama" ]; then
    rm -rf ~/Library/Caches/ollama 2>/dev/null || true
fi
if [ -d "~/Library/Caches/com.electron.ollama" ]; then
    rm -rf ~/Library/Caches/com.electron.ollama 2>/dev/null || true
fi

echo -e "${LOG_PREFIX} Cleaning Ollama preferences ..."
if [ -d "~/Library/Preferences/com.electron.ollama.plist" ]; then
    rm -f ~/Library/Preferences/com.electron.ollama.plist 2>/dev/null || true
fi

echo -e "${LOG_PREFIX} ${GREEN}Ollama removal complete!${NC}"
