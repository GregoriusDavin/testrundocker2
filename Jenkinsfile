pipeline {
  agent any
  stages {
    stage('Check Version') {
      parallel {
        stage('Check Version') {
          steps {
            sh 'docker compose version'
          }
        }

        stage('Check Code') {
          steps {
            git(url: 'https://github.com/GregoriusDavin/testrundocker.git', branch: 'master')
          }
        }

      }
    }

    stage('Login') {
      steps {
        sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
      }
    }

    stage('Build') {
      steps {
        sh 'docker context use default'
        sh 'docker compose build'
      }
    }

    stage('Push') {
      steps {
        sh 'docker push davingreg/laraveldavin:latest'
      }
    }

    stage('Delete Local Images') {
      steps {
        sh 'docker rmi -f $(docker images -aq)'
      }
    }

    stage('Delete Cache') {
      steps {
        sh 'docker builder prune -f'
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