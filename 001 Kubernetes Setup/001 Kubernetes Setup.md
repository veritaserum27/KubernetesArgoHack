# 001 Kubernetes Setup

## Explanation

1. Set up an Azure Container registry.
2. Set up an Azure Kubernetes cluster.
3. Set up pull authorization for the ACR in the AKS Cluster.

This should be all the Azure resources you need for the rest of this hack.

## Steps

Follow these steps:

1. Open the command prompt or terminal.
2. Navigate to the directory where the script is located.
3. Run `az login` and make sure you're in the right subscription.
4. Run the following commands:

    ```bash
    az group create --location eastus --name <resource-group-name>

    az acr create -n <name of registry> -g <resource group> --sku Standard
    
    az aks create --location eastus --name wth-aks02-poc --node-count 3  --no-ssh-key --resource-group wth-rg02-poc --zones 1 2 3 --enable-managed-identity --attach-acr <acrname>
    ```

5. Wait for the deployment to complete. You can monitor the progress in the command prompt or terminal.

6. If the ACR didn't attach correctly, you can run this:

    `az aks update -n myAKSCluster -g myResourceGroup --attach-acr <acrName>`
