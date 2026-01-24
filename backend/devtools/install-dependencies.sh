#!/usr/bin/env bash
set -euo pipefail

# Change to the backend directory regardless of where this script is called from
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKEND_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$BACKEND_DIR"

# Install required packages if they are missing
packages=()
need_mssql=false
if ! command -v curl >/dev/null 2>&1; then
  packages+=("curl")
fi
if ! command -v make >/dev/null 2>&1; then
  packages+=("make")
fi
if ! command -v gpg >/dev/null 2>&1; then
  packages+=("gnupg")
fi
if ! command -v sqlcmd >/dev/null 2>&1; then
  need_mssql=true
fi

# Install missing packages
if ((${#packages[@]} > 0)); then
  sudo apt-get update
  sudo apt-get install -y "${packages[@]}"
fi

# Install Microsoft SQL Server tools if needed
if [[ "$need_mssql" == true ]]; then
  sudo apt-get update
  if [[ ! -f /usr/share/keyrings/microsoft-prod.gpg ]]; then
    curl -fsSL https://packages.microsoft.com/keys/microsoft.asc \
      | gpg --dearmor \
      | sudo tee /usr/share/keyrings/microsoft-prod.gpg >/dev/null
  fi

  if [[ -f /etc/os-release ]]; then
    . /etc/os-release
  fi

  if [[ "${ID:-}" == "ubuntu" ]]; then
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft-prod.gpg] https://packages.microsoft.com/ubuntu/${VERSION_ID}/prod ${VERSION_CODENAME} main" \
      | sudo tee /etc/apt/sources.list.d/microsoft-prod.list >/dev/null
  elif [[ "${ID:-}" == "debian" ]]; then
    ms_debian_version="${VERSION_ID}"
    if [[ "${VERSION_ID%%.*}" -gt 12 ]]; then
      ms_debian_version="12"
    fi
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft-prod.gpg] https://packages.microsoft.com/debian/${ms_debian_version}/prod bookworm main" \
      | sudo tee /etc/apt/sources.list.d/microsoft-prod.list >/dev/null
  else
    echo "Unsupported distro: ${ID:-unknown}" >&2
    exit 1
  fi

  sudo apt-get update
  sudo ACCEPT_EULA=Y apt-get install -y --no-install-recommends msodbcsql18 mssql-tools18 unixodbc-dev

  if [[ ":$PATH:" != *":/opt/mssql-tools18/bin:"* ]]; then
    export PATH="/opt/mssql-tools18/bin:$PATH"
  fi
  if [[ -f "$HOME/.bashrc" ]] && ! grep -q "/opt/mssql-tools18/bin" "$HOME/.bashrc"; then
    echo 'export PATH="/opt/mssql-tools18/bin:$PATH"' >> "$HOME/.bashrc"
  fi
fi

# Install uv if not already installed
if ! command -v uv >/dev/null 2>&1; then
  curl -LsSf https://astral.sh/uv/install.sh | sh
  export PATH="$HOME/.local/bin:$PATH"
fi

# Necessary to avoid "detected dubious ownership" errors in Git 2.35+
git config --global --add safe.directory /workspaces/who-does-what

# Clean up existing virtual environment to avoid issues with env created elsewhere
rm -rf .venv

make install
