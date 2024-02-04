#!/bin/zsh

### .dot
# shellcheck disable=SC2139
alias .dot="git --git-dir ${HOME}/.environment/.git/ --work-tree ${HOME}"
.dot config --local status.showUntrackedFiles no

### AWS Cli
type -p unzip >/dev/null || (sudo apt-get install -y unzip)
type -p aws >/dev/null || (
  AWS_TEMP_DIR="${HOME}/.aws-temp";
  mkdir "${AWS_TEMP_DIR}";
  cd "${AWS_TEMP_DIR}" || exit 1;
  curl 'https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip' -o 'awscliv2.zip' \
  && unzip 'awscliv2.zip' \
  && sudo ./aws/install || exit 1;
  cd "${ENVIRONMENT_BOOTSTRAP_ROOT}" || exit 1;
  rm -rf "${AWS_TEMP_DIR}";
) || exit 1

### Common step...
if [ ! -d '/etc/apt/keyrings' ]; then
  sudo mkdir -p -m 755 '/etc/apt/keyrings'
fi

dpkg -L apt-transport-https >/dev/null || sudo apt-get install -y apt-transport-https
dpkg -L ca-certificates >/dev/null || sudo apt-get install -y ca-certificates

### Kubectl, Krew && Stern
type -p kubectl >/dev/null || (
  curl -fsSL 'https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key' | sudo gpg --dearmor -o '/etc/apt/keyrings/kubernetes-apt-keyring.gpg';
  echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | sudo tee '/etc/apt/sources.list.d/kubernetes.list';
  sudo apt update && sudo apt-get install -y kubectl;
) || exit 1

kubectl krew help >/dev/null || (
  set -x; cd "$(mktemp -d)" &&
  OS="$(uname | tr '[:upper:]' '[:lower:]')" &&
  ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" &&
  KREW="krew-${OS}_${ARCH}" &&
  curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz" &&
  tar zxvf "${KREW}.tar.gz" &&
  ./"${KREW}" install krew &&
  export PATH="${KREW_ROOT:-${HOME}/.krew}/bin:${PATH}" &&
  kubectl krew update && kubectl krew install stern;
  .dot reset HEAD --hard
) || exit 1

### Redis
type -p redis-cli >/dev/null || (sudo apt-get install -y redis-tools) || exit 1

### SDKMan!
type -p unzip >/dev/null || (sudo apt-get install -y unzip)
type -p zip >/dev/null || (sudo apt-get install -y zip)
type -p curl >/dev/null || (sudo apt-get install -y curl)
type -p sdk >/dev/null || (curl -s 'https://get.sdkman.io' | bash) || exit 1
.dot reset HEAD --hard

### Node Version Manager
type -p nvm >/dev/null || (curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | zsh) || exit 1
.dot reset HEAD --hard

### Docker
type -p docker >/dev/null || (
  sudo curl -fsSL 'https://download.docker.com/linux/ubuntu/gpg' -o '/etc/apt/keyrings/docker.asc';
  sudo chmod a+r '/etc/apt/keyrings/docker.asc';
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. '/etc/os-release' && echo "${VERSION_CODENAME}") stable" | \
    sudo tee '/etc/apt/sources.list.d/docker.list' > /dev/null;
  sudo apt-get update;
  type -p docker >/dev/null || sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin;
  getent group docker >/dev/null || groupadd docker;
  sudo usermod -aG docker "${USER}";
  sudo systemctl enable docker.service;
  sudo systemctl enable containerd.service;
  sudo cp docker/daemon.json '/etc/docker/daemon.json';
) || exit 1

### Adb
type -p adb >/dev/null || (sudo apt-get install -y adb) || exit 1

exit 0

### Anaconda
type -p conda >/dev/null || (
  sudo apt-get install -y libxrandr2 libxrandr2 libxss1 libxcursor1 libxcomposite1 libasound2 libxi6 libxtst6;
  CONDA_VERSION='Anaconda3-2023.09-0-Linux-x86_64.sh';
  CONDA_TEMP_DIR="${HOME}/.conda-temp";
  mkdir "${CONDA_TEMP_DIR}";
  cd "${CONDA_TEMP_DIR}" || exit 1;
  curl -O "https://repo.anaconda.com/archive/${CONDA_VERSION}";
  zsh "${CONDA_VERSION}" -b;
  cd "${ENVIRONMENT_BOOTSTRAP_ROOT}" || exit 1;
  rm -rf "${CONDA_TEMP_DIR}";
  .dot reset HEAD --hard
) || exit 1