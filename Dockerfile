FROM innovanon/builder:latest as builder-01
ARG LFS=/mnt/lfs
USER root
WORKDIR $LFS/sources
COPY ./dpkg.list  /tmp/dpkg.list
RUN tor --verify-config            \
 && sleep 91                       \
 && apt update                     \
 && apt full-upgrade               \
 && test -x       /tmp/dpkg.list   \
 && apt install $(/tmp/dpkg.list)  \
 && rm -v         /tmp/dpkg.list   \
 && echo . /etc/profile.d/local.sh \
 >>   /home/lfs/.bash_profile      \
 && git config --global http.proxy socks5h://127.0.0.1:9050
COPY ./local.sh /etc/profile.d/
COPY ./strip.sh   \
     ./extract.sh \
                /usr/local/bin/
USER lfs
RUN git config --global http.proxy socks5h://127.0.0.1:9050

#FROM scratch as squash
#COPY --from=builder-01 / /
#ARG LFS=/mnt/lfs
#USER root
#WORKDIR $LFS/sources

FROM builder-01 as test
USER root
RUN command -v   strip.sh | grep /usr/local/bin \
 && command -v extract.sh | grep /usr/local/bin \
 && exec true || exec false
USER lfs
RUN command -v   strip.sh | grep /usr/local/bin \
 && command -v extract.sh | grep /usr/local/bin \
 && exec true || exec false
RUN test -n "$PATH"               \
 && test -n "$CPPFLAGS"           \
 && test -n "$CPATH"              \
 && test -n "$C_INCLUDE_PATH"     \
 && test -n "$CPLUS_INCLUDE_PATH" \
 && test -n "$OBJC_INCLUDE_PATH"  \
 && test -n "$LDFLAGS"            \
 && test -n "$LIBRARY_PATH"       \
 && test -n "$LD_LIBRARY_PATH"    \
 && test -n "$LD_RUN_PATH"        \
 && test -n "$PKG_CONFIG_LIBDIR"  \
 && test -n "$PKG_CONFIG_PATH"    \
 && exec true || exec false
RUN tor --verify-config
RUN sleep 91 \
 && git clone --depth=1 --recursive https://github.com/InnovAnon-Inc/doom-base.git \
 && rm -rf                                                           doom-base

# TODO ?
#FROM squash as final
#FROM builder-01 as final

#FROM builder-01 as squash-tmp
#USER root
#RUN  squash.sh
#FROM scratch as squash
#ADD --from=squash-tmp /tmp/final.tar /


FROM builder-01
