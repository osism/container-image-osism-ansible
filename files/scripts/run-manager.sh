#!/usr/bin/env bash

source /secrets.sh

ENVIRONMENT=manager

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

if [[ ! -e /run/secrets/NETBOX_TOKEN ]]; then
    rm -f /ansible/inventory/99-netbox.yml
fi

export ANSIBLE_CONFIG=$ENVIRONMENTS_DIRECTORY/ansible.cfg
if [[ -e $ENVIRONMENTS_DIRECTORY/$ENVIRONMENT/ansible.cfg ]]; then
    export ANSIBLE_CONFIG=$ENVIRONMENTS_DIRECTORY/$ENVIRONMENT/ansible.cfg
fi

export ANSIBLE_INVENTORY=$ANSIBLE_DIRECTORY/inventory
rsync -a /ansible/group_vars/ /ansible/inventory/group_vars/
rsync -a /opt/configuration/inventory/ /ansible/inventory/
python3 /src/handle-inventory-overwrite.py

cd $ENVIRONMENTS_DIRECTORY/$ENVIRONMENT

ansible-playbook \
  --vault-password-file $VAULT \
  -e @$ENVIRONMENTS_DIRECTORY/configuration.yml \
  -e @$ENVIRONMENTS_DIRECTORY/secrets.yml \
  -e @secrets.yml \
  -e @images.yml \
  -e @configuration.yml \
  "$@" \
  $ANSIBLE_DIRECTORY/$ENVIRONMENT-$service.yml
