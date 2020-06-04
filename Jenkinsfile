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
    // stage('test') {
    //   steps {
    //     sh 'python test.py'
    //   }
    // }
  }
}

def getBuildNum() {
  def tag = sh script: 'git rev-parse HEAD', returnStdout: true
  return tag
}