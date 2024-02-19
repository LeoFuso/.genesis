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
echo 'Installing Zsh...'
type -p zsh >/dev/null || (sudo apt-get install -y zsh)
echo 'Zsh... done.'

# Oh-My-Zsh
echo 'Installing Oh My Zsh...'
sh -c "$(curl -fsSL 'https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh')" --skip-chsh --unattended --keep-zshrc

# Plugins
git clone 'https://github.com/djui/alias-tips.git' "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/alias-tips"
git clone 'https://github.com/zsh-users/zsh-autosuggestions' "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
git clone 'https://github.com/TamCore/autoupdate-oh-my-zsh-plugins' "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/autoupdate"

echo 'Oh My Zsh... done.'

# Powerlevel10K
echo 'Installing PowerLevel10K...'
git clone --depth=1 'https://github.com/romkatv/powerlevel10k.git' "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"

type -p fc-cache >/dev/null || (sudo apt-get install -y fontconfig)
curl --create-dirs -o MesloLGS\ NF\ Regular.ttf --output-dir "${HOME}/.local/share/fonts/" 'https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf'
curl --create-dirs -o MesloLGS\ NF\ Bold.ttf --output-dir "${HOME}/.local/share/fonts/" 'https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf'
curl --create-dirs -o MesloLGS\ NF\ Italic.ttf --output-dir "${HOME}/.local/share/fonts/" 'https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf'
curl --create-dirs -o MesloLGS\ NF\ Bold\ Italic.ttf --output-dir "${HOME}/.local/share/fonts/" 'https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf'
fc-cache -f -v >/dev/null
echo 'PowerLevel10K... done.'

sudo chsh -s "$(which zsh)"
echo 'Zsh Setup... done.'

# Fzf
echo 'Installing Fzf...'
git clone --depth 1 https://github.com/junegunn/fzf.git "${HOME}/.fzf" \
  && zsh "${HOME}/.fzf/install" --key-bindings --completin --no-update-rc
echo 'Fzf... done.'

# ZPlug
echo 'Installing ZPlug...'
curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
echo 'ZPlug... done.'

exit 0