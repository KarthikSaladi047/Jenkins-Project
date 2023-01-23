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
