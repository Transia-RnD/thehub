#!/bin/bash
# tag.sh 

{ # try
  echo "Deleting origin tag: $1-$2"
  git push --delete origin $1-$2

} || { # catch
  # save log for exception
  # echo "origin tag: $1-$2 doesn't exist"
}
{ # try
  echo "Deleting local tag: $1-$2"
  git tag --delete $1-$2

} || { # catch
  # save log for exception
  # echo "local tag: $1-$2 doesn't exist"
}

git tag icv2-latest && git push origin icv2-latest