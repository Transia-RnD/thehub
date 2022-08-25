#!/bin/bash

# Stop, remove and run the build
# docker stop $2 && docker rm $2 && docker run -d -it --name $2 $1/$2:$3 && \
# make the release dir, copy the rippled exe from the docker and stop
# mkdir $4/releases/$3/ && docker cp $2:/app/rippled $4/releases/$3/rippled && docker stop $2 && \
# create the tag and release to github
git add . && git commit -m $3 && git tag $3 -m $3 && git push --follow-tags
