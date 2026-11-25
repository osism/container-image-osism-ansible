#!/usr/bin/env python3

# SPDX-License-Identifier: Apache-2.0

# Build the file that OS_CLIENT_SECURE_FILE points to. It merges the plain
# secure.yml of an environment with the os_password_<cloud> entries of its
# secrets.yml, so that Ansible plays authenticate like the osism CLI.

import copy
import os
import sys

from ansible.errors import AnsibleError
from ansible.parsing.dataloader import DataLoader
from ansible.parsing.vault import get_file_vault_secret, is_encrypted_file
import yaml


class SecureFileError(Exception):
    pass


def first_existing(env_dir, names):
    for name in names:
        path = os.path.join(env_dir, name)
        if os.path.isfile(path):
            return path
    return None


def load_clouds(env_dir):
    path = first_existing(env_dir, ["clouds.yaml", "clouds.yml"])
    if path is None:
        return {}
    with open(path) as fp:
        data = yaml.safe_load(fp)
    clouds = data.get("clouds") if isinstance(data, dict) else None
    return clouds if isinstance(clouds, dict) else {}


def load_secure(env_dir):
    path = first_existing(env_dir, ["secure.yaml", "secure.yml"])
    if path is None:
        return {"clouds": {}}
    with open(path, "rb") as fp:
        if is_encrypted_file(fp):
            print(f"WARNING: ignoring vault-encrypted {path}", file=sys.stderr)
            return {"clouds": {}}
    with open(path) as fp:
        data = yaml.safe_load(fp)
    if not isinstance(data, dict) or not isinstance(data.get("clouds"), dict):
        raise SecureFileError(f"{path} is not a mapping with a clouds mapping")
    return data


def load_secrets(env_dir, vault_file):
    path = os.path.join(env_dir, "secrets.yml")
    if not os.path.isfile(path):
        return {}
    try:
        loader = DataLoader()
        secret = get_file_vault_secret(filename=vault_file, loader=loader)
        secret.load()
        loader.set_vault_secrets([("default", secret)])
        data = loader.load_from_file(path)
    except AnsibleError as exc:
        raise SecureFileError(f"cannot read {path}: {exc}") from exc
    if data is None:
        return {}
    if not isinstance(data, dict):
        raise SecureFileError(f"{path} is not a mapping")
    return data


def build_secure_config(env_dir, vault_file):
    config = copy.deepcopy(load_secure(env_dir))
    secrets = load_secrets(env_dir, vault_file)
    for cloud in load_clouds(env_dir):
        value = secrets.get("os_password_" + str(cloud).replace("-", "_"))
        password = str(value).strip() if value is not None else ""
        if not password:
            continue
        entry = config["clouds"].setdefault(cloud, {})
        entry.setdefault("auth", {})["password"] = password
    return config


def write_secure_file(path, config):
    fd = os.open(path, os.O_WRONLY | os.O_CREAT | os.O_TRUNC, 0o600)
    with os.fdopen(fd, "w") as fp:
        yaml.safe_dump(config, fp)


def main(argv):
    if len(argv) != 3:
        print(
            "usage: openstack-secure-file.py ENV_DIR VAULT_FILE OUTPUT", file=sys.stderr
        )
        return 1
    env_dir, vault_file, output = argv
    try:
        config = build_secure_config(env_dir, vault_file)
    except SecureFileError as exc:
        print(f"ERROR: {exc}", file=sys.stderr)
        return 1
    write_secure_file(output, config)
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
