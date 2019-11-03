#!/usr/bin/env bash

ENVIRONMENT=test
TYPE=osism-ansible

environment=generic

ANSIBLE_DIRECTORY=/ansible
CONFIGURATION_DIRECTORY=/opt/configuration
ENVIRONMENTS_DIRECTORY=$CONFIGURATION_DIRECTORY/environments

if [[ -e /ansible/ara.env ]]; then
    source /ansible/ara.env
fi

export ANSIBLE_CONFIG=$ENVIRONMENTS_DIRECTORY/ansible.cfg
if [[ -e $ENVIRONMENTS_DIRECTORY/$environment/ansible.cfg ]]; then
    export ANSIBLE_CONFIG=$ENVIRONMENTS_DIRECTORY/$environment/ansible.cfg
fi

cd $ENVIRONMENTS_DIRECTORY/$environment
testinfra -v --connection=ansible \
    /tests/ansible/osism-ansible \
    "$@"
