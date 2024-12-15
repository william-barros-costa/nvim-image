FROM debian:bullseye

ENV PATH=/usr/local/go/bin:$PATH

# WORKDIR /usr/local/bin
ARG DEBIAN_FRONTEND=noninteractive
RUN apt update && apt install -y git ansible 

# Install Neovim
RUN apt-get install -y cmake gettext
RUN git clone 'https://github.com/neovim/neovim.git' /root/neovim
WORKDIR /root/neovim
RUN make -j 20
RUN make install
# Install Neovim's luarocks
RUN apt-get install -y luarocks python3 ripgrep

RUN mkdir -p /root/.config
WORKDIR /root/.config

RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 1
RUN update-alternatives --config python

RUN git clone https://github.com/william-barros-costa/nvim.git
RUN nvim --headless +Lazy! sync +qa
RUN nvim --headless -c "MasonToolsInstallSync" -c 'qa'

ENTRYPOINT ["/bin/bash"]
