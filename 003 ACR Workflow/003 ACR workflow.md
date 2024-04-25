# 003 Container Registry Workflow

## Explanation

So far, we have set up an AKS Cluster and installed Argo CD. You should now be able to login to an Argo CD management page and look at cluster health etc.

In this section, we will set up a Github Actions pipeline (also called a workflow) that will build a container image and push to the ACR we set up in 001.

Having this container image in the ACR will allow us to pull it into the K8s cluster through Argo CD.

## Steps

1. Move the `.github` folder into the root of the repository. It should currently be in the `003 ACR Workflow` folder.
2. Commit the change.
3. Enable Github Actions. You will need to navigate to the "Actions" tab, and then see the following screen:

    ![Workflow Image](../Images/workflow%20image.png)

    The workflow is now technically enabled, but will fail since we don't have any secrets in the Github Repository. We also do not have a service principal or federated access, so we'll need to enable that.

4. Run the following to create a Microsoft Entra Application for federated access (make sure you're correctly logged into AZ CLI):

    `az ad app create --display-name ArgoCDHackApp`

    The JSON output from this has an `appId`, which we will use in the next step.

5. Run the  following to create a service principal. Use the same `appId` as in the output from the previous step. 

    `az ad sp create --id $appId`

    The JSON output from this has an `objectId` we will be using in the next step. 

6. Run the following to create a new role assignment. We will be giving the workflow `Contributor` access:

    `az role assignment create --role contributor --subscription $subscriptionId --assignee-object-id  $assigneeObjectId --assignee-principal-type ServicePrincipal --scope /subscriptions/$subscriptionId`

    Replace the `$subscriptionId` with yours (in two places!). The `$assigneeObjectId` is the `objectId` from the previous step.

    This will output the `clientId`, `subscriptionId` and `tenantId`, all of which we will use later.

7. In Github: Go to Settings > Environment and Variables > Secrets. We will add the following three secrets:
    - AZURE_CLIENT_ID
    - AZURE_TENANT_ID
    - AZURE_SUBSCRIPTION_ID

    You can find these values in the Azure Portal, under App Registrations.

8. In the Github Workflow, replace the following values:
    - AZURE_CONTAINER_REGISTRY: "your-azure-container-registry"
    - CONTAINER_NAME: "your-container-name"
    - RESOURCE_GROUP: "your-resource-group"

    The Github workflow now has the information it needs to build an image and push it to ACR. However, we still have no image! That's a problem. We will deploy a very simple Node app with a Dockerfile.

9. Copy all the contents of the `app` folder into the root of the repository. This way, the Github Actions workflow can build the Docker container and run it.
