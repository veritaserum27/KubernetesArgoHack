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
echo "Argo CD is installed. Now setting up server as load-balancer."
echo "--------------------------------------------------------"

kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
kubectl get svc -n argocd

echo "--------------------------------------------------------"
echo "Argo CD server is now exposed as a load-balancer."
echo "External IP is below."
echo "--------------------------------------------------------"

kubectl get services --namespace argocd argocd-server --output jsonpath='{.status.loadBalancer.ingress[0].ip}'

echo "--------------------------------------------------------"
echo "Your password is below. Copy it and login with the Argo CD CLI."
echo "--------------------------------------------------------"

kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo