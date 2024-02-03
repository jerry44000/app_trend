pipeline {
    agent {
        node {
            label 'maven-worker'
        }
    }
    environment {
        MAVEN_HOME = '/opt/apache-maven-3.9.6'
    }
    stages {
        stage('Path env prep') {
            steps {
                script {
                    env.PATH = "${env.MAVEN_HOME}/bin:${env.PATH}"
                }
            }
        }
        stage('Build Artifact: Maven') {
            steps {
                sh 'mvn clean deploy'
            }
        }
        stage('SonarQube analysis') {
            environment {
                scannerHome = tool 'sonar-scanner'
            }
            steps {
                withSonarQubeEnv('sonarqube-server') { 
                    sh "${scannerHome}/bin/sonar-scanner"
                }
            }
        }
    }
}

