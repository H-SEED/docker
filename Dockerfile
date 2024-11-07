################################################################################
# Dockerfile for my-build-env-base
################################################################################

# Base image
FROM rockylinux:8

# Author
LABEL authors="hyunseed@naver.com"

# Timezone
ENV TZ=Asia/Seoul

# Update and install with dnf
RUN dnf -y update && \
    dnf -y groupinstall "Development Tools" && \
    dnf -y install  cmake \
                    iproute \
                    libnsl \
                    lsof \
                    net-tools \
                    openssh \
                    openssh-clients \
                    openssh-ldap \
                    openssh-server \
                    passwd \
                    perl \
                    procps \
                    python3 \
                    rpm \
                    sudo \
                    git \
                    jq \
                    unzip \
                    curl \
                    wget \
                    vim \
                    wget \
                    xterm \
                    bzip2-devel \
                    c-ares-devel \
                    glib2-devel \
                    libcurl-devel \
                    nss-devel \
                    openldap-devel \
                    openssl-devel \
                    perl-devel \
                    python3-devel \
                    libzip-devel \
                    xz-devel \
                    libzstd-devel \
                    zlib-devel && \
    pip3 install meson ninja

# Set libnsl.so linking
WORKDIR /usr/lib64
RUN ln -s libnsl.so.1 libnsl.so

RUN mkdir -p    /usr/local/tmp                  \
                /usr/local/src/make/build       \
                /usr/local/src/autoconf/build   \
                /usr/local/src/automake/build   \
                /usr/local/src/libtool/build    \
                /usr/local/src/texinfo/build    \
                /usr/local/src/binutils/build   \
                /usr/local/src/pkg-config/build \
                /usr/local/src/gmp/build        \
                /usr/local/src/isl/build        \
                /usr/local/src/mpfr/build       \
                /usr/local/src/mpc/build        \
                /usr/local/src/gcc/build        \
                /usr/local/src/gdb/build        \
                /usr/local/src/uv/build         \
                /usr/local/src/jsoncpp/build    \
                /usr/local/src/boost

