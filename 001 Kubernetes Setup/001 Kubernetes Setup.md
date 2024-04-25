# 001 Kubernetes Setup

## Explanation

The Bicep script in this folder, [infrastructure-deploy.bicep](./infrastructure-deploy.bicep) does the following:

1. Sets up an Azure Container registry.
2. Sets up an Azure Kubernetes cluster.
3. Sets up pull authorization for the ACR in the AKS Cluster.

This should be all the Azure resources you need for the rest of this hack.

## Steps

To deploy the infrastructure-deploy.bicep script in the repository, follow these steps:

1. Open the command prompt or terminal.
2. Navigate to the directory where the script is located.
3. Run `az login` and make sure you're in the right subscription.
4. Run the following command to create a resource group:

    ```bash
    az group create --location eastus --name <resource-group-name>

    az acr create -n <name of registry> -g <resource group> --sku Standard
    
    az aks create --location eastus --name wth-aks02-poc --node-count 3  --no-ssh-key --resource-group wth-rg02-poc --zones 1 2 3 --enable-managed-identity --attach-acr <acrname>
    ```

5. Wait for the deployment to complete. You can monitor the progress in the command prompt or terminal.

6. If the ACR didn't attach correctly, you can run this:

    `az aks update -n myAKSCluster -g myResourceGroup --attach-acr <acrName>`
