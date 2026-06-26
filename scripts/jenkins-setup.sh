# scripts/jenkins-setup.sh

#!/bin/bash
set -e   # exit on any error
set -x   # print each command (for debugging)

# ── SECTION 1: System Setup ────────────────────────
# update, upgrade, install basics
sudo apt update
sudo apt upgrade -y

# ── SECTION 2: Docker ──────────────────────────────
# install, start, enable, add ubuntu to docker group

# ── SECTION 3: Ansible ─────────────────────────────
# install ansible

# ── SECTION 4: kubectl ─────────────────────────────
# download, install, verify

# ── SECTION 5: Jenkins Container ───────────────────
# run with correct GID, volume, socket

# ── SECTION 6: Jenkins Docker CLI ──────────────────
# wait for Jenkins to start, copy docker binary

# ── SECTION 7: Jenkins Configuration as Code ───────
# install JCasC plugin, fetch config from S3
jenkins-plugin-cli --plugin-file plugins.txt