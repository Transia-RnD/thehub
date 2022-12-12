# Holy Build Box Rippled Core Dependency Image
# docker build -t gcr.io/metaxrplorer/core:latest -f builder/docker/core.dockerfile . --build-arg BOOST_VERSION=boost_1_75_0 --build-arg CMAKE_VERSION=3.23.1 3--build-arg PROTOBUF_VERSION=3.20.0 LLD_VERSION=13.0.1
FROM ghcr.io/foobarwidget/holy-build-box-x64

WORKDIR /io

ARG BOOST_VERSION
ENV BOOST_VERSION $BOOST_VERSION

ENV BOOST_ROOT=/io/$BOOST_VERSION

RUN yum install -y wget lz4 lz4-devel git llvm13-static.x86_64 llvm13-devel.x86_64 devtoolset-10-binutils zlib-static ncurses-static -y \
    gcc-c++ \
    snappy snappy-devel \
    zlib zlib-devel \
    lz4-devel \
    libasan

RUN echo "-- Install ZStd 1.1.3 --" && \
    yum install epel-release -y && \
    ZSTD_VERSION="1.1.3" && \
    wget -nc -O zstd-${ZSTD_VERSION}.tar.gz https://github.com/facebook/zstd/archive/v${ZSTD_VERSION}.tar.gz && \
    tar xzvf zstd-${ZSTD_VERSION}.tar.gz && \
    cd zstd-${ZSTD_VERSION} && \
    make -j8 && make install

RUN echo "-- Install Cmake 3.23.1 --" && \
    pwd && \
    wget -nc https://github.com/Kitware/CMake/releases/download/v3.23.1/cmake-3.23.1-linux-x86_64.tar.gz && \
    tar -xzf cmake-3.23.1-linux-x86_64.tar.gz -C /hbb/

RUN echo "-- Install Boost 1.75.0 --" && \
    pwd && \
    wget -nc https://boostorg.jfrog.io/artifactory/main/release/1.75.0/source/boost_1_75_0.tar.gz && \
    tar -xzf boost_1_75_0.tar.gz && \
    cd boost_1_75_0 && ./bootstrap.sh && ./b2 link=static -j8 && ./b2 install

RUN echo "-- Install Protobuf 3.20.0 --" && \
    pwd && \
    wget -nc https://github.com/protocolbuffers/protobuf/releases/download/v3.20.0/protobuf-all-3.20.0.tar.gz && \
    tar -xzf protobuf-all-3.20.0.tar.gz && \
    cd protobuf-3.20.0/ && \
    ./autogen.sh && ./configure --prefix=/usr --disable-shared link=static && make -j8 && make install

RUN echo "-- Install LLD 13.0.1 --" && \
    pwd && \
    ln /usr/bin/llvm-config-13 /usr/bin/llvm-config && \
    mv /opt/rh/devtoolset-9/root/usr/bin/ar /opt/rh/devtoolset-9/root/usr/bin/ar-9 && \
    ln /opt/rh/devtoolset-10/root/usr/bin/ar  /opt/rh/devtoolset-9/root/usr/bin/ar && \
    wget -nc https://github.com/llvm/llvm-project/releases/download/llvmorg-13.0.1/lld-13.0.1.src.tar.xz && \
    wget -nc https://github.com/llvm/llvm-project/releases/download/llvmorg-13.0.1/libunwind-13.0.1.src.tar.xz && \
    tar -xf lld-13.0.1.src.tar.xz && \
    tar -xf libunwind-13.0.1.src.tar.xz && \
    cp -r libunwind-13.0.1.src/include libunwind-13.0.1.src/src lld-13.0.1.src/ && \
    cd lld-13.0.1.src && \
    rm -rf build CMakeCache.txt && \
    mkdir build && \
    cd build && \
    cmake .. -DLLVM_LIBRARY_DIR=/usr/lib64/llvm13/lib/ -DCMAKE_INSTALL_PREFIX=/usr/lib64/llvm13/ -DCMAKE_BUILD_TYPE=Release && \
    make -j8 && \
    make install && \
    ln -s /usr/lib64/llvm13/lib/include/lld /usr/include/lld && \
    cp /usr/lib64/llvm13/lib/liblld*.a /usr/local/lib/

ENTRYPOINT /bin/bash