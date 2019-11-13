#!/usr/bin/env bash
set -x

# Available environment variables
#
# BUILD_OPTS
# REPOSITORY
# VERSION

# Set default values

BUILD_OPTS=${BUILD_OPTS:-}
HASH_REPOSITORY=$(git rev-parse --short HEAD)
VERSION=${VERSION:-latest}

if [[ -n $TRAVIS_TAG ]]; then
    VERSION=${TRAVIS_TAG:1}
fi

docker build \
    --build-arg "VERSION=$VERSION" \
    --label "io.osism.${REPOSITORY#osism/}=$HASH_REPOSITORY" \
    --tag "$REPOSITORY:$VERSION" \
    --squash \
    $BUILD_OPTS .
