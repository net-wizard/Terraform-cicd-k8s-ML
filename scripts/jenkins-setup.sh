#!/bin/bash
set -e   # exit on any error
set -x   # print each command (for debugging)
export DEBIAN_FRONTEND=noninteractive

# ── SECTION 1: System Setup ────────────────────────
# update, upgrade, install basics
sudo apt update
sudo apt upgrade -y

# ── SECTION 2: Docker ──────────────────────────────
# install, start, enable, add ubuntu to docker group
sudo apt install ca-certificates curl -y
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $$(. /etc/os-release && echo "$${UBUNTU_CODENAME:-$$VERSION_CODENAME}")
Components: stable
Architectures: $$(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
sudo systemctl restart docker
sudo systemctl enable docker
sudo usermod -aG docker ubuntu

# ── SECTION 3: Ansible ─────────────────────────────
# install ansible
sudo apt install software-properties-common -y
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt update
sudo apt install ansible -y

# ── SECTION 4: kubectl ─────────────────────────────
# download, install, verify
curl -LO "https://dl.k8s.io/release/$$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/$$(dpkg --print-architecture)/kubectl"
sudo install -m  0755 kubectl /usr/local/bin
rm kubectl


# ── SECTION 5: Jenkins Container ───────────────────
# run with correct GID, volume, socket
GITHUB_TOKEN=$$(aws secretsmanager get-secret-value --region ${region} --secret-id /retailrec/github-token --query SecretString --output text)
aws ecr get-login-password --region ${region} | docker login --username AWS --password-stdin ${ecr_jenkins_url}
DOCKER_GID=$$(getent group docker | cut -d: -f3)
docker run \
-d \
--name jenkins \
-e CASC_JENKINS_CONFIG="/var/jenkins_home/casc_configs/jenkins.yaml" \
-e GITHUB_TOKEN=$$GITHUB_TOKEN \
--group-add $$DOCKER_GID \
-p 8080:8080 \
-p 50000:50000 \
-v jenkins_home:/var/jenkins_home \
-v /var/run/docker.sock:/var/run/docker.sock \
${ecr_jenkins_url}:latest
until docker exec jenkins curl -s http://localhost:8080; do
    echo "Waiting for jenkins container to run"
    sleep 10s
done

# ── SECTION 6: Jenkins Configuration as Code ───────
# install JCasC plugin, fetch config from S3
sleep 30s # Even after jenkins is start responding from port 8080, Jenkins still need to initialise internal plugins and be ready to docker excec command and setup CASC config loacation
git clone https://github.com/net-wizard/Terraform-cicd-k8s-ML.git /opt/retailrec
cd /opt/retailrec
docker exec jenkins mkdir -p /var/jenkins_home/casc_configs
docker cp /opt/retailrec/jenkins/jenkins.yaml jenkins:/var/jenkins_home/casc_configs/jenkins.yaml
docker restart jenkins