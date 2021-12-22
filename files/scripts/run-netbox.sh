#!/usr/bin/env bash

ENVIRONMENT=netbox

if [[ $# -lt 1 ]]; then
    echo usage: osism-$ENVIRONMENT PLAYBOOK [...]
    exit 1
fi

playbook=$1
shift

ANSIBLE_DIRECTORY=/ansible
CONFIGURATION_DIRECTORY=/opt/configuration

if [[ -e /ansible/ara.env ]]; then
    source /ansible/ara.env
fi

cd $CONFIGURATION_DIRECTORY/$ENVIRONMENT

ansible-playbook \
  -i localhost, \
  "$@" \
  $CONFIGURATION_DIRECTORY/$ENVIRONMENT/playbook-$playbook.yml
