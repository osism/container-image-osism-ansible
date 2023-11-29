#!/usr/bin/env bash

if [[ ! -e /usr/bin/git ]]; then
  apt-get update \
    && apt-get install --no-install-recommends -y git
fi

rm -rf /playbooks
git clone --depth 1 -b $1 https://github.com/osism/ansible-playbooks /playbooks

python3 /src/render-playbooks.py
cp /ansible/playbooks.yml /interface/playbooks/osism-ansible.yml
