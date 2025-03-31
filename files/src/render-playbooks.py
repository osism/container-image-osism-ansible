# SPDX-License-Identifier: Apache-2.0

# This script writes a list of all existing playbooks to /ansible/playbooks.yml.

from pathlib import Path

import yaml

PREFIXES = [
    "ceph",
    "generic",
    "infrastructure",
    "kolla",
    "kubernetes",
    "manager",
    "monitoring",
    "openstack",
    "proxmox",
]

KEEP_PREFIX = {
    "ceph": [],
    "generic": [],
    "infrastructure": [],
    "kolla": [],
    "kubernetes": [],
    "manager": ["operator", "network"],
    "monitoring": [],
    "openstack": [],
    "proxmox": [],
}

HIDE = {
    "ceph": [],
    "generic": ["common"],
    "infrastructure": [],
    "kolla": [],
    "kubernetes": [],
    "manager": [],
    "monitoring": [],
    "openstack": [],
    "proxmox": [],
}

result = {}

for prefix in PREFIXES:
    for path in Path("/ansible").glob(f"{prefix}-*.yml"):
        name = path.with_suffix("").name[len(prefix) + 1 :]  # noqa E203

        if name not in HIDE[prefix]:
            if name in KEEP_PREFIX[prefix]:
                result[f"{prefix}-{name}"] = prefix
            else:
                result[name] = prefix

with open("/ansible/playbooks.yml", "w+") as fp:
    fp.write(yaml.dump(result))
