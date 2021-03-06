#!/bin/bash

set -e

# Need to log in to Docker desktop before docker push will succeed.
# e.g. `docker login`
# Log in account should be 'algorand'.

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
cd ${SCRIPTPATH}

docker build -f Dockerfile-stable . -t algorand/stable:latest
docker push algorand/stable:latest
