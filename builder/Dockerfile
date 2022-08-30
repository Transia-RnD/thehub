FROM ubuntu:bionic as cloner
WORKDIR /app

ARG REPO
ENV REPO $REPO
ARG BRANCH
ENV BRANCH $BRANCH

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y git

RUN git clone $REPO
RUN cd rippled && git checkout $BRANCH

FROM transia/builder:1.75.0 as builder
WORKDIR /app
COPY --from=cloner /app/rippled /app

ARG BOOST_ROOT
ENV BOOST_ROOT $BOOST_ROOT
ARG Boost_LIBRARY_DIRS
ENV Boost_LIBRARY_DIRS $Boost_LIBRARY_DIRS
ARG BOOST_INCLUDEDIR
ENV BOOST_INCLUDEDIR $BOOST_INCLUDEDIR

RUN mkdir build && cd build && cmake .. -Wno-dev
RUN cd build && cmake --build . -j17 && strip -s rippled

ENTRYPOINT /bin/bash

FROM ubuntu:bionic as definitions
WORKDIR /app

ARG REPO
ENV REPO $REPO
ARG BRANCH
ENV BRANCH $BRANCH

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y git

COPY --from=builder /app/build /app/build

RUN git clone https://github.com/RichardAH/xrpl-codec-gen.git
RUN cd xrpl-codec-gen && node gen.js /app/build > definitions.json

FROM ubuntu:kinetic as deployer

WORKDIR /app

COPY --from=definitions /app/build/definitions.json /app/definitions.json
COPY --from=builder /app/build/rippled /app/rippled

ENTRYPOINT /bin/bash