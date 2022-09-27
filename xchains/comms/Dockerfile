# docker build -t gcr.io/metaxrplorer/witness:base -f Dockerfile . --build-arg XCHAIN_CONFIG_DIR=app/config --build-arg RIPPLED_EXE=app/rippled --build-arg WITNESSD_EXE=app/witness 
FROM gcr.io/metaxrplorer/xchain:base as rippled_base
ENTRYPOINT /bin/bash

FROM gcr.io/metaxrplorer/witness:base as witness_base
ENTRYPOINT /bin/bash

FROM ubuntu:latest as cloner

# WITNESS (BUILD) IS IN /app/witness
WORKDIR /app

LABEL maintainer="dangell@transia.co"

RUN export LANGUAGE=C.UTF-8; export LANG=C.UTF-8; export LC_ALL=C.UTF-8; export DEBIAN_FRONTEND=noninteractive

COPY --from=rippled_base /app/rippled $RIPPLED_EXE
COPY --from=witness_base /app/witness $WITNESSD_EXE

ARG XCHAIN_CONFIG_DIR
ENV XCHAIN_CONFIG_DIR $XCHAIN_CONFIG_DIR
ARG RIPPLED_EXE
ENV RIPPLED_EXE $RIPPLED_EXE
ARG WITNESSD_EXE
ENV WITNESSD_EXE $WITNESSD_EXE

RUN git clone https://github.com/xpring-eng/sidechain-cli.git

WORKDIR sidechain-cli

# install poetry
RUN curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python -
RUN poetry install

# CMD [ "poetry", "shell", "./scripts/tutorial.sh" ]
ENTRYPOINT /bin/bash
