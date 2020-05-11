#!/bin/bash
set -e

# check args
if [ "$1" == "" ]; then
    echo "error no image tag"
    exit 1
fi

# autodetect container runtime
container_runtime="docker"
if ! command -v $container_runtime > /dev/null; then
    container_runtime="podman"
fi
if ! command -v $container_runtime > /dev/null; then
    echo "error: no container runtime found"
    exit 1
fi

# make container run command
runcommand="deep-start -do"
if [ "$2" != "" ]; then
    runcommand="$2"
fi

# get onedata access token
onedata_access_token=$(cat $HOME/.onedata_token)

# run container
$container_runtime run --privileged -it --rm \
    -p 5000:5000 \
    -p 6006:6006 \
    -p 8888:8888 \
    --env ONECLIENT_ACCESS_TOKEN="$onedata_access_token" \
    --env ONECLIENT_PROVIDER_HOST="oprov.ifca.es" \
    --env ONEDATA_MOUNT_POINT="/mnt/onedata" \
    --env APP_INPUT_OUTPUT_BASE_DIR="/mnt/onedata/conex-generator" \
    "$1" \
    $runcommand

