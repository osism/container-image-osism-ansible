import os

import jinja2
import yaml

# get environment parameters

VERSION = os.environ.get("VERSION", "latest")

# load versions files from release repository

with open("/release/%s/base.yml" % VERSION, "rb") as fp:
    versions = yaml.load(fp, Loader=yaml.FullLoader)

with open("/release/etc/images.yml", "rb") as fp:
    images = yaml.load(fp, Loader=yaml.FullLoader)

# prepare jinja2 environment

loader = jinja2.FileSystemLoader(searchpath="templates/")
environment = jinja2.Environment(loader=loader)

# render images.yml

template = environment.get_template("images.yml.j2")
result = template.render({
  'images': images,
  'versions': versions
})
with open("/ansible/group_vars/all/images.yml", "w+") as fp:
    fp.write(result)
