pipeline {
    agent {
        docker { image 'alpine:3.7' }
    }
    stages {

        stage('Build') {
            steps {
                sh 'docker build -t python-web-app .'
            }
        }

        stage('Run') {
            steps {
                sh 'docker build -t python-web-app .'
            }
        }
    }
}