# FROM ghcr.io/william-barros-costa/nvim-image@sha256:39956e1142b085b2d467286ed6e73c872dbba70086e226fc7d25542df98fa4f8 
FROM ghcr.io/william-barros-costa/nvim-image

ARG MASON_TOOLS="yamlfmt,yamllint,gitlab-ci-ls,yq"

ENV PATH="/root/.cargo/bin:$PATH"
ENV MASON_TOOLS=${MASON_TOOLS}

RUN apt-get update && apt-get install curl

# Install Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# Install Nerd Fonts
RUN apt-get update && apt-get install -y \
  wget \
  unzip \
  fontconfig \
  && rm -rf /var/lib/apt/lists/*

RUN wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/FiraCode.zip -P /tmp/ \
    && unzip /tmp/FiraCode.zip -d /tmp/FiraCode \
    && mkdir -p /usr/share/fonts/opentype/nerd-fonts \
    && cp /tmp/FiraCode/*.otf /usr/share/fonts/opentype/nerd-fonts/ \
    && fc-cache -fv \
    && rm -rf /tmp/FiraCode.zip /tmp/FiraCode

RUN nvim --headless -c "MasonToolsInstallSync" -c 'qa'

