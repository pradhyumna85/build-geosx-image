# Define you base image for build arguments
ARG IMG=ubuntu20.04-gcc9
ARG VERSION=213-913
ARG ORG=geosx

ARG CMAKE_BASE_VERSION=3.22
ARG CMAKE_SUB_VERSION=6

# starting from base image
FROM ${ORG}/${IMG}:${VERSION}

ARG IMG
ARG VERSION
ARG ORG

ARG CMAKE_BASE_VERSION
ARG CMAKE_SUB_VERSION

RUN apt-get update
RUN apt-get remove --purge -y texlive graphviz
RUN apt-get install --no-install-recommends -y openssh-server gdb rsync gdbserver ninja-build

# You will need cmake to build GEOSX.
RUN apt-get install -y --no-install-recommends curl ca-certificates && \
    curl -fsSL https://cmake.org/files/v${CMAKE_BASE_VERSION}/cmake-${CMAKE_BASE_VERSION}.${CMAKE_SUB_VERSION}-linux-x86_64.tar.gz | tar --directory=/usr/local --strip-components=1 -xzf - && \
    apt-get purge --auto-remove -y curl ca-certificates
RUN apt-get autoremove -y

RUN apt update
RUN apt-get update
RUN apt install -y ca-certificates git-lfs nano vim cpp gfortran curl python python3 htop zip unzip
RUN apt-get -y install clang-8 software-properties-common
RUN apt install -y clang-8
RUN apt update
RUN apt-get update

RUN add-apt-repository ppa:git-core/ppa -y
RUN apt update
RUN apt install -y git

RUN curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash
RUN apt-get update
RUN apt-get install -y git-lfs

RUN apt install -y make cmake gcc g++
RUN apt-get install -y flex bison
RUN apt install -y patch texlive-font-utils locales
RUN locale-gen en_US.UTF-8

## set locale
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && \
    locale-gen
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8  

## create non root user for mpi
RUN useradd -ms /bin/bash mpiuser
RUN mkdir -p /home/mpiuser
RUN mkdir -p /app
RUN chown -R mpiuser /home/mpiuser
RUN chown -R mpiuser /app

## change root password to Docker! 
RUN echo 'root:Docker!' | chpasswd

## change password for mpiuser
RUN echo 'mpiuser:pass' | chpasswd

# You'll most likely need ssh/sshd too (e.g. CLion and VSCode allow remote dev through ssh).
# This is the part where I configure sshd.

# I'm developing in a version of docker that requires root.
# So by default I use root. Feel free to adapt.
# RUN echo "PermitRootLogin prohibit-password" >> /etc/ssh/sshd_config
RUN echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
RUN echo "PermitUserEnvironment yes" >> /etc/ssh/sshd_config

RUN mkdir -p -m 700 /root/.ssh
# # Put your own public key here!
# RUN echo "ssh-rsa <key-contents>" > /root/.ssh/authorized_keys

# Some important variables are provided through the environment.
# You need to explicitly tell sshd to forward them.
# Using these variables and not paths will let you adapt to different installation locations in different containers.
# Feel free to -adapt to your own convenience.
RUN touch /root/.ssh/environment &&\
    echo "CC=${CC}" >> /root/.ssh/environment &&\
    echo "CXX=${CXX}" >> /root/.ssh/environment &&\
    echo "MPICC=${MPICC}" >> /root/.ssh/environment &&\
    echo "MPICXX=${MPICXX}" >> /root/.ssh/environment &&\
    echo "MPIEXEC=${MPIEXEC}" >> /root/.ssh/environment &&\
    echo "OMPI_CC=${CC}" >> /root/.ssh/environment &&\
    echo "OMPI_CXX=${CXX}" >> /root/.ssh/environment &&\
    echo "GEOSX_TPL_DIR=${GEOSX_TPL_DIR}" >> /root/.ssh/environment

WORKDIR /home/mpiuser

# This is the default ssh port that we do not need to modify.
EXPOSE 22

# sshd's option -D prevents it from detaching and becoming a daemon.
# Otherwise, sshd would not block the process and `docker run` would quit.
RUN mkdir -p /run/sshd

RUN touch /root/entrypoint.sh &&\
        echo "#!/bin/bash" >> /root/entrypoint.sh &&\
        echo "/usr/sbin/sshd -D" >> /root/entrypoint.sh &&\
        echo "su mpiuser" >> /root/entrypoint.sh

RUN chmod +x /root/entrypoint.sh

ENTRYPOINT "/root/entrypoint.sh"