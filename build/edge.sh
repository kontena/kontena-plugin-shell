#!/bin/bash

if [ ! -z "$DOCKER_USERNAME" ] && [ ! -z "$DOCKER_PASSWORD" ]; then
    docker login -u="$DOCKER_USERNAME" -p="$DOCKER_PASSWORD"
    docker build -t kontena/kosh:edge .
    docker push kontena/kosh:edge
fi