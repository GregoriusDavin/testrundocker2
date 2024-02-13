pipeline {
  agent any
  stages {
    stage('Check Version') {
     steps {
        sh 'docker compose version'
      }
    }
    stage('Login') {
      steps {
        sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
      }
    }

    stage('Pull') {
      steps {
        sh 'docker pull davingreg/laraveldavin'
      }
    }
    
    stage('deploy') {
      steps {
        script {
            kubernetesDeploy (configs: 'kubernet.yaml', kubeconfigId: 'kubeconfig')
        }
      }
    }
  }
  environment {
    DOCKERHUB_CREDENTIALS = credentials('davingreg-dockerhub')
  }
  
  post {
    always {
      sh 'docker logout'
    }
  }
}