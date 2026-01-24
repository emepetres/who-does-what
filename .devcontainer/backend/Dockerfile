FROM mcr.microsoft.com/devcontainers/python:3.12

USER root

RUN set -eux; \
    export DEBIAN_FRONTEND=noninteractive; \
    apt-get update; \
    apt-get install -y --no-install-recommends curl gnupg; \
    . /etc/os-release; \
    curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /usr/share/keyrings/microsoft-prod.gpg; \
    if [ "$ID" = "ubuntu" ]; then \
        echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft-prod.gpg] https://packages.microsoft.com/ubuntu/${VERSION_ID}/prod ${VERSION_CODENAME} main" > /etc/apt/sources.list.d/microsoft-prod.list; \
    elif [ "$ID" = "debian" ]; then \
        ms_debian_version="$VERSION_ID"; \
        if [ "${VERSION_ID%%.*}" -gt 12 ]; then \
            ms_debian_version="12"; \
        fi; \
        echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft-prod.gpg] https://packages.microsoft.com/debian/${ms_debian_version}/prod bookworm main" > /etc/apt/sources.list.d/microsoft-prod.list; \
    else \
        echo "Unsupported distro: $ID"; \
        exit 1; \
    fi; \
    apt-get update; \
    ACCEPT_EULA=Y apt-get install -y --no-install-recommends msodbcsql18 mssql-tools18 unixodbc-dev; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/*

ENV PATH="/opt/mssql-tools18/bin:${PATH}"

USER vscode
