#!/usr/bin/env bash

mkdir -p /interface/versions /interface/playbooks
cp /ansible/group_vars/all/versions.yml /interface/versions/osism-ansible.yml
cp /ansible/playbooks.yml /interface/playbooks/osism-ansible.yml

exec /usr/bin/dumb-init -- "$@"
