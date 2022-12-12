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

FROM gcr.io/metaxrplorer/core:latest as builder

WORKDIR /app
COPY --from=cloner /app/rippled /app

# ARG BOOST_ROOT
# ENV BOOST_ROOT $BOOST_ROOT
# ARG Boost_LIBRARY_DIRS
# ENV Boost_LIBRARY_DIRS $Boost_LIBRARY_DIRS
# ARG BOOST_INCLUDEDIR
# ENV BOOST_INCLUDEDIR $BOOST_INCLUDEDIR

RUN echo "-- Build Rippled --" && \
    pwd && \
    sed -E -i "s/^include.deps\/Rocksdb.$/#\0/g" CMakeLists.txt && \
    export BOOST_ROOT="/usr/local/src/boost_1_75_0" && \
    export Boost_LIBRARY_DIRS="/usr/local/lib" && \
    export BOOST_INCLUDEDIR="/usr/local/src/boost_1_75_0" && \
    cmake .. -DBoost_NO_BOOST_CMAKE=ON -DLLVM_DIR=/usr/lib64/llvm13/lib/cmake/llvm/ -DLLVM_LIBRARY_DIR=/usr/lib64/llvm13/lib/ && \
    make -j8 VERBOSE=1 && \
    strip -s rippled && \
    echo "Build host: `hostname`" > release.info && \
    echo "Build date: `date`" >> release.info && \
    echo "Build md5: `md5sum rippled`" >> release.info && \
    echo "Git remotes:" >> release.info && \
    git remote -v >> release.info  && \
    echo "Git status:" >> release.info && \
    git status -v >> release.info && \
    echo "Git log [last 20]:" >> release.info && \
    git log -n 20 >> release.info && \
    cd .. && \
    sed -E -i "s/^#(include.deps\/Rocksdb.)$/\1/g" CMakeLists.txt

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