#!/usr/bin/env bash

ENVIRONMENT=${ENVIRONMENT:-netbox}

if [[ $# -lt 1 ]]; then
    echo usage: osism-$ENVIRONMENT PLAYBOOK [...]
    exit 1
fi

playbook=$1
shift

ANSIBLE_DIRECTORY=/ansible
CONFIGURATION_DIRECTORY=/opt/configuration
ENVIRONMENTS_DIRECTORY=$CONFIGURATION_DIRECTORY/environments
NETBOX_TOKEN=$(< /run/secrets/NETBOX_TOKEN)

if [[ -e /ansible/ara.env ]]; then
    source /ansible/ara.env
fi

export ANSIBLE_INVENTORY=$CONFIGURATION_DIRECTORY/$ENVIRONMENT/inventory
export ANSIBLE_CONFIG=$ENVIRONMENTS_DIRECTORY/ansible.cfg
if [[ -e $CONFIGURATION_DIRECTORY/$ENVIRONMENT/ansible.cfg ]]; then
    export ANSIBLE_CONFIG=$CONFIGURATION_DIRECTORY/$ENVIRONMENT/ansible.cfg
fi

cd $CONFIGURATION_DIRECTORY/$ENVIRONMENT

ansible-playbook \
  -e netbox_token=$NETBOX_TOKEN \
  -e netbox_url=$NETBOX_API \
  "$@" \
  $CONFIGURATION_DIRECTORY/$ENVIRONMENT/playbooks/$playbook.yml
