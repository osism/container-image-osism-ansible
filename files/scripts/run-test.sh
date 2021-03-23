#!/usr/bin/env bash

source /secrets.sh

ENVIRONMENT=test
TYPE=osism-ansible

environment=generic

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
rsync -a /ansible/group_vars/ /ansible/inventory/group_vars/
rsync -a /opt/configuration/inventory/ /ansible/inventory/
python3 /src/handle-inventory-overwrite.py
cat /ansible/inventory/[0-9]* > /ansible/inventory/hosts
rm /ansible/inventory/[0-9]*

cd $ENVIRONMENTS_DIRECTORY/$environment
testinfra -v --connection=ansible \
    /tests/ansible/osism-ansible \
    "$@"
