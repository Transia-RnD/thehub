FROM gcr.io/metaxrplorer/testnet:base as base

# RIPPLED (BUILD) IS IN /app/rippled
WORKDIR /app

LABEL maintainer="w@xrpl-labs.com"

RUN export LANGUAGE=C.UTF-8; export LANG=C.UTF-8; export LC_ALL=C.UTF-8; export DEBIAN_FRONTEND=noninteractive

COPY config /config
COPY entrypoint /entrypoint.sh

RUN chmod +x /entrypoint.sh && \
    echo '#!/bin/bash' > /usr/bin/server_info && echo '/entrypoint.sh server_info' >> /usr/bin/server_info && \
    chmod +x /usr/bin/server_info

EXPOSE 80 443 5005 6006 51235

FROM base AS genesis
RUN echo "BUILDING GENESIS RIPPLED"
ENTRYPOINT [ "/entrypoint.sh", "-a" ]


FROM base AS production
RUN echo "BUILDING PRODUCTION RIPPLED"
ENTRYPOINT [ "/entrypoint.sh" ]
