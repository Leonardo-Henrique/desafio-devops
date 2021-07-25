pipeline {
    agent {
        dockerfile true 
    }
    stages {

        stage('Build') {
            steps {
                agent any
                sh 'docker build -t python-web-app .'
            }
        }

        stage('Run') {
            agent any
            steps {
                sh 'docker run -it -p 5000:5000 python-web-app'
            }
        }
    }
}