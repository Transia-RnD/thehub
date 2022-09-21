FROM ubuntu:kinetic as cloner
WORKDIR /app

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y git

RUN git clone htps://@github.com:Transia-RnD/XRPL-Technical-Explorer.git explorer

FROM node:18.2.0-alpine AS builder
WORKDIR /app
ENV NODE_ENV=production

ARG VUE_APP_WSS_ENDPOINT
ENV VUE_APP_WSS_ENDPOINT $VUE_APP_WSS_ENDPOINT

COPY --from=cloner /app/explorer /app

COPY ./package.json ./yarn.lock /app/
RUN yarn install --production
RUN yarn run build

ENV HOST=0.0.0.0
ENV PORT=3000
USER node
EXPOSE 3000
CMD [ "npm", "run", "serve" ]

# production environment
# FROM nginx:stable-alpine
# COPY --from=builder /app/dist /usr/share/nginx/html
# COPY --from=builder /app/public /usr/share/nginx/html/public
# COPY nginx/nginx.conf /etc/nginx/conf.d/default.conf
# EXPOSE 3000
# CMD ["nginx", "-g", "daemon off;"]