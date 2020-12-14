#!/usr/bin/env bash
set -x

# Available environment variables
#
# BUILD_OPTS
# DOCKER_REGISTRY
# REPOSITORY
# VERSION

# Set default values

BUILD_OPTS=${BUILD_OPTS:-}
CREATED=$(date --rfc-3339=ns)
DOCKER_REGISTRY=${DOCKER_REGISTRY:-quay.io}
REVISION=$(git rev-parse --short HEAD)
VERSION=${VERSION:-latest}

if [[ -n $DOCKER_REGISTRY ]]; then
    REPOSITORY="$DOCKER_REGISTRY/$REPOSITORY"
fi

docker buildx build \
    --build-arg "VERSION=$VERSION" \
    --tag "$REPOSITORY:$VERSION" \
    --label "org.opencontainers.image.created=$CREATED" \
    --label "org.opencontainers.image.documentation=https://docs.osism.de" \
    --label "org.opencontainers.image.licenses=ASL 2.0" \
    --label "org.opencontainers.image.revision=$REVISION" \
    --label "org.opencontainers.image.source=https://github.com/osism/docker-image-osism-ansible" \
    --label "org.opencontainers.image.title=osism-ansible" \
    --label "org.opencontainers.image.url=https://www.osism.de" \
    --label "org.opencontainers.image.vendor=Betacloud Solutions GmbH" \
    --label "org.opencontainers.image.version=$VERSION" \
    $BUILD_OPTS .
