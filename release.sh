#!/bin/bash
# ./release.sh transia icv2 latest amendments/icv2

echo "Docker Username: $1"
echo "Branch: $2"
echo "Tag/Version: $3"
echo "Directory: $4"
echo "zip location: $4/releases/$3/$3.zip"
# Stop, remove and run the build
docker stop $2 && docker rm $2 && docker run -d -it --name $2 $1/$2:$3 && \
# make the release dir, copy the rippled exe from the docker and stop
mkdir $4/releases/$3/ && docker cp $2:/app/rippled $4/releases/$3/rippled && docker stop $2 && \
# Zip the rippled exe
zip -r $4/releases/$3/$3.zip $4/releases/$3/rippled && \
# Tag and release to gihub
git tag $2:$3 -m $3 && git push --follow-tags && \
# export GITHUB_TOKEN=$5 # For local dev testing
gh release create $3 --generate-notes && gh release upload $2:$3 $4/releases/$3/$3.zip
