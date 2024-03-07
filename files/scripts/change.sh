#!/usr/bin/env bash

if [[ ! -e /usr/bin/git ]]; then
  apt-get update \
    && apt-get install --no-install-recommends -y git
fi

if [[ "$1" == "osism" ]]; then
    rm -rf /python-osism
    git clone --depth 1 -b $2 https://github.com/osism/python-osism /python-osism

    pushd /python-osism
    pip3 uninstall -y osism
    python3 -m pip --no-cache-dir install -U /python-osism
    popd
elif [[ "$1" == "playbooks" ]]; then
    rm -rf /playbooks
    git clone --depth 1 -b $2 https://github.com/osism/ansible-playbooks /playbooks

    cp -r /playbooks/playbooks/* /ansible

    python3 /src/render-playbooks.py
    cp /ansible/playbooks.yml /interface/playbooks/osism-ansible.yml
else
    rm -rf /ansible/collections/ansible_collections/osism/$1
    git clone --depth 1 -b $2 https://github.com/osism/ansible-collection-$1 /ansible/collections/ansible_collections/osism/$1
fi
