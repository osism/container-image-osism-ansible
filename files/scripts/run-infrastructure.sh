#!/usr/bin/env bash

source /secrets.sh

ENVIRONMENT=infrastructure

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

export ANSIBLE_INVENTORY=$ANSIBLE_DIRECTORY/inventory

export ANSIBLE_CONFIG=$ENVIRONMENTS_DIRECTORY/ansible.cfg
if [[ -e $ENVIRONMENTS_DIRECTORY/$ENVIRONMENT/ansible.cfg ]]; then
    export ANSIBLE_CONFIG=$ENVIRONMENTS_DIRECTORY/$ENVIRONMENT/ansible.cfg
fi

cd $ENVIRONMENTS_DIRECTORY/$ENVIRONMENT

if [[ -e $ENVIRONMENTS_DIRECTORY/$ENVIRONMENT/playbook-$service.yml ]]; then
    ansible-playbook \
      --vault-password-file $VAULT \
      -e @$ENVIRONMENTS_DIRECTORY/configuration.yml \
      -e @$ENVIRONMENTS_DIRECTORY/secrets.yml \
      -e @$ENVIRONMENTS_DIRECTORY/monitoring/configuration.yml \
      -e @$ENVIRONMENTS_DIRECTORY/monitoring/secrets.yml \
      -e @secrets.yml \
      -e @images.yml \
      -e @configuration.yml \
      "$@" \
      playbook-$service.yml
elif [[ -e $ANSIBLE_DIRECTORY/$ENVIRONMENT-$service.yml ]]; then
    ansible-playbook \
      --vault-password-file $VAULT \
      -e @$ENVIRONMENTS_DIRECTORY/configuration.yml \
      -e @$ENVIRONMENTS_DIRECTORY/secrets.yml \
      -e @$ENVIRONMENTS_DIRECTORY/monitoring/configuration.yml \
      -e @$ENVIRONMENTS_DIRECTORY/monitoring/secrets.yml \
      -e @secrets.yml \
      -e @images.yml \
      -e @configuration.yml \
      "$@" \
      $ANSIBLE_DIRECTORY/$ENVIRONMENT-$service.yml
else
    echo "ERROR: service $service in environment $ENVIRONMENT not available"
    exit 1
fi
