pipeline {
  agent any
  environment {
    BUILDNUM = getBuildNum()
    DOCKER_REPO = "pavanraga"
    IMAGE_URL_WITH_TAG = "$DOCKER_REPO/app:$BUILDNUM"
  }
  stages {
    stage('build docker image') {
      steps {
        sh "docker build . -t $IMAGE_URL_WITH_TAG"
      }
    }
    stage('test') {
      steps {
        withDockerContainer('$IMAGE_URL_WITH_TAG') {
          sh 'python3 test.py'
        }
      }
    }
    stage('push the image'){
      steps {
        withCredentials([string(credentialsId: 'dockerhubPwd', variable: 'dockerhubPwd')]) {
          sh "docker login -u pavanraga -p $dockerhubPwd"
          sh "docker push $IMAGE_URL_WITH_TAG"
        }
      }
    }
  }
}

def getBuildNum() {
  def tag = sh script: 'git rev-parse HEAD', returnStdout: true
  return tag
}