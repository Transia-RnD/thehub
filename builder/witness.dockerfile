FROM ubuntu:kinetic as builder
WORKDIR /app

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y build-essential && \
    apt-get install -y git && \
    apt-get install -y ninja-build && \
    apt-get install -y cmake && \
    apt-get install -y gcc && \
    apt-get install -y g++ && \
    apt-get install -y software-properties-common && \
    add-apt-repository ppa:deadsnakes/ppa && \
    apt-get install -y python3.11 && \
    apt-get install -y python3-pip && \
    apt-get install -y wget

RUN git clone https://github.com/seelabs/xbridge_witness witness

RUN pip install conan

RUN wget https://github.com/Kitware/CMake/releases/download/v3.23.1/cmake-3.23.1-Linux-x86_64.sh && \
    sh cmake-3.23.1-Linux-x86_64.sh --prefix=/usr/local --exclude-subdir

RUN wget https://boostorg.jfrog.io/artifactory/main/release/1.75.0/source/boost_1_79_0.tar.gz && \
    tar -xvzf boost_1_79_0.tar.gz && \
    cd boost_1_79_0 && ./bootstrap.sh && ./b2 -j17

RUN mkdir -p /app/witness/build

WORKDIR /app/witness/build

RUN conan install -b missing --settings build_type=Debug .. && \
    cmake .. && make -j17