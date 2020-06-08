pipeline {
  agent any
  environment {
    BUILDNUM = getBuildNum()
    DOCKER_REPO = "pavanraga"
    IMAGE_URL_WITH_TAG = "$DOCKER_REPO/app-${env.BRANCH_NAME}:$BUILDNUM"
    // KUBECONFIG = credentials(getKubeConfig(env.BRANCH_NAME))
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

    stage('push the image') {
      steps {
        withCredentials([string(credentialsId: 'dockerhubPwd', variable: 'dockerhubPwd')]) {
          sh "docker login -u pavanraga -p $dockerhubPwd"
          sh "docker push $IMAGE_URL_WITH_TAG"
          // sh "echo $KUBECONFIG"
        }
      }
    }
  
    stage('deploy to staging k8s') {
      when { branch 'master' }
      steps {
        withCredentials([file(credentialsId: 'wallet', variable: 'staging')]) {
          // replace the image name in yamls
          sh "find . -name *.yaml -name *.yml -exec sed -i 's/tagVersion/$BUILDNUM/g' {} +"
          // deploy the yamls
          sh "kubectl apply -R ."
        }
      }
    }

    stage('deploy to prod k8s') {
      when { branch 'release'}
      steps {
        withCredentials([file(credentialsId: 'wallet', variable: 'release')]) {
          // Update the kubeconfig for this cluster
          sh 'aws eks update-kubeconfig --name release'
          // replace the image name in yamls
          sh "find . -name '*.y*l' -exec sed -i 's/tagVersion/$BUILDNUM/g' {} +"
          // deploy the yamls
          sh "kubectl apply -R ."
        }
      }
    }
  }
}

post {
  success{
    slackSend (color: '#00FF00', message: "SUCCESSFUL: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")
  }
  failure {
    slackSend (color: '#00FF00', message: "FAILURE: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")
  }
}

def getBuildNum() {
  def tag = sh script: 'git rev-parse HEAD', returnStdout: true
  return tag
}

def getKubeConfig(branchname) {
  if("master".equals(branchname)) {
    return 'NEW-staging-kubeconfig'
  }
  else {
    return 'staging-kubeconfig'
  }
}