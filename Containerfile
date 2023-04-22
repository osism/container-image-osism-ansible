ARG RELEASE_RECEPTOR=1.0.0
FROM quay.io/project-receptor/receptor:${RELEASE_RECEPTOR} as receptor

FROM python:3.11-slim

ARG VERSION=latest
ARG IS_RELEASE=false

# NOTE: master required because of Ansible 2.13 support
ARG MITOGEN_VERSION=master

ARG USER_ID=45000
ARG GROUP_ID=45000
ARG GROUP_ID_DOCKER=999

ENV DEBIAN_FRONTEND=noninteractive

COPY --from=receptor /usr/bin/receptor /usr/bin/receptor
COPY files/receptor.conf /etc/receptor/receptor.conf
RUN mkdir -p /var/run/receptor

USER root

COPY files/library /ansible/library
COPY files/roles /ansible/roles
COPY files/tasks /ansible/tasks
COPY files/plugins /usr/share/ansible/plugins

COPY files/playbooks/* /ansible/
COPY files/scripts/* /

COPY files/ansible.cfg /etc/ansible/ansible.cfg

COPY files/src /src
COPY patches /patches

# show motd
RUN echo "[ ! -z \"\$TERM\" -a -r /etc/motd ] && cat /etc/motd" >> /etc/bash.bashrc

# install required packages

# hadolint ignore=DL3008
RUN apt-get update \
    && apt-get install --no-install-recommends -y  \
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
      sshpass \
    && update-alternatives --install /usr/bin/python3 python3 /usr/local/bin/python3 1 \
    && update-alternatives --install /usr/bin/python python /usr/local/bin/python 1 \
    && python3 -m pip install --no-cache-dir --upgrade 'pip==23.1.1' \
    && pip3 install --no-cache-dir -r /src/requirements.txt \
    && rm -rf /var/lib/apt/lists/*

# add user
RUN groupadd -g $GROUP_ID dragon \
    && groupadd -g $GROUP_ID_DOCKER docker \
    && useradd -l -g dragon -G docker -u $USER_ID -m -d /ansible dragon

# prepare release repository
RUN git clone https://github.com/osism/release /release

# prepare project repository

# hadolint ignore=DL3003
RUN git clone https://github.com/osism/ansible-playbooks /playbooks \
    && ( cd /playbooks || exit; git fetch --all --force; git checkout "$(yq -M -r .playbooks_version "/release/$VERSION/base.yml")" )

# hadolint ignore=DL3003
RUN git clone https://github.com/osism/ansible-defaults /defaults \
    && ( cd /defaults || exit; git fetch --all --force; git checkout "$(yq -M -r .defaults_version "/release/$VERSION/base.yml")" )

# hadolint ignore=DL3003
RUN git clone https://github.com/osism/cfg-generics /generics  \
    && ( cd /generics || exit; git fetch --all --force; git checkout "$(yq -M -r .generics_version "/release/$VERSION/base.yml")" )

# add inventory files
RUN mkdir -p /ansible/inventory.generics /ansible/inventory \
    && cp /generics/inventory/50-ceph /ansible/inventory.generics/50-ceph \
    && cp /generics/inventory/50-infrastruture /ansible/inventory.generics/50-infrastruture \
    && cp /generics/inventory/50-kolla /ansible/inventory.generics/50-kolla \
    && cp /generics/inventory/50-monitoring /ansible/inventory.generics/50-monitoring \
    && cp /generics/inventory/50-openstack /ansible/inventory.generics/50-openstack \
    && cp /generics/inventory/51-ceph /ansible/inventory.generics/51-ceph \
    && cp /generics/inventory/51-kolla /ansible/inventory.generics/51-kolla \
    && cp /generics/inventory/60-generic /ansible/inventory.generics/60-generic

# run preparations
WORKDIR /src
RUN mkdir -p /ansible/group_vars \
    && cp -r /defaults/* /ansible/group_vars/ \
    && rm -f /ansible/group_vars/LICENSE /ansible/group_vars/README.md \
    && python3 render-python-requirements.py \
    && python3 render-versions.py \
    && python3 render-ansible-requirements.py \
    && ROLES_FILENAME=/release/etc/roles-manager.yml \
       REQUIREMENTS_FILENAME=/ansible/requirements-manager.yml \
       python3 render-ansible-requirements.py \
    && python3 render-docker-images.py

WORKDIR /

# install required python packages
RUN pip3 install --no-cache-dir -r /requirements.txt

# set ansible version in the motd
RUN ansible_version=$(python3 -c 'import ansible; print(ansible.release.__version__)') \
    && sed -i -e "s/ANSIBLE_VERSION/$ansible_version/" /etc/motd

# create required directories
RUN mkdir -p \
        /ansible \
        /ansible/action_plugins \
        /ansible/cache \
        /ansible/logs \
        /ansible/secrets \
        /share \
        /archive \
        /interface \
        /usr/share/ansible/plugins/mitogen

# install required ansible collections & roles
RUN ansible-galaxy role install -v -f -r /ansible/requirements.yml -p /usr/share/ansible/roles \
    && ln -s /usr/share/ansible/roles /ansible/galaxy \
    && ansible-galaxy collection install -v -f -r /ansible/requirements.yml -p /usr/share/ansible/collections \
    && ln -s /usr/share/ansible/collections /ansible/collections \
    && ln -s /usr/share/ansible/plugins /ansible/plugins

# install mitogen ansible plugin

ADD https://github.com/dw/mitogen/archive/$MITOGEN_VERSION.tar.gz /mitogen.tar.gz
RUN tar xzf /mitogen.tar.gz --strip-components=1 -C /usr/share/ansible/plugins/mitogen \
    && rm -rf \
        /usr/share/ansible/plugins/mitogen/tests \
        /usr/share/ansible/plugins/mitogen/docs \
        /usr/share/ansible/plugins/mitogen/.ci \
        /usr/share/ansible/plugins/mitogen/.lgtm.yml \
        /usr/share/ansible/plugins/mitogen/.travis.yml \
    && rm /mitogen.tar.gz

# project specific instructions

# add k3s-ansible roles
RUN git clone https://github.com/techno-tim/k3s-ansible /k3s-ansible \
    && mkdir -p /ansible/roles/k3s \
    && mv /k3s-ansible/roles/* /ansible/roles/k3s \
    && mv /ansible/roles/k3s/k3s/* /ansible/roles/k3s \
    && rm -rf /k3s-ansible /ansible/roles/k3s/k3s

# hadolint ignore=DL3003
RUN for role in /usr/share/ansible/roles/*; do \
    if [ -e /patches/"$(basename "$role")" ]; then \
        for patchfile in /patches/"$(basename "$role")"/*.patch; do \
            echo "$patchfile"; \
            ( cd /usr/share/ansible/roles/"$(basename "$role")" && patch --forward --batch -p1 --dry-run ) < "$patchfile" || exit 1; \
            ( cd /usr/share/ansible/roles/"$(basename "$role")" && patch --forward --batch -p1 ) < "$patchfile"; \
        done; \
    fi; \
    done

# hadolint ignore=DL3059
RUN cp -r /playbooks/playbooks/* /ansible \
    && cp /playbooks/library/* /ansible/library \
    && mkdir -p /ansible/templates \
    && cp /playbooks/templates/* /ansible/templates

# add symlink to /etc/openstack
RUN ln -s /opt/configuration/environments/openstack /etc/openstack

# copy ara configuration
COPY files/ara.env /ansible/ara.env
RUN python3 -m ara.setup.env >> /ansible/ara.env

# prepare list of playbooks
RUN python3 /src/render-playbooks.py

# set correct permssions
# hadolint ignore=DL3059
RUN chown -R dragon: /ansible /share /archive /interface

# cleanup
RUN apt-get clean \
    && apt-get remove -y  \
      build-essential \
      gcc-9-base \
      git \
      libffi-dev \
      libssh-dev \
      libssl-dev \
      libyaml-dev \
    && apt-get autoremove -y \
    && rm -rf \
      /release \
      /root/.cache \
      /patches \
      /tmp/* \
      /usr/share/doc/* \
      /usr/share/man/* \
      /var/tmp/*

VOLUME ["/ansible/secrets", "/ansible/logs", "/ansible/cache", "/share", "/archive", "/interface"]

USER dragon
WORKDIR /ansible

ENTRYPOINT ["/entrypoint.sh"]
