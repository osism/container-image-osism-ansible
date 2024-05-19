# SPDX-License-Identifier: Apache-2.0

import glob
import os

ENVIRONMENTS = [
    "ceph",
    "generic",
    "infrastructure",
    "kolla",
    "manager",
    "monitoring",
    "openstack",
    "rook",
    "state",
]

for environment in ENVIRONMENTS:
    for src in glob.glob(f"/ansible/{environment}/*.yml"):
        dest = f"/ansible/{environment}-{os.path.basename(src)}"
        print(f"SYMLINK {dest} -> {src}")
        os.symlink(src, dest)
