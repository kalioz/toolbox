#!/bin/bash
set -x
if [ -z "$DEBUG" ]; then
    set -e
fi

# update scripts from plugins, without failing if the upstream isn't working anymore

# git bash prompt



# kubernetes bash prompt (from ohmyzsh)
wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/kube-ps1/kube-ps1.plugin.zsh -O .kube-ps1.plugin.sh

if [ $? -ne 0 ]; then
    echo "couldn't update kube-ps1"
fi

chmod +x .kube-ps1.plugin.sh

# kubectl aliases
wget https://raw.githubusercontent.com/ahmetb/kubectl-aliases/master/.kubectl_aliases -O .kubectl_aliases.sh

if [ $? -ne 0 ]; then
    echo "couldn't update kubectl_aliases"
fi

chmod +x .kubectl_aliases.sh