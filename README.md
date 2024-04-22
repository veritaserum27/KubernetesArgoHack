# Kubernetes Argo Hack

Welcome to the Kubernetes Argo Hack! This guided hack will walk you through the process of setting up a Kubernetes cluster, installing Argo CD on the cluster, and implementing a GitOps flow within your repository.

## Pre-requisites

1. Existing Azure Account
2. Existing Github accoun

## What Is

There are a lot of terms in Kubernetes Land. Here's a helpful list of terms that will be relevant and useful.

### Kubernetes

Kubernetes is an open-source container orchestration platform that automates the deployment, scaling, and management of containerized applications.

### Helm

Helm is a package manager for Kubernetes that simplifies the deployment and management of applications. Helm charts are pre-configured templates that define the structure and configuration of Kubernetes resources. They are useful because they enable easy sharing and reusability of application configurations, making it faster and more efficient to deploy complex applications on Kubernetes.

### Operators

Kubernetes Operators are a method of packaging, deploying, and managing a Kubernetes application. They extend the functionality of Kubernetes by introducing custom resources and controllers that automate the management of complex applications or services. Operators are typically used to manage stateful applications and provide additional operational capabilities such as automated scaling, backup and restore, and configuration management. Flux and Argo are both Kubernetes operators.

### GitOps

GitOps is the practice of using Git as a single source of truth for declaratively specifying the desired state of infrastructure and applications. GitOps provides increased reliability and velocity, reduced downtime, and self-healing. Argo CD and Flux are the most popular options for GitOps continuous deployment.

### Argo CD

Argo CD is a declarative, GitOps continuous delivery tool for Kubernetes. It automates the deployment and management of applications in Kubernetes clusters by using Git repositories as the source of truth for the desired state of the cluster. Argo CD continuously monitors the Git repository for changes and reconciles the cluster to match the desired state defined in the repository. It provides a web-based user interface and a command-line interface for managing applications and their deployments. Argo CD also supports rollbacks, can integrate with external tools for testing and validation, and provides a rich set of features for managing application configurations and secrets.

## What will we do today?

This hack will take you through:

1. Setting up an AKS cluster
2. Installing Argo CD on the cluster
3. Installing an app on the cluster using a helm chart
4. Monitoring the app
5. Setting up a GitOps flow
6. Making a change to the app via a commit, and then watching ArgoCD implement the change

## Architecture

This is the eventual architecture we will implement:

![Architecture](./Images/gitops-ci-cd-argo-cd.png)

Data flow:

1. App code is developed or changed in an IDE
2. Code is committed to Github
3. Github Actions builds a container image and pushes the image to ACR
4. Github Actions updates a Kubernetes Manifest deployment file with the latest image version based on a version number in ACR
5. Argo CD pulls from the Git repository
6. Argo CD deploys the newest image to the AKS cluster

## Contributing

If you find any issues or have suggestions for improvements, feel free to open an issue or submit a pull request.

## License

This project is licensed under the [MIT License](LICENSE).
