# This script writes a list of all existing playbooks to /ansible/playbooks.yml.

from pathlib import Path

import yaml

PREFIXES = [
    "generic",
    "manager",
    "monitoring",
    "infrastructure",
]

KEEP_PREFIX = {
    "generic": [],
    "manager": ["operator", "network"],
    "monitoring": [],
    "infrastructure": [],
}

HIDE = {
    "generic": ["common"],
    "manager": [],
    "monitoring": [],
    "infrastructure": [],
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
