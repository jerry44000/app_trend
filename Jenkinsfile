pipeline {
    agent {
        node {
            label 'maven-worker'
        }
    }

    stages {
        stage('clone code') {
            steps {
                git branch: 'main', url: 'https://github.com/jerry44000/app_trend.git'
            }
        }
    }
}
