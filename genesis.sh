#!/bin/bash

echo '... Let there be light'

### First Update
sudo apt update && sudo apt upgrade -y

### Codecrypt
PRIVATE_KEY_PATH_ARG="${1:-$PRIVATE_KEY_PATH}"

if [[ -z "${PRIVATE_KEY_PATH_ARG}" ]]
then
    echo "Genesis requires an non-empty path to its private key."
    echo "Specify the path by passing it as the first positional argument or by supplying it with a 'PRIVATE_KEY_PATH' environment variable."
    echo "./genesis.sh 'path' || export PRIVATE_KEY_PATH='path' && ./genesis.sh"
fi

type -p ccr >/dev/null || (sudo apt install codecrypt -y)
ccr --import-secret < "${PRIVATE_KEY_PATH}"

### Git
type -p git >/dev/null || (sudo apt install git -y)

### GitHub && GitHub's CLI
type -p curl >/dev/null || (sudo apt install curl -y)
curl -fsSL 'https://cli.github.com/packages/githubcli-archive-keyring.gpg' | sudo dd of='/usr/share/keyrings/githubcli-archive-keyring.gpg' \
&& sudo chmod go+r '/usr/share/keyrings/githubcli-archive-keyring.gpg' \
&& {
  SOURCES_ENTRY="deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main";
  echo "${SOURCES_ENTRY}" | sudo tee '/etc/apt/sources.list.d/github-cli.list' > /dev/null
} \
&& sudo apt update \
&& (type -p gh >/dev/null || (sudo apt install gh -y))

### Environment
GH_TOKEN=$(ccr -dv < 'encrypted/.gh-token')

export GH_TOKEN
cd "${HOME}" || exit
gh repo clone 'LeoFuso/.environment'
cd '.environment' || exit

source ./bootstrap.sh

