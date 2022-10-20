# docker build --platform=linux/amd64 --tag transia/validator:latest .
FROM gcr.io/metaxrplorer/validator:base as builder

WORKDIR /app/publisher

COPY . /app/publisher

# ARG MODE
# ENV MODE $MODE

RUN apt-get update && \
    apt-get install -y build-essential && \
    apt-get install -y git && \
    apt-get install -y software-properties-common && \
    add-apt-repository ppa:deadsnakes/ppa && \
    apt-get install -y python3.11 && \
    apt-get install -y python3-pip

RUN pip3 install git+https://github.com/Transia-RnD/xrpl-py.git@beta

ENTRYPOINT /bin/bash