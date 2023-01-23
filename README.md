# Project: CI/CD Pipeline for a Simple Node.js Application

## Overview
This project aims to demonstrate the implementation of a CI/CD pipeline for a simple Node.js application using Jenkins. The pipeline includes the following stages:
- Build: Compile and test the application code.
- Infra Provisioning : Using terraform provision Azure app service.
- Deploy: Deploy the application to a test environment.

## Tools and Technologies
- Jenkins: The CI/CD tool used to automate the pipeline.
- Node.js: The application is built with Node.js.
- npm: The package manager used for the application.
- Azure: Cloud provider used to host the application.
- Terraform: The Insfrastructure Provisioning tool used for provisioning App Service on Azure.

## Jenkins Pipeline
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

## Terraform configuration
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
  # Configuration options
}

resource "azurerm_resource_group" "Resource_Group" {
  name     = "React-JS-RG"
  location = "East US "
}

resource "azurerm_storage_account" "Storage" {
  name                     = "mystorage229929"
  resource_group_name      = azurerm_resource_group.Resource_Group.name
  location                 = azurerm_resource_group.Resource_Group.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_app_service_plan" "Service_Plan" {
  name                = "webapp-plan"
  location            = azurerm_resource_group.Resource_Group.location
  resource_group_name = azurerm_resource_group.Resource_Group.name

  sku {
    tier = "Basic"
    size = "B1"
  }
}

resource "azurerm_app_service" "App_Service" {
  name                = "nodejs-webapp"
  location            = azurerm_resource_group.Resource_Group.location
  resource_group_name = azurerm_resource_group.Resource_Group.name
  app_service_plan_id = azurerm_app_service_plan.Service_Plan.id

  app_settings = {
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false"
  }
}

```

