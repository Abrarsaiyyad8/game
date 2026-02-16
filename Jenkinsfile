pipeline {
  agent any

  environment {
    AWS_REGION = "ap-south-1"
    ACCOUNT_ID = "956437851385"
    IMAGE_NAME = "browser-game"
    REPO_URI = "${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${IMAGE_NAME}"
  }

  stages {

  

    stage('Build Image') {
      steps {
        sh 'docker build -t $IMAGE_NAME .'
      }
    }

    stage('Login to ECR') {
  steps {
    withCredentials([[
      $class: 'AmazonWebServicesCredentialsBinding',
      credentialsId: 'aws-creds'
    ]]) {
      sh '''
      ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

      aws ecr get-login-password --region ap-south-1 \
      | docker login --username AWS --password-stdin $ACCOUNT_ID.dkr.ecr.ap-south-1.amazonaws.com
      '''
    }
  }
}


    stage('Tag Image') {
      steps {
        sh 'docker tag $IMAGE_NAME:latest $REPO_URI:latest'
      }
    }

    stage('Push Image') {
      steps {
        sh 'docker push $REPO_URI:latest'
      }
    }

    stage('Deploy to App Server') {
      steps {
        sh '''
        ssh -o StrictHostKeyChecking=no -i /var/lib/jenkins/.ssh/game-key.pem ubuntu@13.232.120.44 "
        docker pull $REPO_URI:latest &&
        docker stop game || true &&
        docker rm game || true &&
        docker run -d -p 80:80 --name game $REPO_URI:latest
        "
        '''
      }
    }
  }
}
