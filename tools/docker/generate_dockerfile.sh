#!/bin/bash
image=$1

echo "FROM $(docker inspect --format='{{index .RepoTags 0}}' $image)"

docker history --no-trunc $image | awk '{if(NR>1) print $0}' | while read line; do
    echo "RUN ${line}"
done

