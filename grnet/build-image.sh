#!/bin/bash

set -xe

IMAGE_NAME="grnet/mdq-server:latest"

docker build --no-cache=true -t ${IMAGE_NAME} .
