FROM gcr.io/metaxrplorer/icv2:latest

WORKDIR /app

LABEL maintainer="w@xrpl-labs.com"

RUN export LANGUAGE=C.UTF-8; export LANG=C.UTF-8; export LC_ALL=C.UTF-8; export DEBIAN_FRONTEND=noninteractive

COPY entrypoint /entrypoint.sh

RUN chmod +x /entrypoint.sh && \
    echo '#!/bin/bash' > /usr/bin/server_info && echo '/entrypoint.sh server_info' >> /usr/bin/server_info && \
    chmod +x /usr/bin/server_info

EXPOSE 80 443 5005 6006 51235

ENTRYPOINT [ "/entrypoint.sh" ]
