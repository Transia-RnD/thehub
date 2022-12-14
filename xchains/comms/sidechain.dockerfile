# docker build --platform=linux/amd64 -t gcr.io/metaxrplorer/comms:base -f Dockerfile . --build-arg XCHAIN_CONFIG_DIR=/config
# docker run --rm -it gcr.io/metaxrplorer/comms:base
FROM ubuntu:jammy as cloner

LABEL maintainer="dangell@transia.co"
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=America/New_York

ARG XCHAIN_CONFIG_DIR
ENV XCHAIN_CONFIG_DIR $XCHAIN_CONFIG_DIR

ENV PIP_DEFAULT_TIMEOUT=100 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_NO_CACHE_DIR=1 \
    POETRY_VERSION=1.2.1

COPY config /config
COPY config.json /root/.config/sidechain-cli/config.json

RUN apt-get update && \
    apt-get install -y git && \
    apt-get install -y software-properties-common && \
    add-apt-repository ppa:deadsnakes/ppa && \
    apt-get install -y python3.11 && \
    apt-get install -y python3-pip && \
    apt-get install -y jq

WORKDIR /app

# install poetry
RUN curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python3 -
RUN pip3 install "poetry==$POETRY_VERSION"

RUN git clone https://github.com/Transia-RnD/sidechain-cli.git

WORKDIR sidechain-cli

RUN poetry install

# ENTRYPOINT [". /app/sidechain-cli/.venv/bin/activate"]
ENTRYPOINT /bin/bash
