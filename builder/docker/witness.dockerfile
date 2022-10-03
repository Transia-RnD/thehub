# docker build --platform=linux/amd64 -t gcr.io/metaxrplorer/witness:base -f builder/docker/witness.dockerfile . --build-arg BOOST_ROOT=/io/boost_1_79_0 --build-arg Boost_LIBRARY_DIRS=/io/boost_1_79_0/libs --build-arg BOOST_INCLUDEDIR=/io/boost_1_79_0/boost 
# Clone the repository
FROM ubuntu:jammy as cloner
WORKDIR /app

RUN apt-get update && \
    apt-get install -y git

RUN git clone https://github.com/seelabs/xbridge_witness witness

# Build the service
# FROM gcr.io/metaxrplorer/boost:latest as builder
FROM ubuntu:jammy as builder
WORKDIR /app
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=America/New_York

COPY --from=cloner /app/witness /app

ARG BOOST_ROOT
ENV BOOST_ROOT $BOOST_ROOT
ARG Boost_LIBRARY_DIRS
ENV Boost_LIBRARY_DIRS $Boost_LIBRARY_DIRS
ARG BOOST_INCLUDEDIR
ENV BOOST_INCLUDEDIR $BOOST_INCLUDEDIR

RUN apt-get update && \
    apt-get install -y build-essential && \
    apt-get install -y git && \
    apt-get install -y pkg-config && \
    apt-get install -y protobuf-compiler && \
    apt-get install -y libprotobuf-dev && \
    apt-get install -y libssl-dev && \
    apt-get install -y doxygen && \
    apt-get install -y wget && \
    apt-get install -y software-properties-common && \
    add-apt-repository ppa:deadsnakes/ppa && \
    apt-get install -y python3.11 && \
    apt-get install -y python3-pip && \
    apt-get install -y gcc && \
    apt-get install -y g++ && \
    apt-get install -y ninja-build

RUN wget https://github.com/Kitware/CMake/releases/download/v3.23.1/cmake-3.23.1-Linux-x86_64.sh && \
    sh cmake-3.23.1-Linux-x86_64.sh --prefix=/usr/local --exclude-subdir

RUN wget https://boostorg.jfrog.io/artifactory/main/release/1.79.0/source/boost_1_79_0.tar.gz && \
    tar -xvzf boost_1_79_0.tar.gz && \
    cd boost_1_79_0 && ./bootstrap.sh && ./b2 -j 32
    
RUN pip3 install conan

RUN mkdir build && cd build && \
    conan profile new default --detect && \
    conan profile update settings.compiler.libcxx=libstdc++11 default && \
    conan install -b missing --settings build_type=Debug .. && \
    cmake -DCMAKE_BUILD_TYPE=Debug -GNinja -Dunity=Off .. && \
    ninja

ENTRYPOINT /bin/bash

# Pull exe from build directory so that the image ONLY contains the exe
FROM ubuntu:jammy as deployer

WORKDIR /app

COPY --from=builder /app/build/xbridge_witnessd /app/witness

ENTRYPOINT /bin/bash