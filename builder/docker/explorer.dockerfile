# docker build -t transia/explorer -f explorer.dockerfile . --build-arg VUE_APP_WSS_ENDPOINT=ws://0.0.0.0:80
FROM ubuntu:latest as cloner
WORKDIR /app

RUN apt-get update && \
    apt-get install -y git

RUN git clone https://@github.com/Transia-RnD/XRPL-Technical-Explorer.git explorer

FROM node:16.17.0-alpine AS builder
WORKDIR /app

ARG VUE_APP_WSS_ENDPOINT
ENV VUE_APP_WSS_ENDPOINT $VUE_APP_WSS_ENDPOINT

COPY --from=cloner /app/explorer /app

RUN npm install -g @vue/cli@latest
RUN npm install
RUN npm run build

ENV HOST=0.0.0.0
ENV PORT=3000
USER node
EXPOSE 3000
CMD [ "npm", "run", "serve" ]