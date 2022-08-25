#!/bin/bash
# tag.sh 

git tag $1-$2 -f && git push origin $1-$2 -f