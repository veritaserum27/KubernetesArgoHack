export SUBSCRIPTION_ID='<subscriptionID>'
export RESOURCE_GROUP='<resourceGroup>'
export CLUSTER_NAME='<clusterName>'

az aks install-cli
az aks get-credentials --resource-group $RESOURCE_GROUP --name $CLUSTER_NAME
kubectl get nodes

echo "--------------------------------------------------------"
echo "kubectl is installed. Now installing Argo CD on Cluster."
echo "--------------------------------------------------------"

kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl get all -n argocd

echo "--------------------------------------------------------"
echo "Argo CD is installed. Now setting up port forwarding."
echo "--------------------------------------------------------"

kubectl port-forward svc/argocd-server -n argocd 8080:443

echo "--------------------------------------------------------"
echo "Argo CD is running on http://localhost:8080"
echo "Your password is below. Copy it and login with the Argo CD CLI."
echo "--------------------------------------------------------"

kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo