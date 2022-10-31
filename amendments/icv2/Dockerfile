FROM gcr.io/metaxrplorer/icv2:base as base

WORKDIR /app

LABEL maintainer="dangell@transia.co"

RUN export LANGUAGE=C.UTF-8; export LANG=C.UTF-8; export LC_ALL=C.UTF-8; export DEBIAN_FRONTEND=noninteractive

COPY config /config
COPY entrypoint /entrypoint.sh

RUN chmod +x /entrypoint.sh && \
    echo '#!/bin/bash' > /usr/bin/server_info && echo '/entrypoint.sh server_info' >> /usr/bin/server_info && \
    chmod +x /usr/bin/server_info

EXPOSE 80 443 5005 6006 51235

RUN export DOCKER_BUILDKIT=1

FROM base AS production
RUN echo "PRODUCTION RIPPLED"
ENTRYPOINT [ "/entrypoint.sh" ]

FROM base AS standalone
RUN echo "STANDALONE RIPPLED"
ENTRYPOINT [ "/entrypoint.sh", "-a" ]
