#!/usr/bin/env bash

mkdir -p /interface/osism-ansible
rsync -am --exclude='requirements*.yml' --include='*.yml' --exclude='*' /ansible/ /interface/osism-ansible/
exec /usr/bin/dumb-init -- "$@"
