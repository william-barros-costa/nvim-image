FROM debian:bullseye

ENV PATH=/usr/local/go/bin:$PATH
ENV HOME=/home/user
ENV XDG_CONFIG_HOME=/home/user/.config

# WORKDIR /usr/local/bin
ARG DEBIAN_FRONTEND=noninteractive
RUN apt update && apt install -y git ansible 

RUN mkdir -p /home/user/.config

# Install Neovim
RUN apt-get install -y cmake gettext
RUN git clone 'https://github.com/neovim/neovim.git' "$HOME"
WORKDIR /home/user/neovim
RUN make -j 20
RUN make install
# Install Neovim's luarocks
RUN apt-get install -y luarocks python3 ripgrep npm

WORKDIR "$XDG_CONFIG_HOME"

RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 1
RUN update-alternatives --config python

RUN git clone https://github.com/william-barros-costa/nvim.git
RUN nvim --headless +Lazy! sync +qa
RUN nvim --headless -c "MasonToolsInstallSync" -c 'qa'

ENTRYPOINT ["/bin/bash"]
