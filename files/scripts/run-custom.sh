#!/usr/bin/env bash

set -e

source /secrets.sh

ENVIRONMENT=${ENVIRONMENT:-custom}

if [[ $# -lt 1 ]]; then
    echo usage: osism-$ENVIRONMENT SERVICE [...]
    exit 1
fi

service=$1
shift

ANSIBLE_DIRECTORY=/ansible
CONFIGURATION_DIRECTORY=/opt/configuration
ENVIRONMENTS_DIRECTORY=$CONFIGURATION_DIRECTORY/environments
VAULT=${VAULT:-$ENVIRONMENTS_DIRECTORY/.vault_pass}

if [[ -e /ansible/ara.env ]]; then
    source /ansible/ara.env
fi

export ANSIBLE_INVENTORY=$ANSIBLE_DIRECTORY/inventory/hosts.yml

export ANSIBLE_CONFIG=$ENVIRONMENTS_DIRECTORY/ansible.cfg
if [[ -e $ANSIBLE_DIRECTORY/inventory/ansible/ansible.cfg ]]; then
    export ANSIBLE_CONFIG=$ANSIBLE_DIRECTORY/inventory/ansible/ansible.cfg
elif [[ -e $ENVIRONMENTS_DIRECTORY/$ENVIRONMENT/ansible.cfg ]]; then
    export ANSIBLE_CONFIG=$ENVIRONMENTS_DIRECTORY/$ENVIRONMENT/ansible.cfg
fi

if [[ ! -e $ENVIRONMENTS_DIRECTORY/$ENVIRONMENT ]]; then
    echo "ERROR: environment $ENVIRONMENT not available"
    exit 1
fi

if [[ -e $ENVIRONMENTS_DIRECTORY/.lock ]]; then
    echo "ERROR: The configuration repository is locked."
    exit 1
fi

if [[ -e $ENVIRONMENTS_DIRECTORY/$ENVIRONMENT/.lock ]]; then
    echo "ERROR: The environment $ENVIRONMENT is locked via the configuration repository."
    exit 1
fi

cd $ENVIRONMENTS_DIRECTORY/$ENVIRONMENT

ansible-playbook \
  --vault-password-file $VAULT \
  -e @$ENVIRONMENTS_DIRECTORY/configuration.yml \
  -e @$ENVIRONMENTS_DIRECTORY/secrets.yml \
  -e @secrets.yml \
  -e @images.yml \
  -e @configuration.yml \
  "$@" \
  playbook-$service.yml
