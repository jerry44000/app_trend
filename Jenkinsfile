pipeline {
    agent {
        node {
            label 'maven-worker'
        }
    }

environment {
    PATH+MAVEN = '/opt/apache-maven-3.9.6/bin'
}

    stages {
       stage('Build Artifact: Maven') {
        steps {
            sh 'mvn clean deploy'
        }
       }
    }
}
