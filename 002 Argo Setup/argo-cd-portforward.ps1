# Setting up environment variables
$env:SUBSCRIPTION_ID = '<subscriptionID>'
$env:RESOURCE_GROUP = '<resourceGroup>'
$env:CLUSTER_NAME = '<clusterName>'

# Installing Azure CLI Kubernetes commands and setting credentials
az aks install-cli
az aks get-credentials --resource-group $env:RESOURCE_GROUP --name $env:CLUSTER_NAME

# Getting node information
kubectl get nodes

Write-Host "--------------------------------------------------------"
Write-Host "kubectl is installed. Now installing Argo CD on Cluster."
Write-Host "--------------------------------------------------------"

# Creating namespace and installing Argo CD
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl get all -n argocd

Write-Host "--------------------------------------------------------"
Write-Host "Argo CD is installed. Now setting up port forwarding."
Write-Host "--------------------------------------------------------"

# Setting up port forwarding
kubectl port-forward svc/argocd-server -n argocd 8080:443

Write-Host "--------------------------------------------------------"
Write-Host "Argo CD is running on http://localhost:8080"
Write-Host "Your password is below. Copy it and login with the Argo CD CLI."
Write-Host "--------------------------------------------------------"

# Retrieving and decoding the initial admin password
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
