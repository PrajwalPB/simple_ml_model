pipeline {
    agent any
    environment {
        AWS_ACCOUNT_ID = ""
        AWS_DEFAULT_REGION= "us-east-1"
        IMAGE_REPO_NAME = "test-model"
        IMAGE_TAG = "latest"
        REPOSITORY_URI = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonawscom"
    }

    stages {
        stage('Hello') {
            steps {
                echo 'Starting the pipeline'
            }
        }
        stage('Code checkout stage') {
            steps {
                checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[credentialsId: 'vault-github', url: 'https://github.com/PrajwalPB/simple_ml_model.git']])
            }
        }
        stage('Image Building') {
            steps {
                script {
                    dockerImage = docker.build "${IMAGE_REPO_NAME}:${IMAGE_TAG}"
                }
            }
        }
        stage('Logging into AWS ECR') {
            steps {
                sh "aws ecr get-login-password --region ${AWS_DEFAULT_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com/${IMAGE_REPO_NAME}"
            }
        }
        stage('Pushing to ECR') {
            steps {
                sh "docker tag ${IMAGE_REPO_NAME}:${IMAGE_TAG} ${REPOSITORY_URI}/${IMAGE_REPO_NAME}:${BUILD_NUMBER}"
                sh "docker push ${REPOSITORY_URI}/${IMAGE_REPO_NAME}:${BUILD_NUMBER}"
            }


        }
    }
}
