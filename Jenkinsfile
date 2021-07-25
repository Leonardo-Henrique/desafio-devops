pipeline {
    agent {
        dockerfile true 
    }
    stages {

        stage('Initialize'){
            def dockerHome = tool 'myDocker'
            env.PATH = "${dockerHome}/bin:${env.PATH}"
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