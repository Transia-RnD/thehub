# docker build --platform=linux/amd64 -t gcr.io/metaxrplorer/witness:base -f builder/witness.dockerfile . --build-arg BOOST_ROOT=/app/boost_1_75_0 --build-arg Boost_LIBRARY_DIRS=/app/boost_1_75_0/libs --build-arg BOOST_INCLUDEDIR=/app/boost_1_75_0/boost 
FROM ubuntu:kinetic as cloner
WORKDIR /app

RUN apt-get update && \
    apt-get install -y git

RUN git clone https://github.com/seelabs/xbridge_witness witness

FROM gcr.io/metaxrplorer/boost as builder
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
    apt-get install -y git
    # apt-get install -y software-properties-common && \
    # add-apt-repository ppa:deadsnakes/ppa && \
    # apt-get install -y python3.11 && \
    # apt-get install -y python3-pip && \
    # apt-get install -y gcc && \
    # apt-get install -y g++ && \
    # apt-get install -y ninja-build

# RUN pip install conan

RUN mkdir build && cd build && \
    cmake .. -Wno-dev && \
    cmake --build . -j32
    # conan install -b missing --settings build_type=Debug .. && \
    # cmake -DCMAKE_BUILD_TYPE=Debug -GNinja -Dunity=Off .. && \
    # ninja

ENTRYPOINT /bin/bash

FROM ubuntu:kinetic as deployer

WORKDIR /app

COPY --from=builder /app/build/witness /app/witness

ENTRYPOINT /bin/bash