FROM ubuntu:22.04 

USER root
WORKDIR /root

SHELL [ "/bin/bash", "-c" ]

# Set (temporarily) DEBIAN_FRONTEND to avoid interacting with tzdata
ENV TZ=Asia/Ho_Chi_Minh \
    DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y \
    && apt-get upgrade -y \
    && apt-get -y install \
	gtkwave \
	verilator \
	make \
	gcc \
	g++ \
	libboost-all-dev \
	libssl-dev \
	libcpprest-dev \
	git \
	vim \
	vim-gtk3 \
    sudo \
	tree \
	zsh \
	dbus-x11 \
	bash-completion \
	curl \
	wget
	
# Run GUI with Build-in Xserver on Windows 11
# https://www.youtube.com/watch?v=UEre6Bd75dw
# run docker as following
# docker run -it -v \\wsl.localhost\Ubuntu\mnt\wslg:/tmp my_ubuntu:v1.0 /bin/bash
ENV DISPLAY=:0

# Create user "docker" with sudo powers
ARG USER=docker
RUN useradd -m $USER && \
    usermod -aG sudo $USER && \
    chsh -s /usr/bin/zsh $USER && \
    echo '%sudo ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers && \
    cp /root/.bashrc /home/$USER/ && \
    chown -R --from=root $USER /home/$USER

# Use C.UTF-8 locale to avoid issues with ASCII encoding
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

WORKDIR /workDir
ENV HOME /home/docker
ENV USER docker
USER docker
ENV PATH /home/docker/.local/bin:$PATH
# Avoid first use of sudo warning. c.f. https://askubuntu.com/a/22614/781671
RUN touch $HOME/.sudo_as_admin_successful

# Install ohmyzsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

RUN sudo chmod 777 /workDir

# Install Emacs
#RUN sudo apt install -y software-properties-common
#RUN sudo add-apt-repository ppa:ubuntuhandbook1/emacs
#ENV DEBIAN_FRONTEND=noninteractive
#RUN sudo apt install -y emacs emacs-common

# Install Emacs
RUN sudo apt-get update && \
    sudo apt-get install -y software-properties-common && \
    sudo add-apt-repository -y ppa:ubuntuhandbook1/emacs && \
    sudo apt-get update && \
    sudo apt-get install -y --no-install-recommends emacs

# Setup verilog/systemverilog for emacs
COPY .emacs.d /home/docker/.emacs.d
RUN	sudo chown -R $USER /home/$USER

# Setup icarus Verilog (v1.7)
RUN sudo apt install -y iverilog

# Setup tmux (v2.0)
RUN sudo apt install -y tmux
COPY .tmux.conf /home/docker/
RUN sudo chown $USER.$USER /home/$USER/.tmux.conf
RUN sudo chmod 644 /home/$USER/.tmux.conf

WORKDIR /home/$USER
RUN git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
RUN git clone https://github.com/tmux-plugins/tmux-resurrect.git ~/.tmux/plugins/tmux-resurrect


WORKDIR /workDir
#CMD /bin/bash
CMD ["/usr/bin/zsh"]

# How to build 
# docker buildx build --rm --tag verilator:v1.1 --file .\Dockerfile .

# How to run
# docker run -ti --rm --env DISPLAY=host.docker.internal:0 verilator:v1.0 /bin/bash
