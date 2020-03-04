#!/bin/bash

echo "currently installed on this image are the following softwares :"
echo "> $(ls /usr/local/bin | tr "\n" " ")"
echo ""
echo "current versions are :"
printenv | grep VERSION | sort
echo ""
echo "Current bash extensions are : "
[ -f ~/.kubectl_aliases ] && echo " kubectl-aliases (https://github.com/ahmetb/kubectl-aliases )"
[ -f ~/.kube-ps1.plugin.sh ] && echo " ohmyzsh/kube-ps1 (https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/kube-ps1) [kubeon / kubeoff]"
echo ""
echo "=================================================="
echo ""
/bin/bash