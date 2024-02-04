#!/bin/bash

### Environment
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

# shellcheck disable=SC2139
alias .dot="git --git-dir ${HOME}/.environment/.git/ --work-tree ${HOME}"
.dot config --local status.showUntrackedFiles no
.dot reset HEAD --hard

# Zsh
type -p zsh >/dev/null || (sudo apt-get install -y zsh)

# Oh-My-Zsh
sh -c "$(curl -fsSL 'https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh')" --skip-chsh --unattended --keep-zshrc

# Plugins
git clone 'https://github.com/djui/alias-tips.git' "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/alias-tips"
git clone 'https://github.com/zsh-users/zsh-autosuggestions' "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
git clone 'https://github.com/TamCore/autoupdate-oh-my-zsh-plugins' "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/autoupdate"

# Powerlevel10K
git clone --depth=1 'https://github.com/romkatv/powerlevel10k.git' "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"

type -p fc-cache >/dev/null || (sudo apt-get install -y fontconfig)
curl --create-dirs -o MesloLGS\ NF\ Regular.ttf --output-dir "${HOME}/.local/share/fonts/" 'https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf'
curl --create-dirs -o MesloLGS\ NF\ Bold.ttf --output-dir "${HOME}/.local/share/fonts/" 'https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf'
curl --create-dirs -o MesloLGS\ NF\ Italic.ttf --output-dir "${HOME}/.local/share/fonts/" 'https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf'
curl --create-dirs -o MesloLGS\ NF\ Bold\ Italic.ttf --output-dir "${HOME}/.local/share/fonts/" 'https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf'
fc-cache -f -v >/dev/null

sudo chsh -s "$(which zsh)"

exit 0