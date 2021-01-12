FROM innovanon/builder:latest as builder-01
ARG LFS=/mnt/lfs
USER root
WORKDIR $LFS/sources
COPY ./dpkg.list  /tmp/dpkg.list
RUN sleep 31 \
 && apt update                     \
 && apt full-upgrade               \
 && test -x       /tmp/dpkg.list   \
 && apt install $(/tmp/dpkg.list)  \
 && rm -v         /tmp/dpkg.list   \
 && echo . /etc/profile.d/local.sh \
 >>   /home/lfs/.bash_profile      \
 && git config --global http.proxy socks5h://127.0.0.1:9050
USER lfs
RUN git config --global http.proxy socks5h://127.0.0.1:9050
USER root
COPY ./local.sh /etc/profile.d/
COPY ./strip.sh /usr/local/bin/

