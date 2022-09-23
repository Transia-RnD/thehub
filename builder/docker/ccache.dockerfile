# docker build -t gcr.io/metaxrplorer/ccache:base -f builder/witness.dockerfile . --build-arg BOOST_ROOT=/app/boost_1_75_0 --build-arg Boost_LIBRARY_DIRS=/app/boost_1_75_0/libs --build-arg BOOST_INCLUDEDIR=/app/boost_1_75_0/boost 
FROM ubuntu:kinetic as cloner
WORKDIR /app

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y git

RUN git clone https://github.com/XRPLF/rippled.git

FROM transia/builder:1.75.0 as builder
WORKDIR /app
COPY --from=cloner /app/rippled /app

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y ccache

ARG BOOST_ROOT
ENV BOOST_ROOT $BOOST_ROOT
ARG Boost_LIBRARY_DIRS
ENV Boost_LIBRARY_DIRS $Boost_LIBRARY_DIRS
ARG BOOST_INCLUDEDIR
ENV BOOST_INCLUDEDIR $BOOST_INCLUDEDIR

RUN mkdir build && \
    cd build && \
    cmake -DCMAKE_BUILD_TYPE=Debug -DCMAKE_CXX_COMPILER_LAUNCHER=ccache -DCMAKE_C_COMPILER_LAUNCHER=ccache .. -Wno-dev && \
    cmake --build . -j32

ENTRYPOINT /bin/bash