#!/bin/bash
# ./release.sh gcr.io/metaxrplorer icv2 latest, amendments

echo "Docker Username: $1"
echo "Name: $2"
echo "Version: $3"
echo "Image: $1/$2:$3"
echo "Container Name: $2-$3"
echo "Tag Name: $2-$3"
echo "Directory Name: $4"

# Stop, remove and run the build
{ # try
  docker stop $2-$3
  echo "Stopped Docker"
  docker rm $2-$3
  echo "Removed Docker"
} || { # catch
  echo "Docker not running"
}

# Build the release
{ # try
  if ! mkdir rippled-$2-$3; then
      echo "mkdir rippled-$2-$3 returned an error"
  fi
  docker run -d -it --name $2-$3 $1/$2:$3 && \
  # make the release dir, copy the rippled exe from the docker and stop
  docker cp $2-$3:/app/rippled rippled-$2-$3/rippled && \
  docker cp $2-$3:/app/definitions.json definitions.json && \
  docker stop $2-$3 && \
  cp $4/$2/config/rippled.cfg rippled-$2-$3/rippled.cfg && \
  cp $4/$2/config/validators.txt rippled-$2-$3/validators.txt && \
  # Zip the rippled exe
  zip -r rippled-$2-$3.zip rippled-$2-$3
  echo "Zipped rippled"
} || { # catch
  echo "Docker dne"
  exit 1
}

echo "README: https://github.com/Transia-RnD/thehub/tree/$2-latest/$4/$2" > release.info && \
echo "" >> release.info && \
echo "Build host: `hostname`" > release.info && \
echo "Build date: `date`" >> release.info && \
# echo "Build md5: `md5sum rippled`" >> release.info && \
echo "Image - ubuntu+rippled: $1/$2:base" >> release.info && \
echo "Image - rippled+config: $1/$2:$3" >> release.info && \
echo "" >> release.info && \
echo "Zip includes: " >> release.info && \
echo "- rippled" >> release.info && \
echo "- rippled.cfg: https://github.com/Transia-RnD/thehub/blob/main/$4/$2/config/rippled.cfg" >> release.info && \
echo "- validators.txt: https://github.com/Transia-RnD/thehub/blob/main/$4/$2/config/validators.txt" >> release.info && \
echo "" >> release.info
echo "Use with docker: " >> release.info && \
echo "docker run -dit --name rippled -p 80:80 $1/$2:$3" >> release.info && \
echo "" >> release.info
# echo "Deployed: https://$2.transia.co" >> release.info && \
# echo "Explorer: https://$2.transia.co/explorer" >> release.info && \
# echo "" >> release.info

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
gh release upload $2-$3 rippled-$2-$3.zip && \
gh release upload $2-$3 definitions.json