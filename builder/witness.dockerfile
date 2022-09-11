FROM ubuntu:kinetic as cloner
WORKDIR /app

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y git

RUN git clone https://github.com/seelabs/xbridge_witness

FROM ubuntu:kinetic as builder
WORKDIR /app
COPY --from=cloner /app/xbridge_witness /witness

RUN mkdir build/gcc.release && cd build/gcc.release && cmake -DCMAKE_BUILD_TYPE=Release ../.. && cmake --build . -j17

ENTRYPOINT /bin/bash

FROM ubuntu:kinetic as deployer

WORKDIR /app

COPY --from=builder /app/build/xbridge_witness/attn_server /app/attn_server

ENTRYPOINT /bin/bash