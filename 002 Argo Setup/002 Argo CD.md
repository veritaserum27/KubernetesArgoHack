# 002 Argo CD

## Prerequisites

1. Complete [001-Kubernetes Setup](./001%20Kubernetes%20Setup)
2. Install the ArgoCD CLI by following the instructions [here](https://argo-cd.readthedocs.io/en/stable/cli_installation/)
3. Login to AZ CLI
4. Install Kubectl by running the following:

    ```bash
    az aks install-cli
    az aks get-credentials --resource-group <resource-group> --name <aks-cluster-name>
    ```

5. Run `kubectl get nodes` to ensure your nodes are visible

## Explanation

Argo CD is a fully featured continuous deployment service for Kubernetes. When integrated with GitOps, it will continuously monitor a Git repository for changes in specific folders or key areas, and then deploy those changes into a Kubernetes cluster.

Like Terraform, ArgoCD is declarative: Users needs to state what the end state of the infrastructure will be.

One major advantage of ArgoCD over something like Flux is the built-in UI: ArgoCD offers a fairly intensive, full-featured dashboard view to look at different clusters, monitor cluster health, etc.

## Steps

1. Create a namespace for ArgoCD:

    `kubectl create namespace argocd`

2. Apply the ArgoCD default helm chart:

    `kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml`

    This will setup a default implementation of ArgoCD. ArgoCD has a lot of networking, config maps, and other application specific setup that the Argo-Project handles by default. Changing anything here is **not recommended** unless you specifically know what you are changing, and why.

3. Test the installation:

    `kubectl get all -n argocd`

    This should now show a list of ArgoCD related resources. Check to make sure that the `argocd-server` resource is not exposed by default: It is specifically configured as a ClusterIP in the manifest, not as a Load balancer.

4. There are multiple possible ways to access the `argocd-server` on your local machine:
    1. Set up the `argocd-server` as a Load Balancer, thus giving it an external IP.
    2. Set up port-forwarding for the `argocd-server` to your local machine.
    3. Set up an Ingress Controller.

    Pick one of the three to implement. It should not make a difference which one you pick, though portforwarding might be the most straightforward for getting started. I will not go through setting up an Ingress controller in this hack.

    **Setting up a load-balancer**

    1. Run the following command to patch the `argocd-server` resource to be a LoadBalancer.
    2. 
        `kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'`

    3. Run the following to ensure the external IP is created. This command will output only the exetrnal IP of the `argocd-server`.
    4. 
        `kubectl get services --namespace argocd argocd-server --output jsonpath='{.status.loadBalancer.ingress[0].ip}'`

    5. Navigate to the assigned external IP. You should now see an ArgoCD login page.

    **Setting up Port-forwarding**

    1. Run the following command to set up port-forwarding:
    2. 
        `kubectl port-forward svc/argocd-server -n argocd 8080:443`

    3. Navigate to `http://localhost:8080`. You should now see an ArgoCD login page.

5. Login to the ArgoCD page:
    1. Username: `admin`
    2. To obtain your password, run the following:

        `kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo`

6. Login to the ArgoCD CLI:
    1. Run the following command:

        `argocd login <Server IP>`

    2. The username and password will be the same as in (5).
