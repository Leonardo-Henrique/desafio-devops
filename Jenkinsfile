pipeline {
    agent {
        docker {
            image 'ubuntu'
        }
    }
    stages {

        stage('Build') {
            steps {
                echo 'Running build phase. ' 
            }
        }

        stage('Run') {
            steps {
                echo 'Running run phase. ' 
            }
        }
    }
}