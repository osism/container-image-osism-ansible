# SPDX-License-Identifier: Apache-2.0

import glob
import os

ENVIRONMENTS = [
    "ceph",
    "generic",
    "infrastructure",
    "kolla",
    "kubernetes",
    "manager",
    "monitoring",
    "openstack",
    "state",
]

SKIP = [
    "manager-bootstrap.yml",
    "manager-docker.yml",
    "manager-netbox.yml",
    "manager-network.yml",
    "manager-operator.yml",
    "manager-reboot.yml",
]

for environment in ENVIRONMENTS:
    for src in glob.glob(f"/ansible/{environment}/*.yml"):
        name = f"{environment}-{os.path.basename(src)}"
        dest = f"/ansible/{name}"

        if name not in SKIP and not os.path.islink(dest) and not name.startswith("_"):
            print(f"SYMLINK {dest} -> {src}")
            os.symlink(src, dest)
