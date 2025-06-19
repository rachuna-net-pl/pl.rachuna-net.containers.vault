FROM ubuntu:noble

LABEL Author='Maciej Rachuna'
LABEL Application='pl.rachuna-net.containers.vault'
LABEL Description='vault container image'
LABEL version="${VAULT_VERSION}"

COPY scripts/ /opt/scripts/

RUN apt-get update && apt-get install -y \
        curl \
        git \
        gnupg2 \
        jq \
        lsb-release \
        openssh-client \
# Add repository hashicorp
    && curl -fsSL https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list \
# Install Vault
    && apt-get update && apt-get install -y vault \
    && apt-get upgrade -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && chmod +x /opt/scripts/*.bash

ENTRYPOINT [ "/opt/scripts/entrypoint.bash" ]