# Extract archive files
COPY ./archive/base/* /usr/local/tmp/
RUN tar xf /usr/local/tmp/make.tar.gz       -C /usr/local/src/make          && \
    tar xf /usr/local/tmp/autoconf.tar.gz   -C /usr/local/src/autoconf      && \
    tar xf /usr/local/tmp/automake.tar.gz   -C /usr/local/src/automake      && \
    tar xf /usr/local/tmp/libtool.tar.gz    -C /usr/local/src/libtool       && \
    tar xf /usr/local/tmp/texinfo.tar.gz    -C /usr/local/src/texinfo       && \
    tar xf /usr/local/tmp/binutils.tar.gz   -C /usr/local/src/binutils      && \
    tar xf /usr/local/tmp/pkg-config.tar.gz -C /usr/local/src/pkg-config    && \
    tar xf /usr/local/tmp/gmp.tar.gz        -C /usr/local/src/gmp           && \
    tar xf /usr/local/tmp/isl.tar.gz        -C /usr/local/src/isl           && \
    tar xf /usr/local/tmp/mpfr.tar.gz       -C /usr/local/src/mpfr          && \
    tar xf /usr/local/tmp/mpc.tar.gz        -C /usr/local/src/mpc           && \
    tar xf /usr/local/tmp/gcc.tar.gz        -C /usr/local/src/gcc           && \
    tar xf /usr/local/tmp/gdb.tar.gz        -C /usr/local/src/gdb           && \
    tar xf /usr/local/tmp/uv.tar.gz         -C /usr/local/src/uv            && \
    tar xf /usr/local/tmp/jsoncpp.tar.gz    -C /usr/local/src/jsoncpp       && \
    tar xf /usr/local/tmp/boost.tar.gz      -C /usr/local/src/boost         && \
    # Cleanup archive files
    rm -rf /usr/local/tmp

################################################################################
# Build default tools
################################################################################

# make
WORKDIR /usr/local/src/make/build
RUN ../make-4.4.1/configure && \
    make -j$(nproc) && \
    make install && \
    rm -rf *
ENV MAKE=/usr/local/bin/make
ENV PATH=$PATH

# autoconf
WORKDIR /usr/local/src/autoconf/build
RUN ../autoconf-2.72/configure && \
    make -j$(nproc) && \
    make install && \
    rm -rf *

# automake
WORKDIR /usr/local/src/automake/build
RUN ../automake-1.16.5/configure && \
    make -j$(nproc) && \
    make install && \
    rm -rf *

# libtool
WORKDIR /usr/local/src/libtool/build
RUN ../libtool-2.4.7/configure && \
    make -j$(nproc) && \
    make install && \
    rm -rf *

# texinfo
WORKDIR /usr/local/src/texinfo/build
RUN ../texinfo-7.1/configure && \
    make -j$(nproc) && \
    make install && \
    rm -rf *
ENV PATH=$PATH

# binutils
WORKDIR /usr/local/src/binutils/build
RUN ../binutils-2.42/configure && \
    make -j$(nproc) && \
    make install && \
    rm -rf *
ENV PATH=$PATH

# Install Go 1.23.2 (x86_64)
RUN wget https://go.dev/dl/go1.23.2.linux-amd64.tar.gz -P /tmp && \
    tar -C /usr/local -xzf /tmp/go1.23.2.linux-amd64.tar.gz && \
    rm -f /tmp/go1.23.2.linux-amd64.tar.gz

# Set Go environment variables
ENV GOROOT=/usr/local/go
ENV GOPATH=/go
ENV PATH=$GOROOT/bin:$PATH

# pkg-config
WORKDIR /usr/local/src/pkg-config/build
RUN ../pkg-config-0.29.2/configure && \
    make -j$(nproc) && \
    make install && \
    rm -rf *
ENV PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/usr/lib/pkgconfig:/usr/lib64/pkgconfig:/usr/local/lib/pkgconfig:/usr/local/lib64/pkgconfig
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib:/usr/lib64:/usr/local/lib:/usr/local/lib64
ENV LD_RUN_PATH=$LD_LIBRARY_PATH
ENV PATH=$PATH

################################################################################
# Build GCC/GDB
################################################################################

# gmp
WORKDIR /usr/local/src/gmp/build
RUN ../gmp-6.3.0/configure --enable-shared=no && \
    make -j$(nproc) && \
    make install && \
    rm -rf *

# isl
WORKDIR /usr/local/src/isl/build
RUN ../isl-0.26/configure --enable-shared=no && \
    make -j$(nproc) && \
    make install && \
    rm -rf *

# mpfr
WORKDIR /usr/local/src/mpfr/build
RUN ../mpfr-4.2.1/configure --enable-shared=no && \
    make -j$(nproc) && \
    make install && \
    rm -rf *

# mpc
WORKDIR /usr/local/src/mpc/build
RUN ../mpc-1.3.1/configure --enable-shared=no && \
    make -j$(nproc) && \
    make install && \
    rm -rf *

# gcc
WORKDIR /usr/local/src/gcc/build
RUN ../gcc-11.4.0/configure --enable-languages=c,c++ --disable-multilib --with-static-standard-libraries && \
    make -j$(nproc) && \
    make install && \
    rm -rf *
ENV CC=/usr/local/bin/gcc
ENV CXX=/usr/local/bin/g++
ENV PATH=$PATH

# gdb
WORKDIR /usr/local/src/gdb/build
RUN ../gdb-15.1/configure --with-static-standard-libraries && \
    make -j$(nproc) && \
    make install && \
    rm -rf *
ENV PATH=$PATH

################################################################################
# Building libraries unrelated to ffmpeg
################################################################################

# uv
WORKDIR /usr/local/src/uv/libuv-1.48.0
RUN ./autogen.sh
WORKDIR /usr/local/src/uv/build
RUN ../libuv-1.48.0/configure --enable-shared=no && \
    make -j$(nproc) && \
    make install && \
    rm -rf *

# jsoncpp
WORKDIR /usr/local/src/jsoncpp/build
RUN cmake ../jsoncpp-1.9.5 -DJSONCPP_WITH_TESTS=0 -DJSONCPP_WITH_EXAMPLE=0 -DBUILD_SHARED_LIBS=0 -DBUILD_STATIC_LIBS=1 && \
    make -j$(nproc) && \
    make install && \
    rm -rf *

# boost
WORKDIR /usr/local/src/boost/boost-1.83.0
RUN ./bootstrap.sh && \
    ./b2 -j$(nproc) variant=release threading=multi link=static runtime-link=static install && \
    ./b2 --clean

################################################################################
# Complete!
################################################################################

# Copy default .bashrc
WORKDIR /root
COPY ./profile/* ./