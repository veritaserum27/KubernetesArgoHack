# 005 Kubernetes Manifest Update

## Explanation

In theory, GitOps is now technically enabled. Any changes to the deploy folder will trigger Argo CD to pull the new Kubernetes manifest files, and to then apply them to the K8s cluster.

However, we still have to update the manifest files manually. Boo!

But we can fix that with a new Github Actions workflow. In this step, we will do the following:

1. Add a new Github Actions Job to trigger when the existing build and package job ends.
2. Automatically update the manifest file so it points to the newest container image in ACR.

## Steps

1. Add the following job to the existing `build.yml` workflow:

    ```yaml
    Update-K8s-Manifests:
        name: Update K8s Deployment Manifest with Image Version
        needs: buildImage
        environment: ${{ inputs.Environment }}
        runs-on: ubuntu-latest
        steps:

        # Checks out the baseline repository
        - uses: actions/checkout@v2

        - name: Update image name in manifest file
        uses: azure/powershell@v1
        with:
            inlineScript: |
            $line = Get-Content deploy/node-app-deployment.yml | Select-String image: | Select-Object -ExpandProperty Line
            $content = Get-Content  deploy/node-app-deployment.yml
            $content | ForEach-Object {$_ -replace $line,"        image: ${{ env.AZURE_CONTAINER_REGISTRY }}.azurecr.io/${{ env.CONTAINER_NAME }}:${{ github.sha }}"} | Set-Content  deploy/node-app-deployment.yml
            azPSVersion: "latest"
        
        - name: Commit changes in manifest to repo
        run: | 
            git config user.name "GitHub Actions Bot"
            git config user.email ""
            git add  deploy/node-app-deployment.yml
            git commit -m "Update image version in K8s Deployment manifests file"
            git push origin
    ```

2. Commit the new workflow.

    Now, whenever a change is made to the Node JS app, a workflow will trigger to build and push a new image to the ACR, and to update the K8s deployment file. Once this is done, Argo CD should automatically sync the changes, and your Kubernetes cluster will update on it's own.

3. Test this out by modifying the Node JS file to say "Hello GitOps and Argo CD!" instead of "Hello World". Watch the Argo CD dashboard to see the changes take place. You can also test the actual change using a `curl` command, as the app is installed as a `load-balancer` with an external IP.
