# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

This file was started on April 08, 2025. Changes prior to this date are not included in the CHANGELOG.

## [v0.20260319.0] - 2026-03-19

### Added
- Support for fast inventory directory — use `/inventory/fast/` as `ANSIBLE_INVENTORY` when available, with fallback to `hosts.yml` (osism/container-image-osism-ansible#725)

### Changed
- Cleanup `.ansible-lint` file by removing unused configuration options (osism/container-image-osism-ansible#719)

### Removed
- Defaults repository from container build — no longer cloned, checked out, or copied into ansible group_vars directory (osism/container-image-osism-ansible#727)

### Dependencies
- cryptography 46.0.4 → 46.0.5 (osism/container-image-osism-ansible#717)
- ghcr.io/astral-sh/uv 0.9.27 → 0.10.10 (osism/container-image-osism-ansible#716, osism/container-image-osism-ansible#718, osism/container-image-osism-ansible#720)
- proxmoxer 2.2.0 → 2.3.0 (osism/container-image-osism-ansible#724)
- python-designateclient 6.3.0 → 6.4.0 (osism/container-image-osism-ansible#721)
- python-dotenv 1.2.1 → 1.2.2 (osism/container-image-osism-ansible#723)
- python-neutronclient 11.7.0 → 11.8.0 (osism/container-image-osism-ansible#722)

## [v0.20260129.0] - 2026-01-29

### Dependencies

- mitogen 0.3.22 → 0.3.39 (osism/container-image-osism-ansible#715)

## [v0.20260128.0] - 2026-01-28

### Dependencies
- ghcr.io/astral-sh/uv 0.9.16 → 0.9.27 (osism/container-image-osism-ansible#708, osism/container-image-osism-ansible#709, osism/container-image-osism-ansible#711, osism/container-image-osism-ansible#712)
- python-neutronclient 11.6.0 → 11.7.0 (osism/container-image-osism-ansible#710)
- cryptography 46.0.3 → 46.0.4 (osism/container-image-osism-ansible#714)

## [v0.20251208.0] - 2025-12-08

### Dependencies
- ghcr.io/astral-sh/uv 0.9.13 → 0.9.16 (osism/container-image-osism-ansible#707)

## [v0.20251130.0] - 2025-11-30

### Fixed
- /ansible directory permissions when using Docker 29.0.0, ensuring WORKDIR is owned by dragon (osism/container-image-osism-ansible#704)

### Dependencies
- ghcr.io/astral-sh/uv 0.9.6 → 0.9.13 (osism/container-image-osism-ansible#702, osism/container-image-osism-ansible#703, osism/container-image-osism-ansible#705, osism/container-image-osism-ansible#706)
- hvac 2.3.0 → 2.4.0 (osism/container-image-osism-ansible#701)

## [v0.20251101.0] - 2025-11-01

### Added
- `osism_ansible_version` parameter to versions template (osism/container-image-osism-ansible#693)

### Dependencies
- ansible-pylibssh 1.2.2 → 1.3.0 (osism/container-image-osism-ansible#696)
- cryptography 46.0.1 → 46.0.3 (osism/container-image-osism-ansible#692, osism/container-image-osism-ansible#699)
- ghcr.io/astral-sh/uv 0.8.22 → 0.9.6 (osism/container-image-osism-ansible#694, osism/container-image-osism-ansible#695, osism/container-image-osism-ansible#698)
- idna 3.10 → 3.11 (osism/container-image-osism-ansible#697)
- paramiko 3.5.1 → 4.0.0 (osism/container-image-osism-ansible#680)
- python-dotenv 1.1.1 → 1.2.1 (osism/container-image-osism-ansible#700)

## [v0.20250927.0] - 2025-09-27

### Dependencies
- ghcr.io/astral-sh/uv 0.8.19 → 0.8.22 (osism/container-image-osism-ansible#688)
- pyyaml 6.0.2 → 6.0.3 (osism/container-image-osism-ansible#690)

## [v0.20250920.0] - 2025-09-20

### Dependencies
- cryptography 45.0.7 → 46.0.1 (osism/container-image-osism-ansible#685)
- ghcr.io/astral-sh/uv 0.8.17 → 0.8.19 (osism/container-image-osism-ansible#686, osism/container-image-osism-ansible#687)

## [v0.20250915.0] - 2025-09-15

### Added
- Container image signing with cosign in Zuul CI pipeline (osism/container-image-osism-ansible#678)

### Dependencies
- cryptography 45.0.5 → 45.0.7 (osism/container-image-osism-ansible#681, osism/container-image-osism-ansible#684)
- pymysql 1.1.1 → 1.1.2 (osism/container-image-osism-ansible#683)
- requests 2.32.4 → 2.32.5 (osism/container-image-osism-ansible#682)
- ghcr.io/astral-sh/uv 0.7.20 → 0.8.17 (osism/container-image-osism-ansible#679)

## [v0.20250711.0] - 2025-07-11

### Dependencies
- kubernetes 32.0.1 → 33.1.0 (osism/container-image-osism-ansible#668)
- python-neutronclient 11.5.0 → 11.6.0 (osism/container-image-osism-ansible#676)
- ghcr.io/astral-sh/uv 0.7.19 → 0.7.20 (osism/container-image-osism-ansible#677)

## [v0.20250704.0] - 2025-07-04

### Dependencies
- ghcr.io/astral-sh/uv 0.7.8 → 0.7.19 (osism/container-image-osism-ansible#664, osism/container-image-osism-ansible#665, osism/container-image-osism-ansible#666, osism/container-image-osism-ansible#670, osism/container-image-osism-ansible#671, osism/container-image-osism-ansible#673, osism/container-image-osism-ansible#674)
- requests 2.32.3 → 2.32.4 (osism/container-image-osism-ansible#667)
- cryptography 45.0.3 → 45.0.5 (osism/container-image-osism-ansible#669, osism/container-image-osism-ansible#675)
- python-dotenv 1.1.0 → 1.1.1 (osism/container-image-osism-ansible#672)

## [v0.20250531.0] - 2025-05-31

No changes. This release is identical to v0.20250530.0.

## [v0.20250530.0] - 2025-05-30

### Changed
- Refresh Zuul secrets (osism/container-image-osism-ansible#652)
- Use image cache for container builds (osism/container-image-osism-ansible#653)

### Dependencies
- ghcr.io/astral-sh/uv 0.6.13 → 0.7.8 (osism/container-image-osism-ansible#646, osism/container-image-osism-ansible#647, osism/container-image-osism-ansible#648, osism/container-image-osism-ansible#649, osism/container-image-osism-ansible#651, osism/container-image-osism-ansible#654, osism/container-image-osism-ansible#657, osism/container-image-osism-ansible#660, osism/container-image-osism-ansible#661, osism/container-image-osism-ansible#662)
- cryptography 44.0.2 → 45.0.3 (osism/container-image-osism-ansible#650, osism/container-image-osism-ansible#658, osism/container-image-osism-ansible#659, osism/container-image-osism-ansible#663)
- python-designateclient 6.2.0 → 6.3.0 (osism/container-image-osism-ansible#655)
- python-neutronclient 11.4.0 → 11.5.0 (osism/container-image-osism-ansible#656)

## [v0.20250408.0] - 2025-04-08

### Added
- Initial public release of the osism-ansible container image
- Travis CI support for tagged releases (osism/container-image-osism-ansible#9, osism/container-image-osism-ansible#10, osism/container-image-osism-ansible#11)
- openssh-client package for synchronize task support (osism/container-image-osism-ansible#14)
- OCI image labels (org.opencontainers.image) (osism/container-image-osism-ansible#17)
- Debops role symlinks for ansible_plugins and secret (osism/container-image-osism-ansible#18)
- Quay registry support for development image builds (osism/container-image-osism-ansible#21)
- OCI container labels for documentation, license, source, title, URL, and vendor (osism/container-image-osism-ansible#22)
- Default `utilities_base` package list (osism/container-image-osism-ansible#33)
- GitHub Actions workflows for PR labeling and master repository sync (osism/container-image-osism-ansible#38)
- Patch mechanism for Ansible roles with auditd task disabling in hardening role (osism/container-image-osism-ansible#41)
- Validations repository (osism/container-image-osism-ansible#42)
- Inventory files from cfg-generics (osism/container-image-osism-ansible#55)
- Trivy vulnerability scanner for container image security scanning (osism/container-image-osism-ansible#56)
- NETBOX_TOKEN environment variable support via Docker secrets (osism/container-image-osism-ansible#59)
- osism.services Ansible collection installation (osism/container-image-osism-ansible#62, osism/container-image-osism-ansible#63)
- osism.commons Ansible collection installation (osism/container-image-osism-ansible#65)
- ansible.netcommon collection (osism/container-image-osism-ansible#69)
- Netbox inventory file (99-netbox.yml) with conditional removal when NETBOX_TOKEN secret is missing (osism/container-image-osism-ansible#64)
- python-libmaas dependency (osism/container-image-osism-ansible#73)
- UBUNTU_VERSION build argument to Dockerfile (osism/container-image-osism-ansible#77)
- Python symlink (/usr/bin/python → /usr/bin/python3) (osism/container-image-osism-ansible#78)
- `--playbook-dir` parameter to run-ansible.sh (osism/container-image-osism-ansible#67)
- Sync of /ansible/group_vars/ with /ansible/inventory/group_vars/ in all run scripts (osism/container-image-osism-ansible#68)
- Daily scheduled build via GitHub Actions (osism/container-image-osism-ansible#85)
- GitHub Actions workflows for Docker image building, Dockerfile linting, and YAML syntax checking (osism/container-image-osism-ansible#72)
- `run-state.sh` script for running Ansible state playbooks (osism/container-image-osism-ansible#111)
- `community.general` Ansible collection (osism/container-image-osism-ansible#102)
- `community.network` Ansible collection (osism/container-image-osism-ansible#104)
- Kolla address filter plugins (`kolla_address`, `put_address_in_context`) (osism/container-image-osism-ansible#116)
- Workflow files copied from playbooks repository (osism/container-image-osism-ansible#114)
- Inventory overwrite handling script to allow overriding group definitions via `99-overwrite` file (osism/container-image-osism-ansible#120)
- Inventory merging step in all run scripts (osism/container-image-osism-ansible#122)
- Arista Ansible collections (arista.cvp, arista.eos) (osism/container-image-osism-ansible#129)
- ansible.posix collection (osism/container-image-osism-ansible#132)
- ansible-runner to Python requirements (osism/container-image-osism-ansible#133)
- Receptor service for Ansible Runner worker (osism/container-image-osism-ansible#139)
- Validations script and ansible-collection-validations (osism/container-image-osism-ansible#148)
- Validate playbooks support in run-validate.sh (osism/container-image-osism-ansible#149)
- Interface volume and custom entrypoint script (osism/container-image-osism-ansible#150)
- ansible-base to Python requirements (osism/container-image-osism-ansible#151)
- Manual workflow triggering via workflow_dispatch (osism/container-image-osism-ansible#146)
- iputils-ping package to container image (osism/container-image-osism-ansible#155)
- stackhpc.cephadm Ansible collection (osism/container-image-osism-ansible#157)
- "Release container image" GitHub Actions workflow
- awxclient and nexus image definitions
- keycloak image definition
- homer image definition
- boundary image definition
- jq package to container image
- python-dotenv Python dependency
- Script to import the netbox-devicetype-library
- Release version handling for cephclient and openstackclient versions
- cfg-generics repository cloned during build for inventory files
- `run-custom.sh` script for running custom environment playbooks (osism/container-image-osism-ansible#195, osism/container-image-osism-ansible#196)
- `run-netbox.sh` script for running netbox playbooks (osism/container-image-osism-ansible#203, osism/container-image-osism-ansible#205)
- `change.sh` script for swapping OSISM collections during development (osism/container-image-osism-ansible#206)
- celery[redis] and hiredis dependencies (osism/container-image-osism-ansible#182, osism/container-image-osism-ansible#187)
- python-osism package installation (osism/container-image-osism-ansible#184, osism/container-image-osism-ansible#185)
- git-lfs package required by ansible-collection-services (osism/container-image-osism-ansible#191)
- `manager_version` to versions.yml and copy versions.yml to /interface (osism/container-image-osism-ansible#189)
- Templates directory from /playbooks to container (osism/container-image-osism-ansible#190)
- Requirements for the Ansible Junos collection (junos-eznc, jxmlease) (osism/container-image-osism-ansible#210)
- Local run script for Netbox (`run-netbox-local.sh`) and improved Netbox run script with inventory and config support (osism/container-image-osism-ansible#211)
- Docker images for alerta, dnsdist, keycloak, traefik, vault, zookeeper, and zuul components (osism/container-image-osism-ansible#213)
- Keycloak for Traefik image (osism/container-image-osism-ansible#214)
- Cgit image (osism/container-image-osism-ansible#215)
- Renovate configuration for automated dependency updates
- Inventory reconciler, osism, zuul client, and zuul nodepool builder images
- Patchman image (osism/container-image-osism-ansible#242)
- Open Policy Agent (docker_openpolicyagent) image
- Memcached image
- OpenStack health monitor image
- `procps` package for container health check support
- `pottery` Python dependency
- `IS_RELEASE` build argument to pull OSISM Ansible collections from Galaxy on release builds
- Support for ansible-pylibssh (`ssh_type = libssh`) (osism/container-image-osism-ansible#c365471)
- python-designateclient and neutron-dynamic-routing packages for zone and bgp OpenStack commands (osism/container-image-osism-ansible#253)
- Squid image to infrastructure images (osism/container-image-osism-ansible#263)
- SBOM generation in CI build and release workflows (osism/container-image-osism-ansible#271)
- Mitogen Ansible plugin (osism/container-image-osism-ansible#275)
- run-ceph.sh and run-kolla.sh scripts for running validation playbooks in corresponding environments (osism/container-image-osism-ansible#308)
- techno-tim/k3s-ansible roles for Kubernetes cluster management (osism/container-image-osism-ansible#312)
- Playbook rendering script to generate list of available playbooks (osism/container-image-osism-ansible#333)
- Symlink /etc/openstack to /opt/configuration/environments/openstack (osism/container-image-osism-ansible#343)
- flake8 Python syntax check via Zuul (osism/container-image-osism-ansible#346)
- ARA configuration file with default settings for labels, ignored facts, files, and arguments (osism/container-image-osism-ansible#361)
- Periodic-daily jobs in Zuul for better visibility of errors after linter updates (osism/container-image-osism-ansible#369)
- ansible-lint job to Zuul CI pipeline (osism/container-image-osism-ansible#389)
- ansible-vault.py script for retrieving encrypted Ansible Vault password from Redis (osism/container-image-osism-ansible#395)
- Cryptography-based decryption to ansible-vault.py script (osism/container-image-osism-ansible#397)
- json_stats callback plugin for outputting playbook summary stats in JSON format (osism/container-image-osism-ansible#402)
- `.yamllint.yml` max-line-length set to 100 (osism/container-image-osism-ansible#395)
- Support for `/inventory/ansible/ansible.cfg` configuration file (osism/container-image-osism-ansible#422)
- Zuul CI build and push jobs, replacing GitHub Actions workflows
- Missing k3s_reset role (osism/container-image-osism-ansible#417)
- Push job to the Zuul tag pipeline
- `change-osism.sh` script to install a different python-osism version in a running service (osism/container-image-osism-ansible#449)
- `change-playbooks.sh` script to update playbooks from a different branch (osism/container-image-osism-ansible#457)
- python-black job to Zuul CI pipeline (osism/container-image-osism-ansible#465)
- Support for openstack plays in render-playbooks.py (osism/container-image-osism-ansible#467)
- SPDX license identifiers to Python files (osism/container-image-osism-ansible#474)
- Kubernetes Python package required by kubernetes.core Ansible collection (osism/container-image-osism-ansible#477)
- run-kubernetes.sh script for the kubernetes environment (osism/container-image-osism-ansible#478)
- Helm installation (osism/container-image-osism-ansible#481)
- Helm chart repositories via add-helm-chart-repositories.py script (osism/container-image-osism-ansible#487)
- helm-diff plugin (osism/container-image-osism-ansible#503)
- /ansible/.kube/config symlink to /share/kubeconfig (osism/container-image-osism-ansible#491)
- clusterctl installation (osism/container-image-osism-ansible#500)
- kubectl installation (osism/container-image-osism-ansible#501)
- Support for rook playbooks (osism/container-image-osism-ansible#510)
- Support for proxmox playbooks (osism/container-image-osism-ansible#511)
- Environment existence checks in run scripts (osism/container-image-osism-ansible#512)
- Mitogen Ansible plugin re-added (osism/container-image-osism-ansible#521, osism/container-image-osism-ansible#522)
- Tempest image (osism/container-image-osism-ansible#523)
- openstack-database-exporter image (osism/container-image-osism-ansible#524)
- Support for kolla plays in osism/ansible-playbooks (osism/container-image-osism-ansible#525)
- Playbook symlink generation script (osism/container-image-osism-ansible#532, osism/container-image-osism-ansible#533, osism/container-image-osism-ansible#534, osism/container-image-osism-ansible#537)
- Symlink generation for kubernetes plays (osism/container-image-osism-ansible#541)
- Support for kubernetes plays in the OSISM CLI (osism/container-image-osism-ansible#544)
- Configuration repository lock checking (global and per-environment) (osism/container-image-osism-ansible#546, osism/container-image-osism-ansible#547)
- k3s_custom_registries role from k3s-ansible (osism/container-image-osism-ansible#564)
- Cilium CLI installation in container image (osism/container-image-osism-ansible#566)
- SBOM generation and push to DependencyTrack in Zuul CI pipeline (osism/container-image-osism-ansible#529)
- Patch for kube-vip BGP support in k3s_server role (osism/container-image-osism-ansible#568)
- Patch support for roles in /ansible/roles/ directory (osism/container-image-osism-ansible#567)
- Missing comments in Containerfile (osism/container-image-osism-ansible#563)
- kolla_container and kolla_toolbox Ansible modules (osism/container-image-osism-ansible#610)
- k3s_server_post patch to fix ownership of files within ansible runtime (osism/container-image-osism-ansible#596)
- `ipaddrs_in_ranges` Ansible filter plugin (from ceph/ceph-ansible) (osism/container-image-osism-ansible#641)

### Changed
- Replace vim with vim-tiny to reduce image size (osism/container-image-osism-ansible#13)
- Use latest openstackclient/cephclient images without repository version suffix (osism/container-image-osism-ansible#19)
- Use tar without verbose flag in Dockerfile (osism/container-image-osism-ansible#8)
- Prometheus images marked as deprecated (osism/container-image-osism-ansible#20)
- Base image upgraded from Ubuntu 18.04 to 20.04 (Focal) (osism/container-image-osism-ansible#25)
- Documentation URL changed to docs.osism.de (osism/container-image-osism-ansible#27)
- Travis CI configured to only push master branch and tags (osism/container-image-osism-ansible#30, osism/container-image-osism-ansible#31, osism/container-image-osism-ansible#32)
- Switched to debops.debops Ansible collection (osism/container-image-osism-ansible#35)
- Renamed osism.network-interfaces role to osism.network (osism/container-image-osism-ansible#37)
- Enabled Docker BuildKit for builds (osism/container-image-osism-ansible#39)
- Moved tests, validations, and netbox devicetype library to /opt (osism/container-image-osism-ansible#50)
- Moved group_vars to osism-ansible repository (osism/container-image-osism-ansible#53)
- Moved inventory directory to /ansible and updated all run scripts (osism/container-image-osism-ansible#57, osism/container-image-osism-ansible#58)
- Cleaned up mitogen directory by removing tests, docs, and CI files (osism/container-image-osism-ansible#34)
- Use ansible-galaxy to install collections from Git instead of manual git clone (osism/container-image-osism-ansible#79)
- Use upstream Docker images instead of osism-specific ones in images.yml (osism/container-image-osism-ansible#88)
- Rename manager image to awx (osism/container-image-osism-ansible#89)
- Rename repository from docker-osism-ansible to docker-image-osism-ansible (osism/container-image-osism-ansible#86)
- Resolve hadolint linting issues in Dockerfile (osism/container-image-osism-ansible#80)
- Rename and cleanup GitHub Actions workflows (osism/container-image-osism-ansible#82)
- Remove deprecated Docker images (prometheus exporters, alertmanager, etc) from images.yml (osism/container-image-osism-ansible#87)
- README cleanup (osism/container-image-osism-ansible#84)
- Switch Docker builds to use `docker buildx build` with `--load` flag (osism/container-image-osism-ansible#98, osism/container-image-osism-ansible#99)
- Use `ansible-playbooks` repository instead of `osism-ansible` (osism/container-image-osism-ansible#112)
- Rebuild the image every hour (8-22) instead of once daily (osism/container-image-osism-ansible#113)
- Trigger CI rebuild for changes in `scripts/` directory (osism/container-image-osism-ansible#100)
- Move plugins to `/usr/share/ansible/plugins` for proper Ansible discovery (osism/container-image-osism-ansible#117)
- Move inventory files to `inventory.generics` directory to separate from configuration inventory (osism/container-image-osism-ansible#124)
- Use `ENV name=value` syntax in Dockerfile (osism/container-image-osism-ansible#109)
- Rename `.placeholder` files to `.gitkeep` (osism/container-image-osism-ansible#106)
- Move hadolint configuration to `.hadolint.yaml` and switch to `brpaz/hadolint-action` (osism/container-image-osism-ansible#107)
- Move yamllint configuration to `.yamllint.yml` (osism/container-image-osism-ansible#108)
- Install `community.zabbix` collection from Git for Zabbix 5.2 compatibility (osism/container-image-osism-ansible#115)
- Keep `/src` directory in final image for runtime scripts (osism/container-image-osism-ansible#121)
- Upgrade pip during Docker build (osism/container-image-osism-ansible#118)
- Renamed Dockerfile to Containerfile (osism/container-image-osism-ansible#131)
- Updated CI workflows to reference Containerfile (osism/container-image-osism-ansible#136)
- Renamed repository from docker-image-osism-ansible to container-image-osism-ansible (osism/container-image-osism-ansible#134)
- Set default VERSION build arg to latest (osism/container-image-osism-ansible#135)
- Build script uses full commit SHA for image tagging (osism/container-image-osism-ansible#130)
- Inventory synchronization only runs if /ansible/inventory is writable (osism/container-image-osism-ansible#138)
- Netbox inventory file only removed if /ansible/inventory is writable (osism/container-image-osism-ansible#143)
- Use ansible-defaults repository for group_vars instead of ansible-playbooks (osism/container-image-osism-ansible#144)
- Vendor label from "Betacloud Solutions GmbH" to "OSISM GmbH" (osism/container-image-osism-ansible#156)
- Ansible collections are now dynamically sourced from the release repository instead of being hardcoded
- Major refactoring for release 1.0.0 preparations (pinned build dependencies, restructured playbooks and defaults checkout)
- Container build tooling from Docker/buildx to buildah
- Default branch reference from master to main
- Documentation and URL labels updated to osism.tech domain
- Internal image tagging to use short commit hash
- Improved handling of Ansible version pinning in requirements template
- CI workflows renamed from "docker image" to "container image"
- Inventory files now copied from cloned generics repo instead of downloaded via ADD
- Run scripts now check for custom playbooks in the environment before falling back to built-in playbooks (osism/container-image-osism-ansible#208)
- Infrastructure environment now depends on monitoring environment configuration (osism/container-image-osism-ansible#207)
- Ignore ansible.cfg in the manager environment during container runs (osism/container-image-osism-ansible#198)
- Use `docker_registry_nexus` for nexus image registry (osism/container-image-osism-ansible#192)
- Use `docker_registry_netbox` for netbox image registry (osism/container-image-osism-ansible#197)
- Modify kolla_address filter to gracefully handle missing hostvars and interfaces (osism/container-image-osism-ansible#190)
- Improve netbox-import script with configurable base path and secret file support (osism/container-image-osism-ansible#199, osism/container-image-osism-ansible#201, osism/container-image-osism-ansible#202)
- GitHub CI: push images only when running in upstream repository (osism/container-image-osism-ansible#186)
- GitHub CI: run branch builds on main only (osism/container-image-osism-ansible#200)
- Add missing `--no-cache-dir` to pip install for python-osism (osism/container-image-osism-ansible#193)
- Use `$ENVIRONMENT` and `$service` variables correctly in run scripts (osism/container-image-osism-ansible#209)
- Make `change.sh` usable with all OSISM collections instead of only services (osism/container-image-osism-ansible#230)
- Pin all versions in `requirements.txt.j2` (osism/container-image-osism-ansible#226)
- Push release images to `osism/release` path
- Fix requirements.yml template to iterate over dict keys and remove debops dependency
- Fix Zuul image registry references to use unified `docker_registry_zuul`
- Adjust playbook copy to use recursive flag after transition (osism/container-image-osism-ansible#243)
- Switch base image from Ubuntu 20.04 to Python 3.10-slim (osism/container-image-osism-ansible#248)
- Squash container image during build (osism/container-image-osism-ansible#249)
- Renovate config to use `github>osism/renovate-config:python` preset (osism/container-image-osism-ansible#a82a65c)
- Scripts to use new playbook subdirectory structure (e.g. `generic/facts.yml` instead of `generic-facts.yml`) (osism/container-image-osism-ansible#245)
- Stop installing Python packages from Ubuntu to avoid Python 3.9/3.10 version conflicts (osism/container-image-osism-ansible#252)
- Infrastructure image variables to include service prefix to avoid conflicts with Kolla (osism/container-image-osism-ansible#fc389fe)
- Sync `address.py` filter plugin with kolla-ansible upstream, including rabbitmq context support (osism/container-image-osism-ansible#270)
- Use mitogen master branch for Ansible 2.13 support (osism/container-image-osism-ansible#276)
- Set version in SPDX filename in release workflow (osism/container-image-osism-ansible#274)
- Install osism from PyPI instead of cloning the repository (osism/container-image-osism-ansible#279)
- Base image from Python 3.10-slim to Python 3.11-slim (osism/container-image-osism-ansible#259)
- Revert to Python 3.10-slim base image due to OpenStack SDK incompatibility with Python 3.11 (osism/container-image-osism-ansible#304)
- Use ansible-core instead of ansible (osism/container-image-osism-ansible#326)
- Ensure only ansible-core is installed, not the full ansible package (osism/container-image-osism-ansible#335)
- Move k3s master/node/post roles into the correct directory structure (osism/container-image-osism-ansible#315)
- Fix play names for network and operator to use manager- prefix (osism/container-image-osism-ansible#334)
- Hide common role from playbook list (osism/container-image-osism-ansible#336)
- Allow environment variable overwrites in all run scripts (osism/container-image-osism-ansible#351)
- Migrate yamllint and hadolint checks from GitHub Actions to Zuul (osism/container-image-osism-ansible#344, osism/container-image-osism-ansible#348)
- ARA environment setup to use a static base config file with appended dynamic values (osism/container-image-osism-ansible#361)
- Inventory path from directory to `hosts.yml` file across all run scripts (osism/container-image-osism-ansible#388)
- osism package version now sourced from osism/release instead of being pinned (osism/container-image-osism-ansible#379)
- python-openstackclient unpinned to avoid conflicts with OpenStack SDK in the osism package (osism/container-image-osism-ansible#381)
- Ansible installation logic to use `ansible` instead of `ansible-core` for version 4.3.0 (osism/container-image-osism-ansible#380)
- Base Docker image from python:3.10-slim to python:3.11-slim (osism/container-image-osism-ansible#359)
- Refactored Containerfile to use heredocs for better readability (osism/container-image-osism-ansible#412)
- Refactored hadolint rules with explanations for skipped rules (osism/container-image-osism-ansible#409)
- Moved k3s roles to /ansible/roles with individual role directories (osism/container-image-osism-ansible#414)
- Switched from osism/ansible-defaults to osism/defaults repository (osism/container-image-osism-ansible#421)
- Replaced IS_RELEASE build argument with version-based check for collection installs
- Show push logs in Zuul CI (osism/container-image-osism-ansible#418)
- Use `COPY --link` in Containerfile for better layer caching (osism/container-image-osism-ansible#444)
- Use multi-stage build in Containerfile (osism/container-image-osism-ansible#445)
- Autoformat Python code with black (osism/container-image-osism-ansible#446)
- Keep the release repository in the container image (osism/container-image-osism-ansible#448)
- Update Python base image from 3.11 to 3.12 (osism/container-image-osism-ansible#432)
- Add `set -e` to all run scripts (osism/container-image-osism-ansible#461)
- Use osism.github.io as documentation URL (osism/container-image-osism-ansible#463)
- List missing ceph plays in render-playbooks.py (osism/container-image-osism-ansible#466)
- Use Debian Bookworm as base image (osism/container-image-osism-ansible#470)
- Zuul: allow local builds by adding default values for build variables
- Zuul: add periodic midnight build
- Zuul: add semaphore for push job (osism/container-image-osism-ansible#495)
- Zuul: make use in other repositories possible (osism/container-image-osism-ansible#496)
- Zuul: add abstract push job without secret (osism/container-image-osism-ansible#497)
- Zuul: add missing pass-to-parent (osism/container-image-osism-ansible#498)
- Zuul: fix revision in external repositories (osism/container-image-osism-ansible#499)
- Add all inventory files with a single command instead of individual copies (osism/container-image-osism-ansible#494)
- Only add helm chart repositories without pulling charts (osism/container-image-osism-ansible#489)
- Merge change-osism.sh and change-playbooks.sh into unified change.sh script (osism/container-image-osism-ansible#505)
- Relabel container image with updated documentation and URL (osism/container-image-osism-ansible#509)
- Ignore DL3003 hadolint rule globally (osism/container-image-osism-ansible#492)
- Remove all pycache directories and pyc files during build (osism/container-image-osism-ansible#472)
- Remove useless newline in Containerfile (osism/container-image-osism-ansible#480)
- Documentation URL updated from osism.github.io to osism.tech (osism/container-image-osism-ansible#514)
- Use pip instead of pip3 (osism/container-image-osism-ansible#542)
- Use pyclean 3.0.0 (osism/container-image-osism-ansible#530)
- Renamed `user_list` to `hardening_user_list` in ansible-hardening role to avoid conflict with osism.commons.user role (osism/container-image-osism-ansible#551)
- Bumped kubectl 1.29.1 → 1.30.2 and clusterctl 1.6.1 → 1.7.4 (osism/container-image-osism-ansible#559, osism/container-image-osism-ansible#573)
- Bumped Cilium CLI to v0.16.15 (osism/container-image-osism-ansible#573)
- Suppressed Python UserWarnings to eliminate CryptographyDeprecationWarning (osism/container-image-osism-ansible#562)
- Patched k3s_server_post to not install Cilium CLI and delegate tasks to localhost (osism/container-image-osism-ansible#567, osism/container-image-osism-ansible#575)
- Patched k3s_server_post metallb tasks to use kubectl instead of k3s kubectl (osism/container-image-osism-ansible#574, osism/container-image-osism-ansible#575)
- Update k3s_server_post patches, replace metallb patch with localhost delegation variant (osism/container-image-osism-ansible#584)
- Bump CAPI to 1.7.5, Cilium CLI to v0.16.16, and kubectl to 1.30.4 (osism/container-image-osism-ansible#588)
- Skip plays starting with underscore in playbook symlink generation (osism/container-image-osism-ansible#599)
- Upgrade base image from Python 3.12 to Python 3.13 (osism/container-image-osism-ansible#597)
- Improve hadolint configuration with wiki links for ignored rules (osism/container-image-osism-ansible#608)
- Use uv instead of pip for Python package installation (osism/container-image-osism-ansible#635)
- Switch k3s-ansible source from techno-tim/k3s-ansible to osism/k3s-ansible (osism/container-image-osism-ansible#631)
- Use dtrack.osism.tech instead of osism.dtrack.regio.digital (osism/container-image-osism-ansible#623)
- Only checkout specific tags when not building latest (osism/container-image-osism-ansible#642)
- Always use main branch of own collections when building latest (osism/container-image-osism-ansible#643)
- Decouple the image build from the old OSISM X.Y.Z release scheme (osism/container-image-osism-ansible#645)

### Fixed
- Fix debops role names to match updated directory structure (osism/container-image-osism-ansible#16)
- Keep requirements.txt after build as it is required by osism/manager image (osism/container-image-osism-ansible#15)
- Paths to Ansible requirement files (osism/container-image-osism-ansible#36)
- secrets.sh error when NETBOX_TOKEN file does not exist (osism/container-image-osism-ansible#66)
- Repository name in GitHub Actions workflows (osism/container-image-osism-ansible#74)
- YAML document start warning in pr-labeler workflow (osism/container-image-osism-ansible#75)
- Typo "exportes" → "exports" in Dockerfile comment (osism/container-image-osism-ansible#76)
- yamllint issues in GitHub Actions workflows (osism/container-image-osism-ansible#83)
- manager_version rendering in images.yml template (osism/container-image-osism-ansible#91)
- Wrong registry variable (docker_postgres → docker_registry) for postgres image (osism/container-image-osism-ansible#93)
- Wrong registry for awx image (osism/container-image-osism-ansible#92)
- Missing versions in rendered images.yml file (osism/container-image-osism-ansible#90)
- Correct docker registry variables for ara_server, cephclient, and openstackclient images (osism/container-image-osism-ansible#110)
- Fix kolla_address filter plugin by merging into single file with proper `FilterModule` class (osism/container-image-osism-ansible#117)
- Fix typo in inventory merge path (`ansilble` → `ansible`) (osism/container-image-osism-ansible#123)
- Fix wrong indentation in `handle-inventory-overwrite.py` (osism/container-image-osism-ansible#125)
- Handle `:children` sections correctly in inventory overwrite script (osism/container-image-osism-ansible#126)
- Receptor configuration with proper node ID, TCP listener and peer settings (osism/container-image-osism-ansible#140)
- disable-auditd-tasks.patch to match updated line numbers (osism/container-image-osism-ansible#152)
- Patch handling to use correct paths with basename (osism/container-image-osism-ansible#153)
- Hadolint warning DL3046 by adding `-l` flag to useradd (osism/container-image-osism-ansible#154)
- Missing quotes in versions.yml template
- Homer image registry to use docker_registry_homer
- Fix missing playbooks directory in Netbox run script (osism/container-image-osism-ansible#212)
- Restore `/usr/bin/python` and `/usr/bin/python3` symlinks lost during Python package cleanup (osism/container-image-osism-ansible#dd3ed0a)
- Replace neutron-dynamic-routing with python-neutronclient for openstack bgp commands (osism/container-image-osism-ansible#262)
- Add missing short revision ID step in release workflow for SBOM generation (osism/container-image-osism-ansible#273)
- Removed gcc-9-base from cleanup step to fix "Unable to locate package" error (osism/container-image-osism-ansible#399)
- Decoded ansible_vault_password bytes to UTF-8 string before printing (osism/container-image-osism-ansible#396)
- Fix flake8 issues in Python files (osism/container-image-osism-ansible#435)
- Fix location of the netbox environment directory check (osism/container-image-osism-ansible#513)
- Fixed FromAsCasing in Containerfile (osism/container-image-osism-ansible#558)
- Fixed k3s patches for upstream compatibility (osism/container-image-osism-ansible#575)
- Fixed DependencyTrack API key and SBOM integration in Zuul pipeline (osism/container-image-osism-ansible#576, osism/container-image-osism-ansible#577, osism/container-image-osism-ansible#578, osism/container-image-osism-ansible#579, osism/container-image-osism-ansible#580, osism/container-image-osism-ansible#581, osism/container-image-osism-ansible#582)
- Copy playbooks to the right place in the change.sh script (osism/container-image-osism-ansible#508)
- Fix wrong path to the inventory directory in run scripts (osism/container-image-osism-ansible#611)
- Use correct ansible.cfg file in run-manager.sh (osism/container-image-osism-ansible#615)

### Removed
- ara database configuration from ansible.cfg (osism/container-image-osism-ansible#4)
- git package from final image to reduce size (osism/container-image-osism-ansible#5)
- License note from README (osism/container-image-osism-ansible#28)
- Trademark note from README (osism/container-image-osism-ansible#29)
- qemu-utils package (osism/container-image-osism-ansible#61)
- gcc-9-base package from final image (osism/container-image-osism-ansible#60)
- Travis CI configuration and Trivy security scanning (osism/container-image-osism-ansible#70, osism/container-image-osism-ansible#72)
- Travis-related scripts (travis.sh, lint.sh, security.sh), gilt.yml, and sync-with-master-repository workflow (osism/container-image-osism-ansible#72)
- Unused `.gitignore` file (osism/container-image-osism-ansible#94)
- Mitogen 0.2.9 plugin due to missing Ansible 2.10 support (osism/container-image-osism-ansible#95)
- Aptly and installer images (osism/container-image-osism-ansible#105)
- Validations repository (osism/container-image-osism-ansible#119)
- Tests repository from container build (osism/container-image-osism-ansible#137)
- Trivy vulnerability scanner from CI, images now scanned on Harbor (osism/container-image-osism-ansible#141)
- PR Labeler workflow (osism/container-image-osism-ansible#147)
- Netbox inventory plugin handling and `99-netbox.yml` configuration (osism/container-image-osism-ansible#181)
- Netbox device type library and import script from container (moved to python-osism) (osism/container-image-osism-ansible#204)
- AWX and AWX client images
- Boundary image
- Rsync-based inventory reconciliation from all scripts, now handled by the inventory reconciler service (osism/container-image-osism-ansible#246)
- vim-tiny from container image (osism/container-image-osism-ansible#317)
- python-libmaas package (osism/container-image-osism-ansible#313)
- zabbix-api, junos-eznc, and proxmoxer requirements (osism/container-image-osism-ansible#316)
- ansible-runner, celery[redis], hiredis, pynetbox, and shade from Python requirements (osism/container-image-osism-ansible#331)
- ansible-modules-hashivault from Python requirements (osism/container-image-osism-ansible#335)
- Login warning banner copy from hardening role in favor of osism.commons.motd (osism/container-image-osism-ansible#323)
- /playbooks/tasks copy step from build (osism/container-image-osism-ansible#327)
- redis from requirements as it is a dependency of osism (osism/container-image-osism-ansible#403)
- Receptor integration in favor of Redis for work distribution (osism/container-image-osism-ansible#406)
- Mitogen plugin, no longer compatible with current Ansible versions (osism/container-image-osism-ansible#431)
- GitHub Actions build and release container image workflows
- DL3059 from hadolint ignore list (osism/container-image-osism-ansible#415)
- json_stats Ansible callback plugin (osism/container-image-osism-ansible#458, osism/container-image-osism-ansible#462)
- ruamel.yaml dependency (osism/container-image-osism-ansible#452)
- git-lfs from container image (osism/container-image-osism-ansible#486)
- Release notes (now managed centrally in osism/release) (osism/container-image-osism-ansible#540)
- repository_version from versions template and render script
- ansible-base from Python requirements
- Hardcoded Ansible collection definitions in requirements template
- Container image OCI labels from Containerfile (moved to build script)
- k3s_server/kube-vip-bgp.patch after merge upstream (osism/container-image-osism-ansible#570)
- Keycloak image references (osism/container-image-osism-ansible#616)
- Kubernetes-related tools and files, moved to osism-kubernetes (osism/container-image-osism-ansible#636)
- k3s roles, moved to osism-kubernetes (osism/container-image-osism-ansible#637)
- Rook-related tools and files, moved to osism-kubernetes (osism/container-image-osism-ansible#639)

### Dependencies
- mitogen 0.2.8 → 0.2.9 → removed → re-added → 0.3.7 → 0.3.22 (osism/container-image-osism-ansible#23, osism/container-image-osism-ansible#276, osism/container-image-osism-ansible#583, osism/container-image-osism-ansible#601, osism/container-image-osism-ansible#621, osism/container-image-osism-ansible#632)
- zabbix-api added (osism/container-image-osism-ansible#26)
- hvac added, 0.11.2 → 2.3.0 (osism/container-image-osism-ansible#47, osism/container-image-osism-ansible#401, osism/container-image-osism-ansible#426, osism/container-image-osism-ansible#427, osism/container-image-osism-ansible#440, osism/container-image-osism-ansible#471, osism/container-image-osism-ansible#520, osism/container-image-osism-ansible#552)
- pynetbox added (osism/container-image-osism-ansible#48)
- ansible-modules-hashivault added (osism/container-image-osism-ansible#51)
- openstack.cloud Ansible collection added (osism/container-image-osism-ansible#43)
- community.zabbix Ansible collection added (osism/container-image-osism-ansible#44)
- awx.awx Ansible collection added (osism/container-image-osism-ansible#45)
- netbox.netbox Ansible collection added (osism/container-image-osism-ansible#46)
- netbox devicetype library added (osism/container-image-osism-ansible#49)
- openstacksdk pinned to 0.52, then 0.52 → 1.1.0 (osism/container-image-osism-ansible#128, osism/container-image-osism-ansible#224, osism/container-image-osism-ansible#329)
- ansible-runner 2.1.2 → 2.1.3 (osism/container-image-osism-ansible#236)
- asn1crypto 1.4.0 → 1.5.1 (osism/container-image-osism-ansible#228, osism/container-image-osism-ansible#233)
- celery[redis] 5.2.0 → 5.2.7 (osism/container-image-osism-ansible#216, osism/container-image-osism-ansible#247, osism/container-image-osism-ansible#251, osism/container-image-osism-ansible#286)
- cryptography 36.0.1 → 44.0.2 (osism/container-image-osism-ansible#234, osism/container-image-osism-ansible#311, osism/container-image-osism-ansible#394, osism/container-image-osism-ansible#408, osism/container-image-osism-ansible#423, osism/container-image-osism-ansible#429, osism/container-image-osism-ansible#443, osism/container-image-osism-ansible#456, osism/container-image-osism-ansible#504, osism/container-image-osism-ansible#526, osism/container-image-osism-ansible#528, osism/container-image-osism-ansible#548, osism/container-image-osism-ansible#561, osism/container-image-osism-ansible#587, osism/container-image-osism-ansible#600, osism/container-image-osism-ansible#606, osism/container-image-osism-ansible#625, osism/container-image-osism-ansible#628)
- jinja2 3.0.1 → 3.1.6 (osism/container-image-osism-ansible#217, osism/container-image-osism-ansible#238, osism/container-image-osism-ansible#475, osism/container-image-osism-ansible#527, osism/container-image-osism-ansible#614, osism/container-image-osism-ansible#630)
- paramiko 2.9.2 → 3.5.1 (osism/container-image-osism-ansible#229, osism/container-image-osism-ansible#232, osism/container-image-osism-ansible#235, osism/container-image-osism-ansible#298, osism/container-image-osism-ansible#324, osism/container-image-osism-ansible#392, osism/container-image-osism-ansible#419, osism/container-image-osism-ansible#420, osism/container-image-osism-ansible#469, osism/container-image-osism-ansible#572, osism/container-image-osism-ansible#593, osism/container-image-osism-ansible#622)
- pip 21.1.3 → 25.0.1 (osism/container-image-osism-ansible#241, osism/container-image-osism-ansible#254, osism/container-image-osism-ansible#255, osism/container-image-osism-ansible#256, osism/container-image-osism-ansible#266, osism/container-image-osism-ansible#268, osism/container-image-osism-ansible#269, osism/container-image-osism-ansible#277, osism/container-image-osism-ansible#280, osism/container-image-osism-ansible#328, osism/container-image-osism-ansible#342, osism/container-image-osism-ansible#375, osism/container-image-osism-ansible#410, osism/container-image-osism-ansible#416, osism/container-image-osism-ansible#436, osism/container-image-osism-ansible#441, osism/container-image-osism-ansible#490, osism/container-image-osism-ansible#553, osism/container-image-osism-ansible#554, osism/container-image-osism-ansible#560, osism/container-image-osism-ansible#565, osism/container-image-osism-ansible#604, osism/container-image-osism-ansible#620, osism/container-image-osism-ansible#624)
- pottery 2.3.6 → 3.0.1 (osism/container-image-osism-ansible#221, osism/container-image-osism-ansible#633)
- proxmoxer 1.2.0 → 1.3.0, then re-added at 2.0.1 → 2.2.0 (osism/container-image-osism-ansible#231, osism/container-image-osism-ansible#511, osism/container-image-osism-ansible#571, osism/container-image-osism-ansible#609)
- python-dotenv 0.19.2 → 1.1.0 (osism/container-image-osism-ansible#239, osism/container-image-osism-ansible#299, osism/container-image-osism-ansible#325, osism/container-image-osism-ansible#349, osism/container-image-osism-ansible#483, osism/container-image-osism-ansible#634)
- python-openstackclient 5.7.0 → 6.2.0 (osism/container-image-osism-ansible#227, osism/container-image-osism-ansible#314, osism/container-image-osism-ansible#358)
- pyyaml 5.4.1 → 6.0.2 (osism/container-image-osism-ansible#222, osism/container-image-osism-ansible#411, osism/container-image-osism-ansible#569)
- redis 4.1.4 → 4.5.5 (osism/container-image-osism-ansible#237, osism/container-image-osism-ansible#244, osism/container-image-osism-ansible#250, osism/container-image-osism-ansible#300, osism/container-image-osism-ansible#321, osism/container-image-osism-ansible#337, osism/container-image-osism-ansible#338, osism/container-image-osism-ansible#385)
- yq 2.12.2 → 3.4.3 (osism/container-image-osism-ansible#225, osism/container-image-osism-ansible#261, osism/container-image-osism-ansible#267, osism/container-image-osism-ansible#347, osism/container-image-osism-ansible#374, osism/container-image-osism-ansible#516, osism/container-image-osism-ansible#517, osism/container-image-osism-ansible#518, osism/container-image-osism-ansible#519)
- actions/checkout v2 → v3 (osism/container-image-osism-ansible#219)
- actions/setup-python v2 → v4 (osism/container-image-osism-ansible#220, osism/container-image-osism-ansible#257)
- brpaz/hadolint-action v1.2.1 → v1.5.0 (osism/container-image-osism-ansible#223)
- python-designateclient 4.5.0 → 6.2.0 (osism/container-image-osism-ansible#260, osism/container-image-osism-ansible#264, osism/container-image-osism-ansible#281, osism/container-image-osism-ansible#340, osism/container-image-osism-ansible#424, osism/container-image-osism-ansible#507, osism/container-image-osism-ansible#586, osism/container-image-osism-ansible#627)
- python-neutronclient 7.8.0 → 11.4.0 (osism/container-image-osism-ansible#265, osism/container-image-osism-ansible#272, osism/container-image-osism-ansible#282, osism/container-image-osism-ansible#320, osism/container-image-osism-ansible#341, osism/container-image-osism-ansible#387, osism/container-image-osism-ansible#407, osism/container-image-osism-ansible#453, osism/container-image-osism-ansible#506, osism/container-image-osism-ansible#531, osism/container-image-osism-ansible#556, osism/container-image-osism-ansible#618)
- osism 0.7.0 → 0.20230501.0 (osism/container-image-osism-ansible#284, osism/container-image-osism-ansible#285, osism/container-image-osism-ansible#319, osism/container-image-osism-ansible#332, osism/container-image-osism-ansible#339, osism/container-image-osism-ansible#350, osism/container-image-osism-ansible#352, osism/container-image-osism-ansible#353, osism/container-image-osism-ansible#378)
- pynetbox 6.6.1 → 6.6.2 (osism/container-image-osism-ansible#289)
- ansible-pylibssh 0.3.0 → 1.2.2 (osism/container-image-osism-ansible#293, osism/container-image-osism-ansible#305, osism/container-image-osism-ansible#550, osism/container-image-osism-ansible#555)
- hiredis 2.0.0 → 2.1.0 (osism/container-image-osism-ansible#295)
- ansible-modules-hashivault 4.6.8 → 4.7.1 (osism/container-image-osism-ansible#292)
- requests 2.27.1 → 2.32.3 (osism/container-image-osism-ansible#302, osism/container-image-osism-ansible#322, osism/container-image-osism-ansible#390, osism/container-image-osism-ansible#535, osism/container-image-osism-ansible#536, osism/container-image-osism-ansible#539, osism/container-image-osism-ansible#545)
- idna 3.3 → 3.10 (osism/container-image-osism-ansible#296, osism/container-image-osism-ansible#454, osism/container-image-osism-ansible#455, osism/container-image-osism-ansible#515, osism/container-image-osism-ansible#585, osism/container-image-osism-ansible#591, osism/container-image-osism-ansible#592)
- pymysql 1.0.2 → 1.1.1 (osism/container-image-osism-ansible#404, osism/container-image-osism-ansible#538)
- ruamel.yaml 0.17.21 → 0.17.35 (osism/container-image-osism-ansible#400, osism/container-image-osism-ansible#430, osism/container-image-osism-ansible#433, osism/container-image-osism-ansible#434)
- kubernetes 29.0.0 → 32.0.1 (osism/container-image-osism-ansible#477, osism/container-image-osism-ansible#549, osism/container-image-osism-ansible#595, osism/container-image-osism-ansible#619, osism/container-image-osism-ansible#626)
- ghcr.io/astral-sh/uv 0.6.10 → 0.6.13 (osism/container-image-osism-ansible#638, osism/container-image-osism-ansible#640, osism/container-image-osism-ansible#644)

