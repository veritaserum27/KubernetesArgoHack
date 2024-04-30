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

    This command will output JSON with an appId that is your client-id. Save the value to use as the AZURE_CLIENT_ID GitHub secret later.

5. Create a service principal with the following command:

    `az ad sp create --id $appId`

    This command generates JSON output with a different `objectId` and will be used in the next step. The new objectId is the `assignee-object-id`.

    Copy the `appOwnerTenantId` to use as a GitHub secret for `AZURE_TENANT_ID` later.

6. Create a new role assignment with the following command:

    `az role assignment create --role contributor --subscription $subscriptionId --assignee-object-id  $assigneeObjectId --scope /subscriptions/$subscriptionId/resourceGroups/$resourceGroupName/providers/Microsoft.Web/sites/ --assignee-principal-type ServicePrincipal`

    Replace `$subscriptionId` with your subscription ID, `$resourceGroupName` with your resource group name, and `$assigneeObjectId` with the generated `assignee-object-id`.

7. Rename `credential.sample.json` to `credential.json`, and replace the following values:

    1. name: `"ANYNAME"`
    2. subject: `"repo:<username>/KubernetesArgoHack:ref:refs/heads/main"`

    and then run the folowing:

    `az ad app federated-credential create --id <APPLICATION-OBJECT-ID> --parameters credential.json`

    To give the app federated credentials. If this doesn't work, we can also run this in Azure portal.

8. We need to give the application access to ACR. In Portal, go to `App Registrations`, and copy the Application ID. Then run the following:

    `az role assignment create --assignee <appID> --role Contributor --scope /subscriptions/<subscription-id>/resourceGroups/<resource-group>`

    Replace `<appID>` and `<resource-group>`.

9. In Github: Go to Settings > Security > Secrets and variables > Actions > New repository secret. We will add the following three secrets:
    - AZURE_CLIENT_ID (From Step 4)
    - AZURE_TENANT_ID (From Step 5)
    - AZURE_SUBSCRIPTION_ID

10. In the Github Workflow, replace the following values:
    - AZURE_CONTAINER_REGISTRY: "your-azure-container-registry"
    - CONTAINER_NAME: "your-container-name"
    - RESOURCE_GROUP: "your-resource-group"

    The Github workflow now has the information it needs to build an image and push it to ACR. However, we still have no image! That's a problem. We will deploy a very simple Node app with a Dockerfile.

11. Copy all the contents of the `app` folder into the root of the repository. This way, the Github Actions workflow can build the Docker container and run it.
