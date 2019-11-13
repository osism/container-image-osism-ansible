#!/usr/bin/env bash
set -x

# Available environment variables
#
# REPOSITORY
# VERSION

# Set default values

VERSION=${VERSION:-latest}

if [[ -n $TRAVIS_TAG ]]; then
    VERSION=${TRAVIS_TAG:1}
fi

docker push "$REPOSITORY:$VERSION"
docker rmi "$REPOSITORY:$VERSION"
