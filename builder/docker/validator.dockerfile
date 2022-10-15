# docker build -t gcr.io/metaxrplorer/base:latest -f builder/docker/base.dockerfile . --build-arg BOOST_ROOT=/io/boost_1_75_0 --build-arg Boost_LIBRARY_DIRS=/io/boost_1_75_0/libs --build-arg BOOST_INCLUDEDIR=/io/boost_1_75_0/boost 
FROM ubuntu:kinetic as cloner
WORKDIR /app

RUN apt-get update && \
    apt-get install -y git

RUN git clone https://github.com/ripple/validator-keys-tool.git

FROM gcr.io/metaxrplorer/boost:latest as builder

COPY --from=cloner /app/validator-keys-tool /app

ARG BOOST_ROOT
ENV BOOST_ROOT $BOOST_ROOT
ARG Boost_LIBRARY_DIRS
ENV Boost_LIBRARY_DIRS $Boost_LIBRARY_DIRS
ARG BOOST_INCLUDEDIR
ENV BOOST_INCLUDEDIR $BOOST_INCLUDEDIR

WORKDIR /app

RUN mkdir build && cd build && \
    cmake -DCMAKE_BUILD_TYPE=Release .. -Wno-dev && \
    cmake --build . -j8

ENTRYPOINT /bin/bash

FROM ubuntu:kinetic as deployer

WORKDIR /app

COPY --from=builder /validator/build/validator-keys /app/validator

ENTRYPOINT /bin/bash