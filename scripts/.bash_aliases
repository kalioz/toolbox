# kubernetes custom aliases
alias kb='kubectl'
alias kbns='kubens'
alias kctx='kubectx'

alias kbp='kubectl get pods'
alias kpimage='kubectl get pods --output custom-columns="NAME:metadata.name,IMAGE:spec.containers[*].image,INIT_IMAGE:spec.initContainers[*].image"'
alias kpresources='kubectl get pods --output custom-columns="POD:metadata.name,CONTAINERS:spec.containers[*].name,CPU_MIN:spec.containers[*].resources.requests.cpu,CPU_MAX:spec.containers[*].resources.limits.cpu,MEM_MIN:spec.containers[*].resources.requests.memory,MEM_MAX:spec.containers[*].resources.limits.memory,PRIORITY:.spec.priorityClassName,NODE:.spec.nodeName"'
alias kplabels='kubectl get pods --output custom-columns="NAME:metadata.name,LABELS:metadata.labels"'
alias kpannotations='kubectl get pods --output custom-columns="NAME:metadata.name,ANNOTATIONS:metadata.annotations"'
alias kbl='kubectl get logs'

kbexec () {
    arg=${2:="bash"}
    kubectl exec -it ${arg}
}

alias kb_bash='kubectl run -it --rm --image alpine bash'
alias kb_deletefailed='kubectl delete $(kubectl get pods --field-selector=status.phase=Failed --output name)'

# terraform custom aliases
alias tf='terraform'
alias tg='terragrunt'