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
        sh '''
        aws ecr get-login-password --region $AWS_REGION \
        | docker login --username AWS --password-stdin $REPO_URI
        '''
      }
    }


   stage('Deploy to EC2') {
            steps {
                sh '''
                ssh -o StrictHostKeyChecking=no -i /var/lib/jenkins/.ssh/game-key.pem ubuntu@43.205.216.241 << EOF

                aws ecr get-login-password --region $REGION | \
                docker login --username AWS --password-stdin 956437851385.dkr.ecr.ap-south-1.amazonaws.com

                docker pull $REPO_URI:latest

                docker stop game || true
                docker rm game || true

                docker run -d -p 80:80 --name game $REPO_URI:latest

                EOF
                '''
            }
        }

    }
}
