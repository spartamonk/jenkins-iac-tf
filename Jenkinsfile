pipeline {
    agent any
    environment {
        AWS_REGION = 'us-east-1'
        WORKSPACE_NAME = 'test'
    }
    stages {
        stage('Checkout project') {
            steps {
                git branch: 'main', url: 'https://github.com/spartamonk/jenkins-iac-tf.git' 
            }
        }
        stage('Initialize Terraform') {
            steps {
                sh 'terraform init'
            }
        }
        stage('Switch to test workspace') {
            steps {
                script {
                    def workspaceExists = sh(
                        script: "terraform workspace list | grep -q ${WORKSPACE_NAME}",
                        returnStatus: true
                    ) == 0

                    if (!workspaceExists) {
                        sh "terraform workspace new ${WORKSPACE_NAME}"
                    } else {
                        sh "terraform workspace select ${WORKSPACE_NAME}"
                    }
            }
        }
        }
        stage('Plan terraform') {
            steps {
                sh 'terraform plan -var-file=/modules/env_vars/test.tfvars -out=tfplan'
            }
        }
        stage('Apply terraform') {
            steps{
                input message: "Approve deployment?", ok: "Deploy"
                sh 'terraform apply -var-file=/modules/env_vars/test.tfvars tfplan'
            }
        }
    }
}