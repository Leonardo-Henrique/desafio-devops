pipeline {
    agent none
    stages {

        stage('Build') {
            agent {
                docker {
                    image 'alpine:3.7'
                }
            }
            steps {
                sh 'docker build -t python-web-app .'
                sh 'docker run -it -p 5000:5000 python-web-app'

            }
        }

    }
}