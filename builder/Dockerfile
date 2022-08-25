FROM ubuntu:bionic as cloner
WORKDIR /app

ARG TYPE
ENV TYPE $TYPE
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

FROM ubuntu:kinetic as releaser

WORKDIR /app

COPY . .
COPY --from=builder /app/build/rippled /app/rippled

ARG NAME
ENV NAME $NAME
ARG VERSION
ENV VERSION $VERSION
ARG GITHUB_TOKEN
ENV GITHUB_TOKEN $GITHUB_TOKEN

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y zip && \
    apt-get install -y gh && \
    apt-get install -y git

RUN zip -r /app/rippled.zip /app/rippled && \
    gh release delete $NAME-$VERSION -y && \
    gh release create $NAME-$VERSION --generate-notes && \
    gh release upload $NAME-$VERSION /app/rippled.zip

FROM ubuntu:kinetic as deployer

WORKDIR /app

COPY --from=builder /app/build/rippled /app/rippled

ENTRYPOINT /bin/bash