# FROM ghcr.io/william-barros-costa/nvim-image@sha256:39956e1142b085b2d467286ed6e73c872dbba70086e226fc7d25542df98fa4f8 
FROM ghcr.io/william-barros-costa/nvim-image

ARG GO_VERSION=1.23.0
ARG MASON_TOOLS="golangci-lint,gopls,delve,gofumpt,gotests,gotestsum,impl,delve,goimports-reviser,goimports"

ENV GOLANG_VERSION=${GO_VERSION}
ENV MASON_TOOLS=${MASON_TOOLS}

# Install Go
ADD https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz /tmp/go.tar.gz
RUN mkdir -p /usr/local/go
RUN tar -xf /tmp/go.tar.gz -C /usr/local
RUN rm /tmp/go.tar.gz

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

