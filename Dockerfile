FROM innovanon/builder:latest as builder-01
ARG LFS=/mnt/lfs
USER root
WORKDIR $LFS/sources
COPY ./dpkg.list  /tmp/dpkg.list
RUN sleep 91                       \
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
COPY ./strip.sh   \
     ./extract.sh \
                /usr/local/bin/

FROM builder-01 as test
USER root
RUN command -v   strip.sh | grep /usr/local/bin \
 && command -v extract.sh | grep /usr/local/bin
USER lfs
RUN command -v   strip.sh | grep /usr/local/bin \
 && command -v extract.sh | grep /usr/local/bin


FROM scratch as squash
COPY --from=builder-01 / /

