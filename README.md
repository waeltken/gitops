# GitOps with AKS

Enable the AAD Pod Identity Preview Feature for your Azure CLI at cluster creation time.

```shell
az extension add --name aks-preview
az feature register --name EnablePodIdentityPreview --namespace Microsoft.ContainerService
```

Create a development cluster

```shell
az group create -n gitops -l westeurope
az aks create -n dev -g gitops \
 --network-plugin="azure" \
 --network-policy="calico" \
 --enable-managed-identity \
 --enable-pod-identity
az aks get-credentials -n dev -g gitops
```

Install flux using homebrew

```shell
brew install fluxcd/tap/flux
```

or just bash

```shell
curl -s https://fluxcd.io/install.sh | sudo bash
```

Check if we are ready to bootstrap

```shell
$ flux check --pre
► checking prerequisites
✔ kubectl 1.22.1 >=1.18.0-0
✔ Kubernetes 1.20.9 >=1.16.0-0
✔ prerequisites checks passed
```

Set GitHub configuration with user, repo and token.

```shell
export GITHUB_TOKEN="<GitHub token with full repo>"
export GITHUB_USER=<GitHub username>
export GITHUB_REPO=<GitHub repository name>
```

Bootstrap the development cluster.

```shell
flux bootstrap github \
 --owner=$GITHUB_USER \
 --repository=$GITHUB_REPO \
 --branch=main \
 --path=./clusters/dev \
 --read-write-key \
 --personal
```

Add a staging cluster

```shell
az aks create -n staging -g gitops \
 --network-plugin="azure" \
 --network-policy="calico" \
 --enable-managed-identity \
 --enable-pod-identity

az aks get-credentials -n staging -g gitops

flux check --pre

flux bootstrap github \
 --owner=$GITHUB_USER \
 --repository=$GITHUB_REPO \
 --branch=main \
 --path=./clusters/staging \
 --read-write-key \
 --personal
```
