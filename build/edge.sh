#!/bin/bash

if [ ! -z "$DOCKER_USERNAME" ] && [ ! -z "$DOCKER_PASSWORD" ]; then
    docker login -u="$DOCKER_USERNAME" -p="$DOCKER_PASSWORD"

    docker build -t kontena/kosh:edge .
    docker build --build-arg CLI_VERSION=1.2.0 -t kontena/kosh:edge-cli-1.2 .
    docker build --build-arg CLI_VERSION=1.3.0 -t kontena/kosh:edge-cli-1.3 .
    docker build --build-arg CLI_VERSION=1.4.0 -t kontena/kosh:edge-cli-1.4 .

    docker push kontena/kosh:edge
    docker push kontena/kosh:edge-cli-1.2
    docker push kontena/kosh:edge-cli-1.3
    docker push kontena/kosh:edge-cli-1.4
fi
