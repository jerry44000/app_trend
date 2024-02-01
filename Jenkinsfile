pipeline {
    agent {
        node {
            label 'maven-worker'
        }
    }
    environment {
        // Définir une variable d'environnement pour Maven, mais pas manipuler PATH ici directement
        MAVEN_HOME = '/opt/apache-maven-3.9.6'
    }
    stages {
        stage('Preparation') {
            steps {
                // Utiliser script pour définir PATH ou directement dans les étapes où Maven est requis
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
    }
}
