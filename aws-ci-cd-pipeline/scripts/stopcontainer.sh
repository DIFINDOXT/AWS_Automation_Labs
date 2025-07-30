#!/bin/bash
set -e

CONTAINER_NAME="flask-app"

if docker ps -q -f name="$CONTAINER_NAME"; then
    docker stop "$CONTAINER_NAME"
    docker rm "$CONTAINER_NAME"
fi
