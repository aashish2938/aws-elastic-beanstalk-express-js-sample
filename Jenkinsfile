pipeline {
    agent {
        docker {
            image 'node:16'
            reuseNode true
        }
    }

    environment {
        IMAGE_NAME = 'aashish2938/isec6000-assessment2'
        IMAGE_TAG = "${BUILD_NUMBER}"
    }

    stages {
        stage('Install Dependencies') {
            steps {
                sh 'npm ci'
            }
        }

        stage('Unit Tests') {
            steps {
                sh 'npm test'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .'
            }
        }

        stage('Security Scan') {
            steps {
                sh '''
                    docker run --rm \
                      -v /var/run/docker.sock:/var/run/docker.sock \
                      aquasec/trivy:latest \
                      image \
                      --severity HIGH,CRITICAL \
                      --exit-code 1 \
                      --ignore-unfixed \
                      ${IMAGE_NAME}:${IMAGE_TAG}
                '''
            }
        }
    }

    post {
        success {
            echo 'Build, tests and security scan completed successfully.'
        }

        failure {
            echo 'Pipeline failed. Review the Jenkins console output.'
        }
    }
}
