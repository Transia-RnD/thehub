FROM ubuntu:kinetic

WORKDIR /io

ENV BOOST_ROOT=/io/boost_1_75_0

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y build-essential && \
    apt-get install -y git && \
    apt-get install -y pkg-config && \
    apt-get install -y protobuf-compiler && \
    apt-get install -y libprotobuf-dev && \
    apt-get install -y libssl-dev && \
    apt-get install -y wget && \
    apt-get install -y doxygen

RUN wget https://github.com/Kitware/CMake/releases/download/v3.23.1/cmake-3.23.1-Linux-x86_64.sh && \
    sh cmake-3.23.1-Linux-x86_64.sh --prefix=/usr/local --exclude-subdir

RUN wget https://boostorg.jfrog.io/artifactory/main/release/1.75.0/source/boost_1_75_0.tar.gz && \
    tar -xvzf boost_1_75_0.tar.gz && \
    cd boost_1_75_0 && ./bootstrap.sh && ./b2 -j 8

ENTRYPOINT /bin/bash