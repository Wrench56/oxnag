#!/bin/sh
set -eu

E_URL="https://raw.githubusercontent.com/Wrench56/repo-init/main/repo-init-executor.sh"
E="/tmp/ri-exec.$$"

if command -v curl >/dev/null 2>&1; then
    curl -fsSL "$E_URL" -o "$E"
elif command -v wget >/dev/null 2>&1; then
    wget -qO "$E" "$E_URL"
elif command -v fetch >/dev/null 2>&1; then
    fetch -o "$E" "$E_URL"
else
    echo "Error: No download tool found (curl/wget/fetch required)." >&2
    exit 1
fi

chmod +x "$E"
"$E" "$@"
rm -f "$E"
