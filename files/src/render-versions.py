# SPDX-License-Identifier: Apache-2.0

import glob
import os

import jinja2
import yaml

# get environment parameters

VERSION = os.environ.get("VERSION", "latest")

# load versions files from release repository

with open("/release/latest/base.yml", "rb") as fp:
    versions = yaml.load(fp, Loader=yaml.FullLoader)

# prepare jinja2 environment

loader = jinja2.FileSystemLoader(searchpath="/src/templates/")
environment = jinja2.Environment(loader=loader)

# render versions.yml

template = environment.get_template("versions.yml.j2")

if VERSION == "latest":
    result = template.render(
        {"docker_version": versions["osism_projects"]["docker"], "version": VERSION}
    )
else:
    # One pin per Ceph release the release carries, keyed by its ceph_version.
    # The template selects one with the cluster's ceph_version when a play
    # runs: a release serves cephadm clusters on its default Ceph release and
    # existing ceph-ansible clusters on an older one.
    ceph_image_versions = {}
    cephclient_versions = {}
    for path in sorted(glob.glob("/release/latest/ceph-*.yml")):
        with open(path, "rb") as fp:
            flavour = yaml.load(fp, Loader=yaml.FullLoader)
        series = flavour["ceph_version"]
        ceph_image_versions[series] = flavour["docker_images"]["ceph"]
        cephclient_versions[series] = flavour["docker_images"]["cephclient"]

    with open("/release/latest/openstack.yml", "rb") as fp:
        versions_openstack = yaml.load(fp, Loader=yaml.FullLoader)

    result = template.render(
        {
            "ceph_image_versions": ceph_image_versions,
            "cephclient_versions": cephclient_versions,
            "docker_version": versions["osism_projects"]["docker"],
            "openstackclient_version": versions_openstack["docker_images"][
                "openstackclient"
            ],
            "version": VERSION,
        }
    )

with open("/ansible/group_vars/all/versions.yml", "w+") as fp:
    fp.write(result)

# render motd

template = environment.get_template("motd.j2")
result = template.render({"manager_version": versions["manager_version"]})
with open("/etc/motd", "w+") as fp:
    fp.write(result)
