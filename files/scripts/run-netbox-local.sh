#!/usr/bin/env bash

set -e

ENVIRONMENT=${ENVIRONMENT:-netbox}

if [[ $# -lt 1 ]]; then
    echo usage: osism-$ENVIRONMENT PLAYBOOK [...]
    exit 1
fi

playbook=$1
shift

ANSIBLE_DIRECTORY=/ansible
CONFIGURATION_DIRECTORY=/opt/configuration
NETBOX_TOKEN=$(< /run/secrets/NETBOX_TOKEN)

if [[ -e /ansible/ara.env ]]; then
    source /ansible/ara.env
fi

if [[ ! -e $CONFIGURATION_DIRECTORY/$ENVIRONMENT ]]; then
    echo "ERROR: environment $ENVIRONMENT not available"
    exit 1
fi

if [[ -e $CONFIGURATION_DIRECTORY/$ENVIRONMENT/.lock ]]; then
    echo "ERROR: The environment $ENVIRONMENT is locked via the configuration repository."
    exit 1
fi

cd $CONFIGURATION_DIRECTORY/$ENVIRONMENT

ansible-playbook \
  -i localhost, \
  -e netbox_token=$NETBOX_TOKEN \
  -e netbox_url=$NETBOX_API \
  "$@" \
  $CONFIGURATION_DIRECTORY/$ENVIRONMENT/playbooks/$playbook.yml
