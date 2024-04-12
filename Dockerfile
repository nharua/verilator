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

# Avoid first use of sudo warning. c.f. https://askubuntu.com/a/22614/781671
RUN touch $HOME/.sudo_as_admin_successful

# How to build 
# docker buildx build --rm --tag verilator:versiontag --file .\Dockerfile .

# How to run
# docker run -ti --rm --env DISPLAY=host.docker.internal:0 -v yourlocalDir:/workDir --hostname verilator verilator:versiontag /usr/bin/bash
# Run GUI with Build-in Xserver on Windows 11
# https://www.youtube.com/watch?v=UEre6Bd75dw