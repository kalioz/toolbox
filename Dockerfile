
ARG KUBECTL_VERSION=v1.17.3
ARG KUBECTX_VERSION=0.8.0
ARG STERN_VERSION=1.11.0
ARG K9S_VERSION=v0.17.3
ARG HELM_VERSION=3.1.1
ARG HELMFILE_VERSION=v0.102.0
ARG TERRAFORM_VERSION=0.12.21
ARG TERRAGRUNT_VERSION=v0.23.0

FROM alpine AS builder

# Kubernetes related tools
FROM lachlanevenson/k8s-kubectl:${KUBECTL_VERSION} AS kubectl

FROM builder AS kubectx
ARG KUBECTX_VERSION
RUN mkdir -p /kubectx && \
    cd /kubectx && \
    wget https://github.com/ahmetb/kubectx/archive/v${KUBECTX_VERSION}.tar.gz && \
    tar zxf v${KUBECTX_VERSION}.tar.gz && \
    mv kubectx-${KUBECTX_VERSION}/kubectx kubectx-${KUBECTX_VERSION}/kubens /usr/local/bin/ && \
    chmod +x /usr/local/bin/kubectx /usr/local/bin/kubens && \
    rm -rf /kubectx

FROM builder AS stern
ARG STERN_VERSION
RUN wget https://github.com/wercker/stern/releases/download/1.11.0/stern_linux_amd64 -O /usr/local/bin/stern && \
    chmod +x /usr/local/bin/stern

FROM builder AS k9s
ARG K9S_VERSION
RUN mkdir /k9s && \
    cd /k9s && \
    wget https://github.com/derailed/k9s/releases/download/${K9S_VERSION}/k9s_Linux_x86_64.tar.gz && \
    tar zxf k9s_Linux_x86_64.tar.gz -C /usr/local/bin/ && \
    chmod +x /usr/local/bin/k9s && \
    rm -rf /k9s

# Helm related tools
FROM alpine/helm:${HELM_VERSION} AS helm

FROM builder AS helmfile
ARG HELMFILE_VERSION
RUN wget https://github.com/roboll/helmfile/releases/download/${HELMFILE_VERSION}/helmfile_linux_386 -O /usr/local/bin/helmfile && \
    chmod +x /usr/local/bin/helmfile

# Terraform related tools
FROM hashicorp/terraform:${TERRAFORM_VERSION} AS terraform

FROM builder AS terragrunt
ARG TERRAGRUNT_VERSION
RUN wget https://github.com/gruntwork-io/terragrunt/releases/download/${TERRAGRUNT_VERSION}/terragrunt_linux_386 -O /usr/local/bin/terragrunt && \
    chmod +x /usr/local/bin/terragrunt


# Final Image
FROM ubuntu AS final

# get all software version
ARG KUBECTL_VERSION
ARG KUBECTX_VERSION
ARG STERN_VERSION
ARG K9S_VERSION
ARG HELM_VERSION
ARG HELMFILE_VERSION
ARG TERRAFORM_VERSION
ARG TERRAGRUNT_VERSION

ENV KUBECTL_VERSION=${KUBECTL_VERSION} \
    KUBECTX_VERSION=${KUBECTX_VERSION} \
    STERN_VERSION=${STERN_VERSION} \
    K9S_VERSION=${K9S_VERSION} \
    HELM_VERSION=${HELM_VERSION} \
    HELMFILE_VERSION=${HELMFILE_VERSION} \
    TERRAFORM_VERSION=${TERRAFORM_VERSION} \
    TERRAGRUNT_VERSION=${TERRAGRUNT_VERSION} 

## bashrc tools
WORKDIR /root
COPY scripts/* /root/

## useful tools to have
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
        make \
        git \
        jq \
        curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

## Copy all other tools
COPY --from=kubectl --chown=0:0 /usr/local/bin/kubectl /usr/local/bin/kubectl
COPY --from=kubectx --chown=0:0 /usr/local/bin/kubectx /usr/local/bin/kubens /usr/local/bin/
COPY --from=stern --chown=0:0 /usr/local/bin/stern /usr/local/bin/stern
COPY --from=k9s --chown=0:0 /usr/local/bin/k9s /usr/local/bin/k9s 
COPY --from=helm --chown=0:0 /usr/bin/helm /usr/local/bin/helm
COPY --from=helmfile --chown=0:0 /usr/local/bin/helmfile /usr/local/bin/helmfile
COPY --from=terraform --chown=0:0 /bin/terraform /usr/local/bin/terraform
COPY --from=terragrunt --chown=0:0 /usr/local/bin/terragrunt /usr/local/bin/terragrunt

ENTRYPOINT ["/root/entrypoint.sh"]