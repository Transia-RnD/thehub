FROM ubuntu:bionic as cloner
WORKDIR /app
RUN git clone git@github.com:RichardAH/rippled.git
RUN cd rippled && git checkout PaychanAndEscrowForTokens

FROM transia/boost:1.75.0 as builder
WORKDIR /app
COPY --from=cloner /app/rippled /app
RUN mkdir my_build && \
    cd my_build && \
    cmake -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Debug ..
    cmake --build . -- -j 4

ENTRYPOINT /bin/bash