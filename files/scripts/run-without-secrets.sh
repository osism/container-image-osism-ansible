#!/usr/bin/env bash

set -e

ENVIRONMENT=${ENVIRONMENT:-run}

if [[ $# -lt 2 ]]; then
    echo usage: osism-$ENVIRONMENT ENVIRONMENT SERVICE [...]
    exit 1
fi

environment=$1
shift

service=$1
shift

ANSIBLE_DIRECTORY=/ansible
CONFIGURATION_DIRECTORY=/opt/configuration
ENVIRONMENTS_DIRECTORY=$CONFIGURATION_DIRECTORY/environments

if [[ -e /ansible/ara.env ]]; then
    source /ansible/ara.env
fi

export ANSIBLE_INVENTORY=$ANSIBLE_DIRECTORY/inventory/hosts.yml

export ANSIBLE_CONFIG=$ENVIRONMENTS_DIRECTORY/ansible.cfg
if [[ -e $ANSIBLE_DIRECTORY/inventory/ansible/ansible.cfg ]]; then
    export ANSIBLE_CONFIG=$ANSIBLE_DIRECTORY/inventory/ansible/ansible.cfg
elif [[ -e $ENVIRONMENTS_DIRECTORY/$environment/ansible.cfg ]]; then
    export ANSIBLE_CONFIG=$ENVIRONMENTS_DIRECTORY/$environment/ansible.cfg
fi

if [[ ! -e $ENVIRONMENTS_DIRECTORY/$environment ]]; then
    echo "ERROR: environment $environment not available"
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

cd $ENVIRONMENTS_DIRECTORY/$environment

if [[ -e playbook-$service.yml ]]; then

    ansible-playbook \
      -e @$ENVIRONMENTS_DIRECTORY/configuration.yml \
      -e @images.yml \
      -e @configuration.yml \
      "$@" \
      playbook-$service.yml

elif [[ -e $ANSIBLE_DIRECTORY/$environment/$service.yml ]]; then

    ansible-playbook \
      -e @$ENVIRONMENTS_DIRECTORY/configuration.yml \
      -e @images.yml \
      -e @configuration.yml \
      "$@" \
      $ANSIBLE_DIRECTORY/$environment/$service.yml

else

    echo "ERROR! the playbook: playbook-$service.yml could not be found"
    exit 1

fi
