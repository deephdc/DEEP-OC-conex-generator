#!/bin/bash
set -e

# check args
if [ "$1" == "" ]; then
    echo "error no image tag"
    exit 1
fi

# get git branch
BRANCH=$(git rev-parse --abbrev-ref HEAD)

# autodetect container runtime
container_runtime="docker"
if ! command -v $container_runtime > /dev/null; then
    container_runtime="podman"
fi
if ! command -v $container_runtime > /dev/null; then
    echo "error: no container runtime found"
    exit 1
fi

# build image
$container_runtime build -t "$1" --build-arg branch="$BRANCH" .

