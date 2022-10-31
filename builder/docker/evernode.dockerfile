# docker build --platform=linux/amd64 -t gcr.io/metaxrplorer/evernode:base -f builder/docker/evernode.dockerfile .
# Clone the repository
FROM ubuntu:jammy as cloner
WORKDIR /app

RUN apt-get update && \
    apt-get install -y build-essential && \
    apt-get install -y git

ENTRYPOINT /bin/bash

sudo fallocate -l 2G /swapfile && sudo chmod 600 /swapfile && sudo mkswap /swapfile && sudo swapon /swapfile && sudo swapon -s

# sudo ufw enable
# sudo ufw allow in 22861:22867/tcp
# sudo ufw allow in 26201:26207/tcp
# sudo ufw allow ssh