# SPDX-License-Identifier: Apache-2.0

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
    with open("/release/latest/ceph.yml", "rb") as fp:
        versions_ceph = yaml.load(fp, Loader=yaml.BaseLoader)

    with open("/release/latest/openstack.yml", "rb") as fp:
        versions_openstack = yaml.load(fp, Loader=yaml.BaseLoader)

    context["ceph_image_version"] = versions_ceph["docker_images"]["ceph"]
    context["cephclient_version"] = versions_ceph["docker_images"]["cephclient"]
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
