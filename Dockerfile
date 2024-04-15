FROM ubuntu:22.04 

USER root
WORKDIR /root

SHELL [ "/usr/bin/bash", "-c" ]

# Set (temporarily) DEBIAN_FRONTEND to avoid interacting with tzdata
ENV TZ=Asia/Ho_Chi_Minh \
    DEBIAN_FRONTEND=noninteractive

RUN apt update && \
    apt upgrade -y

RUN apt install -y \
	git \
	make \
	gcc \
	g++ \
	libboost-all-dev \
	libssl-dev \
	libcpprest-dev \
    sudo \
	tree \
	dbus-x11 \
	bash-completion \
	curl \
	wget
	
# Install Prerequisites for Verilator
RUN apt install -y \
	help2man \
	libfl2 \
	libfl-dev \
	ccache \
	mold \
	libgoogle-perftools-dev \
	numactl \
	perl-doc \
	bison \
	clang \
	clang-format-14 \
	cmake \
	gdb \
	graphviz \
	lcov \
	libclang-dev \
	yapf3 \
	bear \
	python3-pip \
	ninja-build
	
# Compile systemc
WORKDIR /tmp
RUN git clone https://github.com/accellera-official/systemc.git

WORKDIR /tmp/systemc
RUN git checkout 2.3.4
RUN ./config/bootstrap && \
	autoupdate
RUN mkdir objdir && \
	mkdir /usr/local/systemc

WORKDIR /tmp/systemc/objdir
RUN ../configure --prefix=/usr/local/systemc && \
	make && \
	make install
	
# Install RTL Mics Tools
WORKDIR /root
RUN apt install -y tcl
RUN apt install -y vim \
	vim-gtk3
RUN apt install -y meld
RUN apt install -y gtkwave

# Switch to normal user with sudo permision "docker"
# Create user "docker" with sudo powers.
ARG USER=docker
RUN useradd -m -s /bin/bash $USER && \
    usermod -aG sudo $USER && \
    echo '%sudo ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
	
# Switch to docker user
USER $USER
ENV HOME /home/$USER
WORKDIR /home/$USER

# Use C.UTF-8 locale to avoid issues with ASCII encoding
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

# Setup tmux (v2.0)
RUN sudo apt install -y tmux
COPY .tmux.conf /home/docker/
RUN sudo chown $USER.$USER /home/$USER/.tmux.conf
RUN sudo chmod 644 /home/$USER/.tmux.conf

RUN git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
RUN git clone https://github.com/tmux-plugins/tmux-resurrect.git ~/.tmux/plugins/tmux-resurrect

# Avoid first use of sudo warning. c.f. https://askubuntu.com/a/22614/781671
RUN touch $HOME/.sudo_as_admin_successful

# setup bashshell
COPY .fonts /home/docker/.fonts
COPY .bashrc /home/docker/
RUN	sudo chown -R $USER.$USER /home/$USER

# Install Emacs
RUN sudo apt-get update && \
    sudo apt-get install -y software-properties-common && \
    sudo add-apt-repository -y ppa:ubuntuhandbook1/emacs && \
    sudo apt-get update && \
    sudo apt-get install -y --no-install-recommends emacs

# Setup verilog/systemverilog for emacs
COPY .emacs.d /home/docker/.emacs.d
RUN	sudo chown -R $USER /home/$USER

# setup neovim
RUN sudo apt-get install -y python3-neovim
RUN curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
RUN sudo tar -C /opt -xzf nvim-linux64.tar.gz
RUN rm -f /home/$USER/nvim-linux64.tar.gz
RUN sudo rm -f /usr/bin/nvim
RUN sudo ln -sf /opt/nvim-linux64/bin/nvim /usr/bin/nvim
RUN sudo apt install -y ripgrep python3-pip fd-find
RUN sudo pip3 install --upgrade pynvim
RUN git clone https://github.com/nharua/lazyvim.git /home/docker/.config/nvim
# install this to fix cannot install pyright in Mason
RUN curl -sL https://deb.nodesource.com/setup_20.x | sudo -E bash -
RUN sudo apt install nodejs -y
# install this to fix cannot install black && isort in Mason
RUN sudo apt install -y python3-venv 

# Setup icarus Verilog (v1.7)
RUN sudo apt install -y iverilog
RUN sudo ln -sf /bin/bash /bin/sh

# Setup verilator from source
WORKDIR /tmp
RUN git clone https://github.com/verilator/verilator
WORKDIR /tmp/verilator
RUN git checkout stable
RUN autoconf
RUN unset VERILATOR_ROOT
RUN ./configure --prefix /opt/verilator
RUN make
RUN sudo make install
WORKDIR /tmp
RUN sudo rm -rf *

WORKDIR /workDir
RUN sudo chmod 777 /workDir
CMD /usr/bin/bash

# How to build 
# docker buildx build --rm --tag verilator:versiontag --file .\Dockerfile .

# How to run
# docker run -ti --rm --env DISPLAY=host.docker.internal:0 -v yourlocalDir:/workDir --hostname verilator verilator:versiontag /usr/bin/bash
# Run GUI with Build-in Xserver on Windows 11
# https://www.youtube.com/watch?v=UEre6Bd75dw