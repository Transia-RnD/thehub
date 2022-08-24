#!/bin/bash
# docker build --platform=linux/x86_64 --tag transia/xrpld-standalone:latest . && docker create transia/xrpld-standalone
# docker push transia/xrpld-standalone:latest

docker build --platform=linux/x86_64 --tag transia/paychan-escrow:alone . --build-arg BOOST_ROOT=/io/boost_1_75_0 --build-arg Boost_LIBRARY_DIRS=/io/boost_1_75_0/libs --build-arg BOOST_INCLUDEDIR=/io/boost_1_75_0/boost