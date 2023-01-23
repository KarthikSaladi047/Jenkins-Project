# Project: CI/CD Pipeline for a Simple Node.js Application

# Overview
This project aims to demonstrate the implementation of a CI/CD pipeline for a simple Node.js application using Jenkins. The pipeline includes the following stages:
- Build: Compile and test the application code.
- Deploy: Deploy the application to a test environment.
- Test: Run automated tests on the deployed application.
- Release: Deploy the application to a production environment.

# Tools and Technologies
- Jenkins: The CI/CD tool used to automate the pipeline.
- Node.js: The application is built with Node.js.
- npm: The package manager used for the application.
- Terraform: The Insfrastructure as tool used for provisioning App Service on azure.

# Jenkins Pipeline
- Install Jenkins on your system and create a new Jenkins job for the pipeline.
- Configure the Jenkins job to pull the source code from your GitHub repository.
- Add a build step to the job that runs the following command: npm install to install the application's dependencies.
- Add another build step to the job that runs the following command: npm test to run the tests for the application.
- Add another step to provision web app using Terraform.
- Add a post-build action to the job that deploys the application to a test environment.
```
pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/<username>/<repository>.git', branch: 'master'
            }
        }
        stage('Build') {
            steps {
                sh 'npm install'
            }
        }
        stage('Test') {
            steps {
                sh 'npm test'
            }
        }
        stage('Provision Azure Web App') {
            steps {
                sh 'terraform init'
                sh 'terraform apply -auto-approve'
            }
        }
        stage('Deploy to Test') {
            steps {
                // Add steps to deploy the application to a production environment
            }
        }
    }
}

```
This Jenkins pipeline uses the Jenkins Pipeline plugin to define the stages of the pipeline. It starts by checking out the code from the GitHub repository, then it runs npm install to install the dependencies, npm test to test the code, then it uses Terraform to provision the Azure Web App and deploy the application to a test environment.


- Add a post-build action to deploy the application to Azure App Service. To do this, you can use Azure CLI or Azure PowerShell Scripts.
- To deploy to Azure you will need to configure Jenkins with your Azure credentials.
- After that you can run the command for Deployment on Azure App Service like az webapp up --name <your_webapp_name> --resource-group <your_resource_group> --plan <your_plan>
