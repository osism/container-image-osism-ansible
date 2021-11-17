#!/usr/bin/env bash

mkdir -p /interface/osism-ansible /interface/versions
rsync -am --exclude='requirements*.yml' --include='*.yml' --exclude='*' /ansible/ /interface/osism-ansible/
cp /ansible/group_vars/all/versions.yml /interface/versions/osism-ansible.yml

exec /usr/bin/dumb-init -- "$@"
