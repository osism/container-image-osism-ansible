FROM python:3.12-slim-bookworm as builder

ARG VERSION=latest

ARG USER_ID=45000
ARG GROUP_ID=45000
ARG GROUP_ID_DOCKER=999

ENV DEBIAN_FRONTEND=noninteractive

USER root

COPY --link files/library /ansible/library
COPY --link files/roles /ansible/roles
COPY --link files/tasks /ansible/tasks
COPY --link files/plugins /usr/share/ansible/plugins

COPY --link files/playbooks/* /ansible/
COPY --link files/scripts/* /

COPY --link files/ansible.cfg /etc/ansible/ansible.cfg
COPY --link files/ara.env /ansible/ara.env

COPY --link files/src /src
COPY --link patches /patches

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN <<EOF
set -e
set -x

# show motd
echo "[ ! -z \"\$TERM\" -a -r /etc/motd ] && cat /etc/motd" >> /etc/bash.bashrc

# install required packages
apt-get update
apt-get install --no-install-recommends -y \
  build-essential \
  curl \
  dumb-init \
  git \
  gnupg \
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
python3 -m pip install --no-cache-dir --upgrade 'pip==24.0'
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
cp /generics/inventory/* /ansible/inventory.generics

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

# install helm
curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | tee /usr/share/keyrings/helm.gpg > /dev/null
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | tee /etc/apt/sources.list.d/helm-stable-debian.list
apt-get update
apt-get install --no-install-recommends -y \
  helm

# add helm chart repositories
python3 /src/add-helm-chart-repositories.py

# prepare .kube directory
mkdir -p /ansible/.kube
ln -s /share/kubeconfig /ansible/.kube/config
chown -R dragon: /ansible/.kube

mkdir -p /ansible/.cache
mv /root/.cache/helm /ansible/.cache
chown -R dragon: /ansible/.cache

mkdir -p /ansible/.config
mv /root/.config/helm /ansible/.config
chown -R dragon: /ansible/.config

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
  curl \
  git \
  gnupg \
  libffi-dev \
  libssh-dev \
  libssl-dev \
  libyaml-dev
apt-get autoremove -y

rm -rf \
  /patches \
  /root/.cache \
  /tmp/* \
  /usr/share/doc/* \
  /usr/share/man/* \
  /var/lib/apt/lists/* \
  /var/tmp/*

pip3 install --no-cache-dir pyclean==2.7.6
pyclean /usr
pip3 uninstall -y pyclean
EOF

USER dragon

FROM python:3.12-slim-bookworm

COPY --link --from=builder / /

VOLUME ["/ansible/secrets", "/ansible/logs", "/ansible/cache", "/share", "/archive", "/interface"]
USER dragon
WORKDIR /ansible
ENTRYPOINT ["/entrypoint.sh"]
