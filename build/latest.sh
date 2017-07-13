#!/bin/bash

if [ ! -z "$DOCKER_PASSWORD" ] && [ ! -z "$TRAVIS_TAG" ]; then
    docker login -u="$DOCKER_USERNAME" -p="$DOCKER_PASSWORD" &&
    docker build -t kontena/kosh:latest . &&
    docker tag kontena/kosh:latest kontena/kosh:latest &&
    docker push kontena/kosh:latest;
fi