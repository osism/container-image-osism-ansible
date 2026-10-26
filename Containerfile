ARG BASE_IMAGE=registry.osism.tech/dockerhub/python
ARG BASE_TAG=3.13-slim-bookworm
FROM ${BASE_IMAGE}:${BASE_TAG} AS builder

ARG VERSION=latest
ARG SHA_ANSIBLE_PLAYBOOKS
ARG SHA_GENERICS
ARG SHA_RELEASE

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

ADD https://github.com/mitogen-hq/mitogen/archive/refs/tags/v0.3.39.tar.gz /mitogen.tar.gz
COPY --from=ghcr.io/astral-sh/uv:0.11.22 /uv /usr/local/bin/uv

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

# add user
groupadd -g "$GROUP_ID" dragon
groupadd -g "$GROUP_ID_DOCKER" docker
useradd -l -g dragon -G docker -u "$USER_ID" -m -d /ansible dragon

# prepare release repository
git clone https://github.com/osism/release /release
if [ "$VERSION" != "latest" ]; then
  ( cd /release || exit; git fetch --all --force; git checkout "osism-ansible-$VERSION" )
fi

# pin the source to the commit recorded in the labels
if [ -n "$SHA_RELEASE" ]; then ( cd /release || exit; git checkout "$SHA_RELEASE" ); fi

# install required python packages
# NOTE: All packages are installed by a single resolver run, so a
#       requirement that conflicts with another fails the build instead
#       of being replaced by a later install. Rendering /requirements.txt
#       needs Jinja2 and PyYAML before they are installed, so the render
#       script runs in a temporary environment.
uv run --no-cache --no-project --with jinja2 --with pyyaml python3 /src/render-python-requirements.py
uv pip install --no-cache --system -r /src/requirements.txt -r /requirements.txt

# prepare project repository
git clone https://github.com/osism/ansible-playbooks /playbooks
git clone https://github.com/osism/generics /generics

if [ "$VERSION" != "latest" ]; then
  ( cd /playbooks || exit; git fetch --all --force; git checkout "$(yq -M -r .playbooks_version "/release/latest/base.yml")" )
  ( cd /generics || exit; git fetch --all --force; git checkout "$(yq -M -r .generics_version "/release/latest/base.yml")" )
fi

# pin the sources to the commits recorded in the labels
if [ -n "$SHA_ANSIBLE_PLAYBOOKS" ]; then ( cd /playbooks || exit; git checkout "$SHA_ANSIBLE_PLAYBOOKS" ); fi
if [ -n "$SHA_GENERICS" ]; then ( cd /generics || exit; git checkout "$SHA_GENERICS" ); fi

# add inventory files
mkdir -p /ansible/inventory.generics /ansible/inventory
cp /generics/inventory/* /ansible/inventory.generics

# run preparations
mkdir -p /ansible/group_vars/all

python3 /src/render-versions.py
python3 /src/render-ansible-requirements.py
ROLES_FILENAME=/release/etc/roles-manager.yml REQUIREMENTS_FILENAME=/ansible/requirements-manager.yml python3 /src/render-ansible-requirements.py

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

# install mitogen ansible plugin
mkdir -p /usr/share/mitogen
tar xzf /mitogen.tar.gz --strip-components=1 -C /usr/share/mitogen
rm -rf /usr/share/mitogen/{tests,docs,.ci,.lgtm.yml,.travis.yml}
rm /mitogen.tar.gz

# project specific instructions

# apply patches
for role in /usr/share/ansible/roles/*; do
  if [ -e /patches/"$(basename "$role")" ]; then
    for patchfile in /patches/"$(basename "$role")"/*.patch; do
      echo "$patchfile";
      ( cd /usr/share/ansible/roles/"$(basename "$role")" && patch --forward --batch -p1 --dry-run ) < "$patchfile" || exit 1;
      ( cd /usr/share/ansible/roles/"$(basename "$role")" && patch --forward --batch -p1 ) < "$patchfile";
    done;
  fi;
done

for role in /ansible/roles/*; do
  if [ -e /patches/"$(basename "$role")" ]; then
    for patchfile in /patches/"$(basename "$role")"/*.patch; do
      echo "$patchfile";
      ( cd /ansible/roles/"$(basename "$role")" && patch --forward --batch -p1 --dry-run ) < "$patchfile" || exit 1;
      ( cd /ansible/roles/"$(basename "$role")" && patch --forward --batch -p1 ) < "$patchfile";
    done;
  fi;
done

# prepare ansible directory
cp -r /playbooks/playbooks/* /ansible
cp /playbooks/library/* /ansible/library
mkdir -p /ansible/templates
cp /playbooks/templates/* /ansible/templates

# add symlink to /etc/openstack
ln -s /opt/configuration/environments/openstack /etc/openstack

# copy ara configuration
python3 -m ara.setup.env >> /ansible/ara.env

# prepare list of playbooks
python3 /src/generate-playbook-symlinks.py
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

uv pip install --no-cache --system pyclean==3.0.0
pyclean /usr
uv pip uninstall --system pyclean
EOF

USER dragon

FROM ${BASE_IMAGE}:${BASE_TAG}

COPY --link --from=builder / /

ENV PYTHONWARNINGS="ignore::UserWarning"

VOLUME ["/ansible/secrets", "/ansible/logs", "/ansible/cache", "/share", "/archive", "/interface"]

WORKDIR /ansible
RUN chown -R dragon: /ansible
USER dragon
ENTRYPOINT ["/entrypoint.sh"]
