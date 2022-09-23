# docker build -t gcr.io/metaxrplorer/runner:latest -f builder/docker/runner.dockerfile . --build-arg REPO=https://github.com/Transia-RnD/rippled.git --build-arg BRANCH=PaychanAndEscrowForTokens --build-arg BOOST_ROOT=/io/boost_1_75_0 --build-arg Boost_LIBRARY_DIRS=/io/boost_1_75_0/libs --build-arg BOOST_INCLUDEDIR=/io/boost_1_75_0/boost 
# docker run --rm -it -v /Users/denisangell/projects/transia-rnd/rippled-icv2:/runner gcr.io/metaxrplorer/runner:latest
FROM ubuntu:kinetic as cloner
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

FROM gcr.io/metaxrplorer/ccache:latest as builder
WORKDIR /app
RUN mkdir /runner && cp -r /app/build /runner/build
COPY --from=cloner /app/rippled /app
RUN cp -r /runner/build /app/build

ARG BOOST_ROOT
ENV BOOST_ROOT $BOOST_ROOT
ARG Boost_LIBRARY_DIRS
ENV Boost_LIBRARY_DIRS $Boost_LIBRARY_DIRS
ARG BOOST_INCLUDEDIR
ENV BOOST_INCLUDEDIR $BOOST_INCLUDEDIR

RUN cd build && \
    cmake -DCMAKE_BUILD_TYPE=Debug -DCMAKE_CXX_COMPILER_LAUNCHER=ccache -DCMAKE_C_COMPILER_LAUNCHER=ccache .. -Wno-dev && \
    cmake --build . -j32 && \
    ./rippled -u && \
    strip -s rippled

ENTRYPOINT /bin/bash