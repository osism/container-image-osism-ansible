# SPDX-License-Identifier: Apache-2.0

import glob
import os

import jinja2
import yaml

# get environment parameters

VERSION = os.environ.get("VERSION", "latest")

# load versions files from release repository
#
# BaseLoader keeps every value a string exactly as written in the release,
# so an unquoted tag such as 2.90 stays "2.90" instead of becoming 2.9.

with open("/release/latest/base.yml", "rb") as fp:
    versions = yaml.load(fp, Loader=yaml.BaseLoader)

# prepare jinja2 environment
#
# StrictUndefined: a template variable this script does not pass fails the
# build instead of rendering "". Release keys a template line needs are
# guarded in the template itself, so an older release that lacks one simply
# omits that line.

loader = jinja2.FileSystemLoader(searchpath="/src/templates/")
environment = jinja2.Environment(loader=loader, undefined=jinja2.StrictUndefined)

# render versions.yml

template = environment.get_template("versions.yml.j2")

context = {
    "docker_version": versions["osism_projects"]["docker"],
    "version": VERSION,
    "versions": versions["docker_images"],
}

if VERSION != "latest":
    # One pin per Ceph release the release carries, keyed by its ceph_version.
    # The template selects one with the cluster's ceph_version when a play
    # runs: a release serves cephadm clusters on its default Ceph release and
    # existing ceph-ansible clusters on an older one.
    ceph_image_versions = {}
    cephclient_versions = {}
    for path in sorted(glob.glob("/release/latest/ceph-*.yml")):
        with open(path, "rb") as fp:
            flavour = yaml.load(fp, Loader=yaml.BaseLoader)
        series = flavour["ceph_version"]
        ceph_image_versions[series] = flavour["docker_images"]["ceph"]
        cephclient_versions[series] = flavour["docker_images"]["cephclient"]

    with open("/release/latest/openstack.yml", "rb") as fp:
        versions_openstack = yaml.load(fp, Loader=yaml.BaseLoader)

    context["ceph_image_versions"] = ceph_image_versions
    context["cephclient_versions"] = cephclient_versions
    context["openstackclient_version"] = versions_openstack["docker_images"][
        "openstackclient"
    ]

result = template.render(context)

with open("/ansible/group_vars/all/versions.yml", "w+") as fp:
    fp.write(result)

# render motd

template = environment.get_template("motd.j2")
result = template.render({"manager_version": versions["manager_version"]})
with open("/etc/motd", "w+") as fp:
    fp.write(result)
