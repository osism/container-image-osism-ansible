FROM python:3.11-slim

ARG VERSION=latest

ARG USER_ID=45000
ARG GROUP_ID=45000
ARG GROUP_ID_DOCKER=999

ENV DEBIAN_FRONTEND=noninteractive

USER root

COPY files/library /ansible/library
COPY files/roles /ansible/roles
COPY files/tasks /ansible/tasks
COPY files/plugins /usr/share/ansible/plugins

COPY files/playbooks/* /ansible/
COPY files/scripts/* /

COPY files/ansible.cfg /etc/ansible/ansible.cfg
COPY files/ara.env /ansible/ara.env

COPY files/src /src
COPY patches /patches

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# hadolint ignore=DL3003
RUN <<EOF
set -e
set -x

# show motd
echo "[ ! -z \"\$TERM\" -a -r /etc/motd ] && cat /etc/motd" >> /etc/bash.bashrc

# install required packages
apt-get update
apt-get install --no-install-recommends -y \
  build-essential \
  dumb-init \
  git \
  git-lfs \
  gnupg-agent \
  iputils-ping \
  jq \
  libffi-dev \
  libssh-dev \
  libssl-dev \
  libyaml-dev \
  openssh-client \
  procps \
  rsync \
  sshpass
update-alternatives --install /usr/bin/python3 python3 /usr/local/bin/python3 1
update-alternatives --install /usr/bin/python python /usr/local/bin/python 1
python3 -m pip install --no-cache-dir --upgrade 'pip==23.3.1'
pip3 install --no-cache-dir -r /src/requirements.txt

# add user
groupadd -g "$GROUP_ID" dragon
groupadd -g "$GROUP_ID_DOCKER" docker
useradd -l -g dragon -G docker -u "$USER_ID" -m -d /ansible dragon

# prepare release repository
git clone https://github.com/osism/release /release

# prepare project repository

git clone https://github.com/osism/ansible-playbooks /playbooks
( cd /playbooks || exit; git fetch --all --force; git checkout "$(yq -M -r .playbooks_version "/release/$VERSION/base.yml")" )

git clone https://github.com/osism/defaults /defaults
( cd /defaults || exit; git fetch --all --force; git checkout "$(yq -M -r .defaults_version "/release/$VERSION/base.yml")" )

git clone https://github.com/osism/cfg-generics /generics 
( cd /generics || exit; git fetch --all --force; git checkout "$(yq -M -r .generics_version "/release/$VERSION/base.yml")" )

# add inventory files
mkdir -p /ansible/inventory.generics /ansible/inventory
cp /generics/inventory/50-ceph /ansible/inventory.generics/50-ceph
cp /generics/inventory/50-infrastruture /ansible/inventory.generics/50-infrastruture
cp /generics/inventory/50-kolla /ansible/inventory.generics/50-kolla
cp /generics/inventory/50-monitoring /ansible/inventory.generics/50-monitoring
cp /generics/inventory/50-openstack /ansible/inventory.generics/50-openstack
cp /generics/inventory/51-ceph /ansible/inventory.generics/51-ceph
cp /generics/inventory/51-kolla /ansible/inventory.generics/51-kolla
cp /generics/inventory/60-generic /ansible/inventory.generics/60-generic

# run preparations
mkdir -p /ansible/group_vars
cp -r /defaults/* /ansible/group_vars/
rm -f /ansible/group_vars/LICENSE /ansible/group_vars/README.md

python3 /src/render-python-requirements.py
python3 /src/render-versions.py
python3 /src/render-ansible-requirements.py
ROLES_FILENAME=/release/etc/roles-manager.yml REQUIREMENTS_FILENAME=/ansible/requirements-manager.yml python3 /src/render-ansible-requirements.py
python3 /src/render-docker-images.py


# install required python packages
pip3 install --no-cache-dir -r /requirements.txt

# set ansible version in the motd
ansible_version=$(python3 -c 'import ansible; print(ansible.release.__version__)')
sed -i -e "s/ANSIBLE_VERSION/$ansible_version/" /etc/motd

# create required directories
mkdir -p \
  /ansible \
  /ansible/action_plugins \
  /ansible/cache \
  /ansible/logs \
  /ansible/secrets \
  /share \
  /archive \
  /interface

# install required ansible collections & roles
ansible-galaxy role install -v -f -r /ansible/requirements.yml -p /usr/share/ansible/roles
ansible-galaxy collection install -v -f -r /ansible/requirements.yml -p /usr/share/ansible/collections

ln -s /usr/share/ansible/roles /ansible/galaxy
ln -s /usr/share/ansible/collections /ansible/collections
ln -s /usr/share/ansible/plugins /ansible/plugins

# project specific instructions

# add k3s-ansible roles
git clone https://github.com/techno-tim/k3s-ansible /k3s-ansible
mkdir -p /ansible/roles
mv /k3s-ansible/roles/{k3s_server,k3s_agent,k3s_server_post} /ansible/roles
mv /k3s-ansible/roles/download /ansible/roles/k3s_download
mv /k3s-ansible/roles/prereq /ansible/roles/k3s_prereq
mv /k3s-ansible/roles/reset /ansible/roles/k3s_reset
rm -rf /k3s-ansible

# hadolint ignore=DL3003
for role in /usr/share/ansible/roles/*; do
  if [ -e /patches/"$(basename "$role")" ]; then
    for patchfile in /patches/"$(basename "$role")"/*.patch; do
      echo "$patchfile";
      ( cd /usr/share/ansible/roles/"$(basename "$role")" && patch --forward --batch -p1 --dry-run ) < "$patchfile" || exit 1;
      ( cd /usr/share/ansible/roles/"$(basename "$role")" && patch --forward --batch -p1 ) < "$patchfile";
    done;
  fi;
done

cp -r /playbooks/playbooks/* /ansible
cp /playbooks/library/* /ansible/library
mkdir -p /ansible/templates
cp /playbooks/templates/* /ansible/templates

# add symlink to /etc/openstack
ln -s /opt/configuration/environments/openstack /etc/openstack

# always enable the json_stats calback plugin
ln -s /ansible/plugins/callback/json_stats.py /usr/local/lib/python3.11/site-packages/ansible/plugins/callback

# copy ara configuration
python3 -m ara.setup.env >> /ansible/ara.env

# prepare list of playbooks
python3 /src/render-playbooks.py

# set correct permssions
chown -R dragon: /ansible /share /archive /interface

# cleanup
apt-get clean
apt-get remove -y  \
  build-essential \
  git \
  libffi-dev \
  libssh-dev \
  libssl-dev \
  libyaml-dev
apt-get autoremove -y

rm -rf \
  /patches \
  /release \
  /root/.cache \
  /tmp/* \
  /usr/share/doc/* \
  /usr/share/man/* \
  /var/lib/apt/lists/* \
  /var/tmp/*

EOF

VOLUME ["/ansible/secrets", "/ansible/logs", "/ansible/cache", "/share", "/archive", "/interface"]

USER dragon
WORKDIR /ansible

ENTRYPOINT ["/entrypoint.sh"]
