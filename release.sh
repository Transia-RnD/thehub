#!/bin/bash
# ./release.sh gcr.io/metaxrplorer icv2 latest

echo "Docker Username: $1"
echo "Name: $2"
echo "Version: $3"
echo "Image: $1/$2:$3"
echo "Container Name: $2-$3"
echo "Tag Name: $2-$3"

# Stop, remove and run the build
{ # try
  docker stop $2-$3
  echo "Stopped Docker"
  docker rm $2-$3
  echo "Removed Docker"
} || { # catch
  echo "Docker not running"
}

# Release the version
{ # try
  docker run -d -it --name $2-$3 $1/$2:$3 && \
  # make the release dir, copy the rippled exe from the docker and stop
  docker cp $2-$3:/app/rippled rippled && docker stop $2-$3 && \
  # Zip the rippled exe
  zip -r rippled.zip rippled && \
  echo "Zipped rippled"
} || { # catch
  echo "Docker dne"
  exit 1
}

echo "Build host: `hostname`" > release.info && \
echo "Build date: `date`" >> release.info && \
# echo "Build md5: `md5sum rippled`" >> release.info && \
echo "Image - ubuntu+rippled: $1/$2:base" >> release.info && \
echo "Image - rippled+config: $1/$2:$3" >> release.info && \
echo "" >> release.info && \
echo "Run with: " >> release.info && \
echo "docker run -dit --name rippled -p 80:80 $1/$2:$3" >> release.info && \
echo "" >> release.info

# Release the version
{ # try
  gh release delete $2-$3 -y
  echo "Deleted Release"
  gh release create $2-$3 --notes-file release.info
  echo "Created Release"
} || { # catch
  echo "Release dne"
  gh release create $2-$3 --notes-file release.info
}
gh release upload $2-$3 rippled.zip