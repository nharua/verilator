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
    sudo
	
# Enable tab completion by uncommenting it from /etc/bash.bashrc
# The relevant lines are those below the phrase "enable bash completion in interactive shells"
RUN export SED_RANGE="$(($(sed -n '\|enable bash completion in interactive shells|=' /etc/bash.bashrc)+1)),$(($(sed -n '\|enable bash completion in interactive shells|=' /etc/bash.bashrc)+7))" && \
    sed -i -e "${SED_RANGE}"' s/^#//' /etc/bash.bashrc && \
    unset SED_RANGE

# Build Desktop GUI
RUN apt install -y x11vnc xvfb

ARG USER=docker
ARG PASS=1234

# Create user "docker" with sudo powers
RUN useradd -m $USER && \
    usermod -aG sudo $USER && \
    chsh -s /bin/bash $USER && \
    echo '%sudo ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers && \
    cp /root/.bashrc /home/$USER/ && \
    mkdir /home/$USER/data && \
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

RUN mkdir /home/$USER/.vnc
RUN x11vnc -storepasswd $PASS ~/.vnc/passwd \
	&& chmod 0600 /home/$USER/.vnc/passwd \
    && chown -R $USER:$USER /home/$USER/.vnc

RUN sudo chmod 777 /workDir

CMD /bin/bash