# docker build --platform=linux/amd64 -t gcr.io/metaxrplorer/comms:base -f Dockerfile . --build-arg XCHAIN_CONFIG_DIR=/app/config --build-arg RIPPLED_EXE=/app/rippled --build-arg WITNESSD_EXE=/app/witness 
# docker run --rm -it gcr.io/metaxrplorer/comms:base
FROM gcr.io/metaxrplorer/xchain:base as rippled_base
ENTRYPOINT /bin/bash

FROM transia/witness:latest as witness_base
ENTRYPOINT /bin/bash

FROM ubuntu:kinetic as cloner

LABEL maintainer="dangell@transia.co"
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=America/New_York

ARG XCHAIN_CONFIG_DIR
ENV XCHAIN_CONFIG_DIR $XCHAIN_CONFIG_DIR
ARG RIPPLED_EXE
ENV RIPPLED_EXE $RIPPLED_EXE
ARG WITNESSD_EXE
ENV WITNESSD_EXE $WITNESSD_EXE
ENV PIP_DEFAULT_TIMEOUT=100 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_NO_CACHE_DIR=1 \
    POETRY_VERSION=1.2.1

COPY --from=rippled_base /app/rippled $RIPPLED_EXE
COPY --from=witness_base /app/witness $WITNESSD_EXE

RUN apt-get update && \
    apt-get install -y git && \
    apt-get install -y software-properties-common && \
    add-apt-repository ppa:deadsnakes/ppa && \
    apt-get install -y python3.11 && \
    apt-get install -y python3-pip && \
    apt-get install -y cmake && \
    apt-get install -y jq

WORKDIR /app

# install poetry
RUN curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python3 -
RUN pip3 install "poetry==$POETRY_VERSION"

RUN git clone https://github.com/Transia-RnD/sidechain-cli.git

WORKDIR sidechain-cli

RUN poetry install

RUN mkdir /app/config

# CMD [ "poetry", "shell", "./scripts/tutorial.sh" ]
ENTRYPOINT /bin/bash
