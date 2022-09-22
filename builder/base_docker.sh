#!/bin/bash
docker build --platform=linux/amd64 --tag transia/builder:1.79.0 . -f debug/Dockerfile && \
docker create transia/builder:1.79.0 && \
docker push transia/builder:1.79.0