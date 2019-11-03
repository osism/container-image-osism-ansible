#!/usr/bin/env bash

ENVIRONMENT=ansible

if [[ $# -lt 1 ]]; then
    echo usage: osism-$ENVIRONMENT ENVIRONMENT [...]
    exit 1
fi

environment=$1
shift

ANSIBLE_DIRECTORY=/ansible
CONFIGURATION_DIRECTORY=/opt/configuration
ENVIRONMENTS_DIRECTORY=$CONFIGURATION_DIRECTORY/environments
VAULT=${VAULT:-$ENVIRONMENTS_DIRECTORY/.vault_pass}

if [[ -e /ansible/ara.env ]]; then
    source /ansible/ara.env
fi

export ANSIBLE_CONFIG=$ENVIRONMENTS_DIRECTORY/ansible.cfg
if [[ -e $ENVIRONMENTS_DIRECTORY/$environment/ansible.cfg ]]; then
    export ANSIBLE_CONFIG=$ENVIRONMENTS_DIRECTORY/$environment/ansible.cfg
fi

cd $ENVIRONMENTS_DIRECTORY/$environment

ansible \
  --vault-password-file $VAULT \
  -e @$ENVIRONMENTS_DIRECTORY/configuration.yml \
  -e @$ENVIRONMENTS_DIRECTORY/secrets.yml \
  -e @secrets.yml \
  -e @images.yml \
  -e @configuration.yml \
  "$@"
