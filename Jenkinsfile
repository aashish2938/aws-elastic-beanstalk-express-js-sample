pipeline {
    agent any

    environment {
        IMAGE_NAME = 'aashish2938/isec6000-assessment2'
        IMAGE_TAG = "${BUILD_NUMBER}"
    }

    stages {

        stage('Install Dependencies and Unit Tests') {
            agent {
                docker {
                    image 'node:16'
                    reuseNode true
                }
            }

            steps {
                echo 'Using Node.js 16 build environment'

                sh 'node --version'
                sh 'npm --version'

                echo 'Installing application dependencies'
                sh 'npm ci'

                echo 'Running unit tests'
                sh 'npm test'
            }
        }

        stage('Build Docker Image') {
            steps {
                echo 'Checking Docker connection'
                sh 'docker version'

                echo 'Building application Docker image'
                sh 'docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .'

                echo 'Docker image built successfully'
                sh 'docker images ${IMAGE_NAME}:${IMAGE_TAG}'
            }
        }

        stage('Save Docker Image for Scan') {
            steps {
                echo 'Saving Docker image for vulnerability scanning'

                sh '''
                    docker save ${IMAGE_NAME}:${IMAGE_TAG} \
                    -o app-image.tar
                '''

                sh 'ls -lh app-image.tar'
            }
        }

        stage('Security Scan') {
            steps {
                echo 'Scanning Docker image for HIGH and CRITICAL vulnerabilities'

                sh '''
                    docker run --rm \
                      -v "$WORKSPACE:/workspace" \
                      aquasec/trivy:latest \
                      image \
                      --input /workspace/app-image.tar \
                      --severity HIGH,CRITICAL \
                      --exit-code 1 \
                      --ignore-unfixed \
                      --scanners vuln
                '''
            }
        }
    }

    post {
        success {
            echo '========================================='
            echo 'PIPELINE SUCCESS'
            echo 'Unit tests passed.'
            echo 'Docker image built successfully.'
            echo 'Security gate passed.'
            echo 'No blocking HIGH/CRITICAL vulnerabilities were detected.'
            echo '========================================='
        }

        failure {
            echo '========================================='
            echo 'PIPELINE FAILED'
            echo 'Review the Jenkins console output above.'
            echo 'The failure may be caused by tests, Docker build, or the security gate.'
            echo '========================================='
        }

        always {
            echo "Pipeline completed for image: ${IMAGE_NAME}:${IMAGE_TAG}"
        }
    }
}
