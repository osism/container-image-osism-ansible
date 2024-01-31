# SPDX-License-Identifier: Apache-2.0

import os

import yaml

# get environment parameters
VERSION = os.environ.get("VERSION", "latest")

# load versions files from release repository
with open("/release/%s/base.yml" % VERSION, "rb") as fp:
    versions = yaml.load(fp, Loader=yaml.FullLoader)

# install helm chart repositories
for name in versions["helm_chart_repositories"]:
    repository = versions["helm_chart_repositories"][name]
    command = f"helm repo add {name} {repository}"
    print(f"RUN {command}")
    os.system(command)
