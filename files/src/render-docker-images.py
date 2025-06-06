# SPDX-License-Identifier: Apache-2.0

import jinja2
import yaml

# load versions files from release repository

with open("/release/latest/base.yml", "rb") as fp:
    versions = yaml.load(fp, Loader=yaml.FullLoader)

with open("/release/etc/images.yml", "rb") as fp:
    images = yaml.load(fp, Loader=yaml.FullLoader)

# prepare jinja2 environment

loader = jinja2.FileSystemLoader(searchpath="/src/templates/")
environment = jinja2.Environment(loader=loader)

# render images.yml

template = environment.get_template("images.yml.j2")
result = template.render(
    {
        "images": images,
        "manager_version": versions["manager_version"],
        "versions": versions["docker_images"],
    }
)
with open("/ansible/group_vars/all/images.yml", "w+") as fp:
    fp.write(result)
