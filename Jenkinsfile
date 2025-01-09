pipeline {
    agent any
    environment {
        AWS_REGION = 'us-east-1'
    }
    stages {
        stage('Checkout project') {
            steps {
                git branch: 'main', url: 'https://github.com/spartamonk/new-jenkins-terraform.git' 
            }
        }
        stage('Initialize Terraform') {
            steps {
                sh 'terraform init'
            }
        }
        stage('Create test workspace') {
            steps {
                sh 'terraform workspace new test'
            }
        }
        stage('Plan terraform') {
            steps {
                sh 'terraform plan -out=tfplan'
            }
        }
        stage('Apply terraform') {
            steps{
                input message: "Approve deployment?", ok: "Deploy"
                sh 'terraform apply -var-file=/env_vars/test.tfvars tfplan'
            }
        }
    }
}