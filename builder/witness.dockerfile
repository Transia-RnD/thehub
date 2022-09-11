FROM ubuntu:kinetic as cloner
WORKDIR /app

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y git

RUN git clone https://github.com/seelabs/xbridge_witness

FROM transia/builder:1.75.0 as builder
WORKDIR /app
COPY --from=cloner /app/xbridge_witness /witness

ARG BOOST_ROOT
ENV BOOST_ROOT $BOOST_ROOT
ARG Boost_LIBRARY_DIRS
ENV Boost_LIBRARY_DIRS $Boost_LIBRARY_DIRS
ARG BOOST_INCLUDEDIR
ENV BOOST_INCLUDEDIR $BOOST_INCLUDEDIR

RUN mkdir -p build/gcc.release && cd build/gcc.release && cmake -DCMAKE_BUILD_TYPE=Release ../.. && cmake --build . -j17

ENTRYPOINT /bin/bash

FROM ubuntu:kinetic as deployer

WORKDIR /app

COPY --from=builder /app/build/gcc.release/attn_server /app/attn_server

ENTRYPOINT /bin/bash