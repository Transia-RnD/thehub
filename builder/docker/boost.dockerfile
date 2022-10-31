
FROM ubuntu:kinetic

WORKDIR /io

ARG BOOST_DIR
ENV BOOST_DIR $BOOST_DIR
ARG BOOST_VERSION
ENV BOOST_VERSION $BOOST_VERSION

ENV BOOST_ROOT=/io/$BOOST_DIR

RUN apt-get update && \
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

RUN wget https://boostorg.jfrog.io/artifactory/main/release/$BOOST_VERSION/source/$BOOST_DIR.tar.gz && \
    tar -xvzf $BOOST_DIR.tar.gz && \
    cd $BOOST_DIR && ./bootstrap.sh && ./b2 -j 8

ENTRYPOINT /bin/bash