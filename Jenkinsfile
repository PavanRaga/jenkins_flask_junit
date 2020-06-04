pipeline {
  agent any
  environment {
    BUILDNUM = getBuildNum()
    DOCKER_REPO = "pavanraga"
    IMAGE_URL_WITH_TAG = "$DOCKER_REPO/app-${env.BRANCH_NAME}:$BUILDNUM"
    KUBECONFIG = env.BRANCH_NAME == "master" ? credentials('NEW-staging-kubeconfig') : credentials('staging-kubeconfig')
  }
  stages {
    stage('build docker image') {
      steps {
        sh "docker build . -t $IMAGE_URL_WITH_TAG"
      }
    }

    // stage('test') {
    //   agent {
    //     docker {
    //       image "$IMAGE_URL_WITH_TAG"
    //       reuseNode true
    //     }
    //   }
    //   steps {
    //     // withDockerContainer("$IMAGE_URL_WITH_TAG") {
    //     //   sh 'python3 test.py'
    //     // }
    //     // sh 'pip install flask'
    //     sh 'python test.py'
    //   }
    // }

    stage('push the image'){
      steps {
        withCredentials([string(credentialsId: 'dockerhubPwd', variable: 'dockerhubPwd')]) {
          sh "docker login -u pavanraga -p $dockerhubPwd"
          sh "docker push $IMAGE_URL_WITH_TAG"
          sh "echo $KUBECONFIG"
        }
      }
    }
  }
}

def getBuildNum() {
  def tag = sh script: 'git rev-parse HEAD', returnStdout: true
  return tag
}