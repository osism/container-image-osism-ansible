ARG UBUNTU_VERSION=20.04

ARG RELEASE_RECEPTOR=0.9.7
FROM quay.io/project-receptor/receptor:${RELEASE_RECEPTOR} as receptor

FROM ubuntu:${UBUNTU_VERSION}

ARG VERSION=latest

ARG USER_ID=45000
ARG GROUP_ID=45000
ARG GROUP_ID_DOCKER=999

ENV DEBIAN_FRONTEND=noninteractive

COPY --from=receptor /usr/bin/receptor /usr/bin/receptor
COPY files/receptor.conf /etc/receptor/receptor.conf
RUN mkdir -p /var/run/receptor

USER root

COPY files/inventory /ansible/inventory
COPY files/library /ansible/library
COPY files/roles /ansible/roles
COPY files/tasks /ansible/tasks
COPY files/plugins /usr/share/ansible/plugins

COPY files/playbooks/* /ansible/
COPY files/scripts/* /

COPY files/ansible.cfg /etc/ansible/ansible.cfg

COPY files/src /src
COPY patches /patches

# add inventory files

ADD https://raw.githubusercontent.com/osism/cfg-generics/master/inventory/50-ceph /ansible/inventory.generics/50-ceph
ADD https://raw.githubusercontent.com/osism/cfg-generics/master/inventory/50-infrastruture /ansible/inventory.generics/50-infrastruture
ADD https://raw.githubusercontent.com/osism/cfg-generics/master/inventory/50-kolla /ansible/inventory.generics/50-kolla
ADD https://raw.githubusercontent.com/osism/cfg-generics/master/inventory/50-monitoring /ansible/inventory.generics/50-monitoring
ADD https://raw.githubusercontent.com/osism/cfg-generics/master/inventory/50-openstack /ansible/inventory.generics/50-openstack
ADD https://raw.githubusercontent.com/osism/cfg-generics/master/inventory/51-ceph /ansible/inventory.generics/51-ceph
ADD https://raw.githubusercontent.com/osism/cfg-generics/master/inventory/51-kolla /ansible/inventory.generics/51-kolla
ADD https://raw.githubusercontent.com/osism/cfg-generics/master/inventory/60-generic /ansible/inventory.generics/60-generic

# show motd

RUN echo "[ ! -z \"\$TERM\" -a -r /etc/motd ] && cat /etc/motd" >> /etc/bash.bashrc

# install required packages

# hadolint ignore=DL3008
RUN apt-get update \
    && apt-get install --no-install-recommends -y  \
      build-essential \
      dumb-init \
      git \
      gnupg-agent \
      iputils-ping \
      libffi-dev \
      libssl-dev \
      libyaml-dev \
      openssh-client \
      python3-dev \
      python3-pip \
      python3-setuptools \
      python3-wheel \
      rsync \
      sshpass \
      vim-tiny \
    && python3 -m pip install --upgrade pip \
    && update-alternatives --install /usr/bin/python python /usr/bin/python3 1 \
    && rm -rf /var/lib/apt/lists/*

# add user

RUN groupadd -g $GROUP_ID dragon \
    && groupadd -g $GROUP_ID_DOCKER docker \
    && useradd -l -g dragon -G docker -u $USER_ID -m -d /ansible dragon

# prepare project repository

# hadolint ignore=DL3003
RUN git clone https://github.com/osism/ansible-playbooks /repository \
    && ( cd /repository && git fetch --all --force ) \
    && if [ $VERSION != "latest" ]; then  ( cd /repository && git checkout tags/v$VERSION -b v$VERSION ); fi

# hadolint ignore=DL3003
RUN git clone https://github.com/osism/ansible-defaults /defaults \
    && ( cd /defaults && git fetch --all --force ) \
    && if [ $VERSION != "latest" ]; then  ( cd /defaults && git checkout tags/v$VERSION -b v$VERSION ); fi

# run preparations

WORKDIR /src
RUN git clone https://github.com/osism/release /release \
    && pip3 install --no-cache-dir -r requirements.txt \
    && mkdir -p /ansible/group_vars \
    && cp -r /defaults/* /ansible/group_vars/ \
    && rm -f /ansible/group_vars/LICENSE /ansible/group_vars/README.md \
    && cp -r /repository/workflows /ansible/workflows \
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

# internal use only
RUN mkdir -p \
        /ansible \
        /ansible/action_plugins

# exports as volumes
RUN mkdir -p \
        /ansible/cache \
        /ansible/logs \
        /ansible/secrets \
        /share \
        /archive \
        /interface

# install required ansible collections & roles

RUN ansible-galaxy role install -v -f -r /ansible/requirements.yml -p /usr/share/ansible/roles \
    && ln -s /usr/share/ansible/roles /ansible/galaxy \
    && ansible-galaxy collection install -v -f -r /ansible/requirements.yml -p /usr/share/ansible/collections \
    && ln -s /usr/share/ansible/collections /ansible/collections

RUN ln -s /usr/share/ansible/plugins /ansible/plugins

# project specific instructions

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

RUN cp /repository/playbooks/* /ansible \
    && cp /repository/library/* /ansible/library \
    && cp /repository/tasks/* /ansible/tasks

RUN git clone https://github.com/netbox-community/devicetype-library /opt/netbox-devicetype-library

RUN python3 -m ara.setup.env > /ansible/ara.env

# set correct permssions

RUN chown -R dragon: /ansible /share /archive /interface

# cleanup

RUN apt-get clean \
    && apt-get remove -y  \
      build-essential \
      gcc-9-base \
      git \
      libffi-dev \
      libssl-dev \
      libyaml-dev \
      python3-dev \
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

LABEL "org.opencontainers.image.documentation"="https://docs.osism.de" \
      "org.opencontainers.image.licenses"="ASL 2.0" \
      "org.opencontainers.image.source"="https://github.com/osism/container-image-osism-ansible" \
      "org.opencontainers.image.url"="https://www.osism.de" \
      "org.opencontainers.image.vendor"="OSISM GmbH"
