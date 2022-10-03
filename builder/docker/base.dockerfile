# docker build -t gcr.io/metaxrplorer/base:latest -f builder/docker/base.dockerfile . --build-arg REPO=https://github.com/Transia-RnD/rippled.git --build-arg BRANCH=PaychanAndEscrowForTokens --build-arg BOOST_ROOT=/io/boost_1_75_0 --build-arg Boost_LIBRARY_DIRS=/io/boost_1_75_0/libs --build-arg BOOST_INCLUDEDIR=/io/boost_1_75_0/boost 
FROM ubuntu:kinetic as cloner
WORKDIR /app

ARG REPO
ENV REPO $REPO
ARG BRANCH
ENV BRANCH $BRANCH

RUN apt-get update && \
    apt-get install -y git

RUN git clone $REPO
RUN cd rippled && git checkout $BRANCH

FROM gcr.io/metaxrplorer/boost:latest as builder

WORKDIR /app
COPY --from=cloner /app/rippled /app

ARG BOOST_ROOT
ENV BOOST_ROOT $BOOST_ROOT
ARG Boost_LIBRARY_DIRS
ENV Boost_LIBRARY_DIRS $Boost_LIBRARY_DIRS
ARG BOOST_INCLUDEDIR
ENV BOOST_INCLUDEDIR $BOOST_INCLUDEDIR

RUN mkdir build && cd build && \
    cmake .. -Wno-dev && \
    cmake -Dunity=Off --build . -j8 && \
    strip -s rippled

ENTRYPOINT /bin/bash

FROM ubuntu:kinetic as definitions
WORKDIR /app

RUN apt-get update && \
    apt-get install -y git && \
    apt-get install -y nodejs

COPY --from=cloner /app/rippled /app

RUN git clone https://github.com/RichardAH/xrpl-codec-gen.git
RUN cd xrpl-codec-gen && node gen.js /app/src/ripple > /app/definitions.json

FROM ubuntu:kinetic as deployer

WORKDIR /app

COPY --from=definitions /app/definitions.json /app/definitions.json
COPY --from=builder /app/build/rippled /app/rippled

ENTRYPOINT /bin/bash