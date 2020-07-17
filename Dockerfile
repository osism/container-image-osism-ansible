FROM ubuntu:20.04

ARG VERSION
ARG MITOGEN_VERSION=0.2.9

ARG USER_ID=45000
ARG GROUP_ID=45000
ARG GROUP_ID_DOCKER=999

ENV DEBIAN_FRONTEND noninteractive

USER root

COPY files/library /ansible/library
COPY files/plugins /ansible/plugins
COPY files/roles /ansible/roles
COPY files/tasks /ansible/tasks

COPY files/playbooks/* /ansible/
COPY files/scripts/* /

COPY files/ansible.cfg /etc/ansible/ansible.cfg
COPY files/defaults.yml /ansible/group_vars/all/defaults.yml
COPY files/images.yml /ansible/group_vars/all/images.yml

COPY files/src /src
COPY patches /patches

# show motd

RUN echo '[ ! -z "$TERM" -a -r /etc/motd ] && cat /etc/motd' >> /etc/bash.bashrc

# install required packages

RUN apt-get update \
    && apt-get install --no-install-recommends -y  \
      build-essential \
      dumb-init \
      git \
      gnupg-agent \
      libffi-dev \
      libssl-dev \
      libyaml-dev \
      openssh-client \
      python3-dev \
      python3-pip \
      python3-setuptools \
      python3-wheel \
      qemu-utils \
      rsync \
      sshpass \
      vim-tiny \
    && rm -rf /var/lib/apt/lists/*

# add user

RUN groupadd -g $GROUP_ID dragon \
    && groupadd -g $GROUP_ID_DOCKER docker \
    && useradd -g dragon -G docker -u $USER_ID -m -d /ansible dragon

# run preparations

WORKDIR /src
RUN git clone https://github.com/osism/release /release \
    && pip3 install --no-cache-dir -r requirements.txt \
    && mkdir -p /ansible/group_vars/all \
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

# exportes as volumes
RUN mkdir -p \
        /ansible/cache \
        /ansible/logs \
        /ansible/secrets \
        /share \
        /archive

# install required ansible roles

RUN ansible-galaxy role install -v -f -r /ansible/requirements.yml -p /usr/share/ansible/roles \
    && ln -s /usr/share/ansible/roles /ansible/galaxy \
    && ansible-galaxy collection install -v -f -r /ansible/requirements.yml -p /usr/share/ansible/collections \
    && ln -s /usr/share/ansible/collections /ansible/collections

# install required ansible plugins

ADD https://github.com/dw/mitogen/archive/v$MITOGEN_VERSION.tar.gz /mitogen.tar.gz
RUN tar xzf /mitogen.tar.gz --strip-components=1 -C /ansible/plugins/mitogen \
    && rm -rf \
        /ansible/plugins/mitogen/tests \
        /ansible/plugins/mitogen/docs \
        /ansible/plugins/mitogen/.ci \
        /ansible/plugins/mitogen/.lgtm.yml \
        /ansible/plugins/mitogen/.travis.yml \
    && rm /mitogen.tar.gz

# prepare project repository

RUN git clone https://github.com/osism/osism-ansible /repository \
    && ( cd /repository && git fetch --all --force ) \
    && if [ $VERSION != "latest" ]; then  ( cd /repository && git checkout tags/v$VERSION -b v$VERSION ); fi

# project specific instructions

RUN for role in $(ls -1 /ansible/galaxy); do \
    if [ -e /patches/$role ]; then \
        for patchfile in $(find /patches/$role -name "*.patch"); do \
            echo $patchfile; \
            ( cd /ansible/galaxy/$role && patch --forward --batch -p1 --dry-run ) < $patchfile || exit 1; \
            ( cd /ansible/galaxy/$role && patch --forward --batch -p1 ) < $patchfile; \
        done; \
    fi; \
    done

RUN cp /repository/playbooks/* /ansible \
    && cp /repository/library/* /ansible/library \
    && cp /repository/tasks/* /ansible/tasks

RUN git clone https://github.com/osism/tests.git /tests \
    && if [ $VERSION != "latest" ]; then  ( cd /tests && git checkout tags/v$VERSION -b v$VERSION ); fi \
    && pip3 install --no-cache-dir -r /tests/ansible/requirements.txt

RUN git clone https://github.com/osism/validations.git /validations \
    && if [ $VERSION != "latest" ]; then  ( cd /validations && git checkout tags/v$VERSION -b v$VERSION ); fi

RUN python3 -m ara.setup.env > /ansible/ara.env

# set correct permssions

RUN chown -R dragon: /ansible /share /archive

# cleanup

RUN apt-get clean \
    && apt-get remove -y  \
      build-essential \
      git \
      libffi-dev \
      libssl-dev \
      libyaml-dev \
      python3-dev \
    && apt-get autoremove -y \
    && rm -rf \
      /release \
      /root/.cache \
      /src \
      /patches \
      /tmp/* \
      /usr/share/doc/* \
      /usr/share/man/* \
      /var/tmp/*

VOLUME ["/ansible/secrets", "/ansible/logs", "/ansible/cache", "/share", "/archive"]

USER dragon
WORKDIR /ansible

ENTRYPOINT ["/usr/bin/dumb-init", "--"]

LABEL "org.opencontainers.image.documentation"="https://docs.osism.de" \
      "org.opencontainers.image.licenses"="ASL 2.0" \
      "org.opencontainers.image.source"="https://github.com/osism/docker-osism-ansible" \
      "org.opencontainers.image.url"="https://www.osism.de" \
      "org.opencontainers.image.vendor"="Betacloud Solutions GmbH"
