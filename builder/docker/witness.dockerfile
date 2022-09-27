# docker build --platform=linux/amd64 -t gcr.io/metaxrplorer/witness:base -f builder/witness.dockerfile . --build-arg BOOST_ROOT=/app/boost_1_75_0 --build-arg Boost_LIBRARY_DIRS=/app/boost_1_75_0/libs --build-arg BOOST_INCLUDEDIR=/app/boost_1_75_0/boost 
FROM ubuntu:kinetic as cloner
WORKDIR /app

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y git

RUN git clone https://github.com/seelabs/xbridge_witness witness

FROM transia/builder:1.79.0 as builder
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
    apt-get install -y git && \
    apt-get install -y software-properties-common && \
    add-apt-repository ppa:deadsnakes/ppa && \
    apt-get install -y python3.11 && \
    apt-get install -y python3-pip

RUN pip install conan

RUN mkdir build && \
    cd build && \
    conan install -b missing .. && \
    cmake -DCMAKE_BUILD_TYPE=Debug .. && \
    make -j17

FROM ubuntu:kinetic as deployer

WORKDIR /app

COPY --from=builder /app/build/witness /app/witness

ENTRYPOINT /bin/bash