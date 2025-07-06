FROM ubuntu:noble

ARG CONTAINER_VERSION="0.0.0"

LABEL Author="Maciej Rachuna"
LABEL Application="pl.rachuna-net.containers.vault"
LABEL Description="vault container image"
LABEL version="${CONTAINER_VERSION}"

ENV DEBIAN_FRONTEND=noninteractive

COPY scripts/ /opt/scripts/

# Install system dependencies and ansible
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

# Make scripts executable
    && chmod +x /opt/scripts/*.bash \

# Create a non-root user and set permissions
    && useradd -m -s /bin/bash user_vault \
    && chown -R user_vault:user_vault /opt/scripts

USER user_vault

ENTRYPOINT [ "/opt/scripts/entrypoint.bash" ]
