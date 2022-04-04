#!/usr/bin/env bash
set -x

# Available environment variables
#
# BUILD_OPTS
# DOCKER_REGISTRY
# IS_RELEASE
# REPOSITORY
# VERSION

# Set default values

BUILD_OPTS=${BUILD_OPTS:-}
CREATED=$(date --rfc-3339=ns)
DOCKER_REGISTRY=${DOCKER_REGISTRY:-quay.io}
REVISION=$(git rev-parse HEAD)
VERSION=${VERSION:-latest}
IS_RELEASE=${IS_RELEASE:-false}

if [[ -n $DOCKER_REGISTRY ]]; then
    REPOSITORY="$DOCKER_REGISTRY/$REPOSITORY"
fi

buildah build-using-dockerfile \
    --format docker \
    --squash \
    --build-arg "VERSION=$VERSION" \
    --build-arg "IS_RELEASE=$IS_RELEASE" \
    --tag "$(git rev-parse --short HEAD)" \
    --label "org.opencontainers.image.created=$CREATED" \
    --label "org.opencontainers.image.documentation=https://docs.osism.tech" \
    --label "org.opencontainers.image.licenses=ASL 2.0" \
    --label "org.opencontainers.image.revision=$REVISION" \
    --label "org.opencontainers.image.source=https://github.com/osism/container-image-osism-ansible" \
    --label "org.opencontainers.image.title=osism-ansible" \
    --label "org.opencontainers.image.url=https://www.osism.tech" \
    --label "org.opencontainers.image.vendor=OSISM GmbH" \
    --label "org.opencontainers.image.version=$VERSION" \
    $BUILD_OPTS .
