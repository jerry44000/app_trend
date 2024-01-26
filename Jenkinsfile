pipeline {
    agent {
        node {
            label 'maven-worker'
        }
    }

environment {
    PATH = '/opt/apache-maven-3.9.2/bin:$PATH'
}

    stages {
       stage('Build Artifact: Maven') {
        steps {
            sh 'mvn clean deploy'
        }
       }
    }
}
