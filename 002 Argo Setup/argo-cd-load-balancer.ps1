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
Write-Host "Argo CD is installed. Now setting up server as load-balancer."
Write-Host "--------------------------------------------------------"

# Patching service to be exposed as a load balancer
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
kubectl get svc -n argocd

Write-Host "--------------------------------------------------------"
Write-Host "Argo CD server is now exposed as a load-balancer."
Write-Host "External IP is below."
Write-Host "--------------------------------------------------------"

# Getting the external IP address of the load balancer
kubectl get services --namespace argocd argocd-server --output jsonpath='{.status.loadBalancer.ingress[0].ip}'

Write-Host "--------------------------------------------------------"
Write-Host "Your password is below. Copy it and login with the Argo CD CLI."
Write-Host "--------------------------------------------------------"

# Retrieving and decoding the initial admin password
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
