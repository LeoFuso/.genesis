#!/bin/bash

echo '... Let there be light'

### Fetching PK...
PRIVATE_KEY_PATH_ARG="${1:-$PRIVATE_KEY_PATH}"
PROFILE_BRANCH_ARG="${2:-$PROFILE_BRANCH}"

if [[ -z "${PRIVATE_KEY_PATH_ARG}" ]]
then
    echo "Genesis requires an non-empty path to its private key.";
    echo "Specify the path by passing it as the first positional argument or by supplying it with a 'PRIVATE_KEY_PATH' environment variable.";
    echo "./genesis.sh 'path' || export PRIVATE_KEY_PATH='path' && ./genesis.sh";
    exit 1;
fi

### First Update
sudo apt update && sudo apt upgrade -y

### Codecrypt
echo 'At first, Codecrypt...'
type -p ccr >/dev/null || (sudo apt-get install -y codecrypt)
ccr --yes --import-secret < "${PRIVATE_KEY_PATH_ARG}" || { echo "Unable to import private key at '${PRIVATE_KEY_PATH_ARG}'."; exit 1; }

### Git
echo '... and Git on the first day.'
type -p git >/dev/null || (sudo apt-get install -y git)

### GitHub && GitHub's CLI
echo 'GitHub && GitHub'\''s CLI... on the second day.'

type -p curl >/dev/null || (sudo apt-get install -y curl)
curl -fsSL 'https://cli.github.com/packages/githubcli-archive-keyring.gpg' | sudo dd of='/usr/share/keyrings/githubcli-archive-keyring.gpg' \
&& sudo chmod go+r '/usr/share/keyrings/githubcli-archive-keyring.gpg' \
&& {
  SOURCES_ENTRY="deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main";
  echo "${SOURCES_ENTRY}" | sudo tee '/etc/apt/sources.list.d/github-cli.list' > /dev/null
} \
&& sudo apt update \
&& (type -p gh >/dev/null || (sudo apt-get install -y gh))

### Environment
echo 'On the third day, Environment.'
GH_TOKEN=$(ccr -dv < 'encrypted/.gh-token')
export GH_TOKEN

cd "${HOME}" || exit 1
gh repo clone 'LeoFuso/.environment' || exit 1
cd '.environment' || exit 1

if [[ -n "${PROFILE_BRANCH_ARG}" ]]
then
    echo "Switching to '${PROFILE_BRANCH_ARG}' profile.";
    git switch "${PROFILE_BRANCH_ARG}" 2>/dev/null || git switch -c "${PROFILE_BRANCH_ARG}";
fi

echo 'Bootstrap it all.'
chmod +x bootstrap.sh
export GH_TOKEN="${GH_TOKEN}" ./bootstrap.sh
