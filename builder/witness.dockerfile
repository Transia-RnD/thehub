FROM ubuntu:kinetic as cloner
WORKDIR /app

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y git

RUN git clone https://github.com/seelabs/xbridge_witness witness

FROM ubuntu:kinetic as builder
WORKDIR /app
COPY --from=cloner /app/witness /app

ARG BOOST_ROOT
ENV BOOST_ROOT $BOOST_ROOT
ARG Boost_LIBRARY_DIRS
ENV Boost_LIBRARY_DIRS $Boost_LIBRARY_DIRS
ARG BOOST_INCLUDEDIR
ENV BOOST_INCLUDEDIR $BOOST_INCLUDEDIR

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y build-essential && \
    apt-get install -y software-properties-common && \
    add-apt-repository ppa:deadsnakes/ppa && \
    apt-get install -y python3.11 && \
    apt-get install -y python3-pip && \
    apt-get install -y pkg-config && \
    apt-get install -y protobuf-compiler && \
    apt-get install -y libprotobuf-dev && \
    apt-get install -y libssl-dev && \
    apt-get install -y wget && \
    apt-get install -y doxygen

RUN wget https://github.com/Kitware/CMake/releases/download/v3.23.1/cmake-3.23.1-Linux-x86_64.sh && \
    sh cmake-3.23.1-Linux-x86_64.sh --prefix=/usr/local --exclude-subdir

RUN wget https://boostorg.jfrog.io/artifactory/main/release/1.79.0/source/boost_1_79_0.tar.gz && \
    tar -xvzf boost_1_79_0.tar.gz && \
    cd boost_1_79_0 && ./bootstrap.sh && ./b2 -j 8

RUN pip install conan

RUN mkdir build && \
    cd build && \
    conan install -b missing .. && \
    cmake .. && \
    make -j8

FROM ubuntu:kinetic as deployer

WORKDIR /app

COPY --from=builder /app/build/witness /app/witness

ENTRYPOINT /bin/bash