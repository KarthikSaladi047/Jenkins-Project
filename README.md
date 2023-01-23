# Project: CI/CD Pipeline for a Simple Node.js Application 

## Overview
This project aims to demonstrate the implementation of a CI/CD pipeline for a simple Node.js application using Jenkins. The pipeline includes the following stages:
- Build: Compile and test the application code.
- Infra Provisioning : Using terraform provision Azure app service.
- Deploy: Deploy the application to a Production environment.

## Tools and Technologies
- Jenkins: The CI/CD tool used to automate the pipeline.
- Node.js: The application is built with Node.js.
- npm: The package manager used for the application.
- Azure: Cloud provider used to host the application.
- Terraform: The Insfrastructure Provisioning tool used for provisioning App Service on Azure.

![You](https://user-images.githubusercontent.com/105864615/214068342-3a879c5b-3a6c-4873-acce-f522042d5deb.jpg)

## Jenkins Pipeline
- Install Jenkins on your system and create a new Jenkins job for the pipeline.
- Configure the Jenkins job to pull the source code from your GitHub repository.
- Add a build step to the job that runs the following command: npm install to install the application's dependencies.
- Add another build step to the job that runs the following command: npm test to run the tests for the application.
- Add another step to provision web app using Terraform.
- Add a post-build action to the job that deploys the application to a Production environment.

First we need to set the following Secret variables in Jenkins:
- $RESOURCE_GROUP
- $WEBAPP_NAME_PROD
- $AZURE_CLIENT_SECRET
- $AZURE_CLIENT_ID
- $AZURE_TENANT_ID

### If we use Jenkins:latest continer as Jenkins server, we don't need to install node.js and Azure CLI as they are pre installed. We can use following code.(Jenkinsfile)
```
pipeline {
    agent {
        container 'jenkins:latest'
    }
    environment {
        AZURE_CLIENT_ID = credentials('AZURE_CLIENT_ID')
        AZURE_CLIENT_SECRET = credentials('AZURE_CLIENT_SECRET')
        AZURE_TENANT_ID = credentials('AZURE_TENANT_ID')
        RESOURCE_GROUP = credentials('RESOURCE_GROUP')
        WEBAPP_NAME_PROD = credentials('WEBAPP_NAME_PROD')
    }
    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/KarthikSaladi047/Jenkins-Project.git', branch: 'main'
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
        stage('Zip Code') {
            steps {
                sh 'zip -r application.zip .'
            }
        }
        stage('Install Terraform') {
            steps {
                sh 'wget https://releases.hashicorp.com/terraform/0.14.8/terraform_0.14.8_linux_amd64.zip'
                sh 'unzip terraform_0.14.8_linux_amd64.zip'
                sh 'mv terraform /usr/local/bin/'
            }
        }
        stage('Provision Azure Web App') {
            steps {
                sh 'terraform init'
                sh 'terraform apply -auto-approve'
            }
        }
        stage('Azure CLI Installation') {
            steps {
                sh 'az --version || (apt-get update && apt-get install -y azure-cli)'
            }
        }
        stage('Deploy to Production') {
            steps {
                sh 'az login --service-principal -u $AZURE_CLIENT_ID -p $AZURE_CLIENT_SECRET --tenant $AZURE_TENANT_ID'
                sh 'az webapp deployment source config-zip --resource-group $RESOURCE_GROUP --name $WEBAPP_NAME_PROD --src application.zip'
            }
        }
    }
}
```
This Jenkins pipeline uses the Jenkins Pipeline plugin to define the stages of the pipeline. It starts by checking out the code from the GitHub repository, then it runs npm install to install the dependencies, npm test to test the code, then it uses Terraform to provision the Azure Web App, then it checks if Azure CLI is installed or not, if not it will install and deploy the application to a production environment.

### If we use local machine as Jenkins server, we  need to install node.js and Azure CLI. We can use following code.(Jenkinsfile)
```
pipeline {
    agent {
        label 'Ubuntu'
    }
     environment {
        AZURE_CLIENT_ID = credentials('AZURE_CLIENT_ID')
        AZURE_CLIENT_SECRET = credentials('AZURE_CLIENT_SECRET')
        AZURE_TENANT_ID = credentials('AZURE_TENANT_ID')
        RESOURCE_GROUP = credentials('RESOURCE_GROUP')
        WEBAPP_NAME_PROD = credentials('WEBAPP_NAME_PROD')
    }
    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/KarthikSaladi047/Jenkins-Project.git', branch: 'main'
            }
        }
        stage('Install Node.js') {
            steps {
                sh 'curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -'
                sh 'sudo apt-get install -y nodejs'
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
        stage('Zip Code') {
            steps {
                sh 'zip -r application.zip .'
            }
        }
        stage('Install Terraform') {
            steps {
                sh 'wget https://releases.hashicorp.com/terraform/0.14.8/terraform_0.14.8_linux_amd64.zip'
                sh 'unzip terraform_0.14.8_linux_amd64.zip'
                sh 'mv terraform /usr/local/bin/'
            }
        }
        stage('Provision Azure Web App') {
            steps {
                sh 'terraform init'
                sh 'terraform apply -auto-approve'
            }
        }
        stage('Install Azure CLI') {
            steps {
                sh 'curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash'
            }
        }
        stage('Deploy to Production') {
            steps {
                sh 'az login --service-principal -u $AZURE_CLIENT_ID -p $AZURE_CLIENT_SECRET --tenant $AZURE_TENANT_ID'
                sh 'az webapp deployment source config-zip --resource-group $RESOURCE_GROUP --name $WEBAPP_NAME_PROD --src application.zip'
            }
        }
    }
}
```
This Jenkins pipeline uses the Jenkins Pipeline plugin to define the stages of the pipeline. It starts by checking out the code from the GitHub repository, then it installs node.js and Azure CLI, then it runs npm install to install the dependencies, npm test to test the code, then it uses Terraform to provision the Azure Web App and deploy the application to a test environment.

## Terraform configuration file for provisioning web app on Azure
```
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.40.0"
    }
  }
}

provider "azurerm" {
  # add your  Configuration details
  subscription_id = ""
  tenant_id       = ""
  client_id       = ""
  client_secret   = ""
}

resource "azurerm_resource_group" "web_app_rg" {
  name     = "Web-Resource-Group"
  location = "East US"
}

resource "azurerm_service_plan" "service_plan" {
  name                = "serviceplan22"
  resource_group_name = azurerm_resource_group.web_app_rg.name
  location            = azurerm_resource_group.web_app_rg.location
  os_type             = "Linux"
  sku_name            = "S1"
}

resource "azurerm_linux_web_app" "web_app" {
  name                = "webapp22334455"
  resource_group_name = azurerm_resource_group.web_app_rg.name
  location            = azurerm_service_plan.service_plan.location
  service_plan_id     = azurerm_service_plan.service_plan.id
  site_config {
    application_stack {
      node_version = "14-lts"
    }
  }
}
```
# Thanks
Thank you for reading my project documentation. I appreciate your interest on this project. If you have any questions or feedback, please don't hesitate to reach out to me at karthiksaladi047@gmail.com

We hope that this documentation has provided you with the information you need to understand and use our project. I will continue to update and improve it as we receive feedback and make changes to the project.

Thank you again for your interest and support. I look forward to hearing from you.
