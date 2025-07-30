#!/bin/bash
set -e

IMAGE="$DOCKER_REGISTRY_URL/$DOCKER_REGISTRY_USERNAME/simple-python-flask-app:latest"
CONTAINER_NAME="flask-app"

docker pull "$IMAGE"
docker run -d --name "$CONTAINER_NAME" -p 5000:5000 "$IMAGE"
