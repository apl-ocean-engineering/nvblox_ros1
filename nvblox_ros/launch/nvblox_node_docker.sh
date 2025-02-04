#!/bin/bash

# Run nvblox in a Docker image
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
../../../src:/root/nvblox_ws/src
docker run --rm -it \
    --gpus all \
    --network host \
    -v $SCRIPT_DIR/../src:/root/nvblox_ws/src \
    registry.gitlab.com/apl-ocean-engineering/raven/manipulation/mapping/nvblox:node
