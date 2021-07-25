pipeline {
    agent {
        dockerfile true 
    }
    stages {


        stage('initial') {
            steps {
                sh 'docker run'
            }
        }

        stage('Build') {
            steps {
                sh 'docker build -t python-web-app .'
            }
        }

        stage('Run') {
            steps {
                sh 'docker run -it -p 5000:5000 python-web-app'
            }
        }
    }
}