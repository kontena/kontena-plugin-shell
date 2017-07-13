#!/bin/bash

if [ ! -z "$DOCKER_PASSWORD" ] && [ ! -z "$TRAVIS_TAG" ]; then
    docker login -u="$DOCKER_USERNAME" -p="$DOCKER_PASSWORD"

    docker build -t kontena/kosh:latest .
    docker build --build-arg CLI_VERSION=1.2 -t kontena/kosh:${TRAVIS_TAG}-cli-1.2 .
    docker build --build-arg CLI_VERSION=1.3 -t kontena/kosh:${TRAVIS_TAG}-cli-1.3 .

    docker push kontena/kosh:latest
    docker push kontena/kosh:${TRAVIS_TAG}-cli-1.2
    docker push kontena/kosh:${TRAVIS_TAG}-cli-1.3
fi