# SPDX-License-Identifier: Apache-2.0

import os

import jinja2
import yaml

# get environment parameters

COLLECTIONS_FILENAME = os.environ.get(
    "COLLECTIONS_FILENAME", "/release/etc/collections.yml"
)
REQUIREMENTS_FILENAME = os.environ.get(
    "REQUIREMENTS_FILENAME", "/ansible/requirements.yml"
)
ROLES_FILENAME = os.environ.get("ROLES_FILENAME", "/release/etc/roles.yml")
VERSION = os.environ.get("VERSION", "latest")

# load versions files from release repository

with open("/release/latest/base.yml", "rb") as fp:
    versions = yaml.load(fp, Loader=yaml.FullLoader)

with open(ROLES_FILENAME, "rb") as fp:
    ansible_role_names = yaml.load(fp, Loader=yaml.FullLoader)

with open(COLLECTIONS_FILENAME, "rb") as fp:
    ansible_collection_names = yaml.load(fp, Loader=yaml.FullLoader)

# prepare jinja2 environment

loader = jinja2.FileSystemLoader(searchpath="/src/templates/")
environment = jinja2.Environment(loader=loader)

# render requirements.yml

template = environment.get_template("requirements.yml.j2")
result = template.render(
    {
        "ansible_roles": versions["ansible_roles"],
        "ansible_role_names": ansible_role_names,
        "ansible_collections": versions["ansible_collections"],
        "ansible_collection_names": ansible_collection_names,
        "version": VERSION,
    }
)
with open(REQUIREMENTS_FILENAME, "w+") as fp:
    fp.write(result)
