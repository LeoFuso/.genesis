#!/bin/bash

### .dot
# shellcheck disable=SC2139
alias .dot="git --git-dir ${HOME}/.environment/.git/ --work-tree ${HOME}"
.dot config --local status.showUntrackedFiles no

### SSH Generation
SSH_KEY="${HOME}/.ssh/id_ed25519";
if [[ ! -f "${SSH_KEY}" ]]
then
    ssh-keygen -t ed25519 -a 100 -f "${SSH_KEY}" -C "${USER}@$(hostname)" -N '' -q;
    eval "$(ssh-agent -s)" >/dev/null;
    ssh-add "${SSH_KEY}";
    GH_TOKEN=$(ccr -dv < 'encrypted/.gh-token');
    export GH_TOKEN;
    gh ssh-key add "${SSH_KEY}.pub" --title "${USER}@$(hostname)";
fi

exit 0
