pipeline {
    agent any

    environment {
        AWS_REGION = "ap-south-1"
        ACCOUNT_ID = "956437851385"

        FRONTEND_REPO = "browser-game-frontend"
        BACKEND_REPO  = "browser-game-backend"

        FRONTEND_URI = "${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${FRONTEND_REPO}"
        BACKEND_URI  = "${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${BACKEND_REPO}"

        APP_SERVER = "ubuntu@43.205.216.241"
        SSH_KEY    = "/var/lib/jenkins/.ssh/game-key.pem"
    }

    stages {
        stage('Checkout Code') {
            steps {
                git 'https://github.com/Abrarsaiyyad8/game.git'
            }
        }

        stage('Build Frontend Image') {
            steps {
                dir('frontend') {
                    sh 'docker build -t ${FRONTEND_REPO} .'
                }
            }
        }

        stage('Build Backend Image') {
            steps {
                dir('backend') {
                    sh 'docker build -t ${BACKEND_REPO} .'
                }
            }
        }

        stage('Login to ECR') {
            steps {
                sh '''
                aws ecr get-login-password --region ${AWS_REGION} | \
                docker login --username AWS --password-stdin ${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com
                '''
            }
        }

        stage('Tag Images') {
            steps {
                sh '''
                docker tag ${FRONTEND_REPO}:latest ${FRONTEND_URI}:latest
                docker tag ${BACKEND_REPO}:latest  ${BACKEND_URI}:latest
                '''
            }
        }

        stage('Push Images to ECR') {
            steps {
                sh '''
                docker push ${FRONTEND_URI}:latest
                docker push ${BACKEND_URI}:latest
                '''
            }
        }

        stage('Deploy to App Server') {
            steps {
                sh '''
ssh -o StrictHostKeyChecking=no -i ${SSH_KEY} ${APP_SERVER} << EOF
set -e

echo "Logging into ECR on App Server..."
aws ecr get-login-password --region ${AWS_REGION} | \
docker login --username AWS --password-stdin ${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com

echo "Pulling latest images..."
docker pull ${FRONTEND_URI}:latest
docker pull ${BACKEND_URI}:latest

echo "Stopping old containers..."
docker rm -f game-frontend || true
docker rm -f game-backend || true

echo "Starting backend container..."
docker run -d -p 3000:3000 --name game-backend ${BACKEND_URI}:latest

echo "Starting frontend container..."
docker run -d -p 80:80 --name game-frontend ${FRONTEND_URI}:latest

echo "Deployment Complete!"
EOF
'''
            }
        }
    }
}
