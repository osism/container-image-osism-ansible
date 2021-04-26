#!/usr/bin/env bash

ENVIRONMENT=run

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

if [[ ! -e /run/secrets/NETBOX_TOKEN ]]; then
    rm -f /ansible/inventory/99-netbox.yml
fi

export ANSIBLE_CONFIG=$ENVIRONMENTS_DIRECTORY/ansible.cfg
if [[ -e $ENVIRONMENTS_DIRECTORY/$environment/ansible.cfg ]]; then
    export ANSIBLE_CONFIG=$ENVIRONMENTS_DIRECTORY/$environment/ansible.cfg
fi

export ANSIBLE_INVENTORY=$ANSIBLE_DIRECTORY/inventory

if [[ -w $ANSIBLE_INVENTORY ]]; then
    rsync -a /ansible/group_vars/ /ansible/inventory/group_vars/
    rsync -a /ansible/inventory.generics/ /ansible/inventory/
    rsync -a /opt/configuration/inventory/ /ansible/inventory/
    python3 /src/handle-inventory-overwrite.py
    cat /ansible/inventory/[0-9]* > /ansible/inventory/hosts
    rm /ansible/inventory/[0-9]*
fi

cd $ENVIRONMENTS_DIRECTORY/$environment

if [[ -e playbook-$service.yml ]]; then

    ansible-playbook \
      -e @$ENVIRONMENTS_DIRECTORY/configuration.yml \
      -e @images.yml \
      -e @configuration.yml \
      "$@" \
      playbook-$service.yml

elif [[ -e $ANSIBLE_DIRECTORY/$environment-$service.yml ]]; then

    ansible-playbook \
      -e @$ENVIRONMENTS_DIRECTORY/configuration.yml \
      -e @images.yml \
      -e @configuration.yml \
      "$@" \
      $ANSIBLE_DIRECTORY/$environment-$service.yml

else

    echo "ERROR! the playbook: playbook-$service.yml could not be found"
    exit 1

fi
