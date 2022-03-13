#!/usr/bin/env bash

if [[ ! -e /usr/bin/git ]]; then
  apt-get update \
    && apt-get install --no-install-recommends -y git
fi

rm -rf /ansible/collections/ansible_collections/osism/$1
git clone --depth 1 -b $2 https://github.com/osism/ansible-collection-$1 /ansible/collections/ansible_collections/osism/$1
