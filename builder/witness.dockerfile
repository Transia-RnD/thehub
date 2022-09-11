FROM ubuntu:kinetic as rippledcloner
WORKDIR /app

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y git

RUN git clone https://github.com/XRPLF/rippled.git

FROM transia/builder:1.75.0 as rippledbuilder
WORKDIR /app
COPY --from=rippledcloner /app/rippled /app

ARG BOOST_ROOT
ENV BOOST_ROOT $BOOST_ROOT
ARG Boost_LIBRARY_DIRS
ENV Boost_LIBRARY_DIRS $Boost_LIBRARY_DIRS
ARG BOOST_INCLUDEDIR
ENV BOOST_INCLUDEDIR $BOOST_INCLUDEDIR

RUN mkdir build && cd build && cmake .. -Wno-dev
RUN cd build && cmake --build . -j17

ENTRYPOINT /bin/bash

FROM ubuntu:kinetic as witnesscloner
WORKDIR /app

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y git

RUN git clone https://github.com/seelabs/xbridge_witness

FROM transia/builder:1.75.0 as witnessbuilder
WORKDIR /app
COPY --from=witnesscloner /app/xbridge_witness /app
COPY --from=rippledbuilder /app /rippled

ARG BOOST_ROOT
ENV BOOST_ROOT $BOOST_ROOT
ARG Boost_LIBRARY_DIRS
ENV Boost_LIBRARY_DIRS $Boost_LIBRARY_DIRS
ARG BOOST_INCLUDEDIR
ENV BOOST_INCLUDEDIR $BOOST_INCLUDEDIR

RUN mkdir -p build/gcc.release && cd build/gcc.release && cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH=/path/to/rippled/installation/root -S ../.. && cmake --build .

ENTRYPOINT /bin/bash

FROM ubuntu:kinetic as deployer

WORKDIR /app

COPY --from=witnessbuilder /app/build/gcc.release/attn_server /app/attn_server

ENTRYPOINT /bin/bash