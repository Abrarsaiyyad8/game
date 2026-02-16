pipeline {
  agent any

  environment {
    AWS_REGION = "ap-south-1"
    ACCOUNT_ID = "956437851385"
    REPO_NAME = "browser-game"
    REPO_URI = "${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${REPO_NAME}"
    APP_SERVER = "ubuntu@43.205.216.241"
    SSH_KEY = "/var/lib/jenkins/.ssh/game-key.pem"
  }

  

    stage('Build Docker Image') {
      steps {
        sh 'docker build -t ${REPO_NAME} .'
      }
    }

    stage('Login to ECR') {
      steps {
        sh '''
        aws ecr get-login-password --region $AWS_REGION \
        | docker login --username AWS --password-stdin $ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com
        '''
      }
    }

    stage('Tag Image') {
      steps {
        sh 'docker tag ${REPO_NAME}:latest ${REPO_URI}:latest'
      }
    }

    stage('Push Image to ECR') {
      steps {
        sh 'docker push ${REPO_URI}:latest'
      }
    }

    stage('Deploy to App Server') {
      steps {
        sh """
        ssh -o StrictHostKeyChecking=no -i ${SSH_KEY} ${APP_SERVER} '
          aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com &&
          docker pull ${REPO_URI}:latest &&
          docker stop game || true &&
          docker rm game || true &&
          docker run -d -p 80:80 --name game ${REPO_URI}:latest
        '
        """
      }
    }

  }
