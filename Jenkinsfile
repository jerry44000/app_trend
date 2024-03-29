def registry = 'https://shai01.jfrog.io'
def imageName = 'shai01.jfrog.io/shai01-docker-local/app_trend'
def version = '2.1.2'

pipeline {
    agent {
        node {
            label 'maven-worker'
        }
    }
    environment {
        MAVEN_HOME = '/opt/apache-maven-3.9.6'
        JAVA_HOME = '/usr/lib/jvm/java-1.17.0-openjdk-amd64'
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
                sh 'mvn clean deploy -Dmaven.test.skip=true'
            }
        }
        stage('Unit Tests: Unit & Surefire') {
            steps {
                sh 'mvn surefire-report:report'
            }
        }
        stage('SonarQube Analysis: SAST') {
            environment {
                scannerHome = tool 'sonar-scanner'
            }
            steps {
                withSonarQubeEnv('sonarqube-server') {
                    sh "${scannerHome}/bin/sonar-scanner"
                }
            }
        }
        stage('Quality Gates') {
            steps {
                script {
                    timeout(time: 1, unit: 'HOURS') {
                        def qg = waitForQualityGate()
                        if (qg.status != 'OK') {
                            error "Pipeline aborted due to Quality Gate failure: ${qg.status}"
                        }
                    }
                }
            }
        }
        stage("Jar Publish") {
            steps {
                script {
                    def server = Artifactory.newServer(url: "${registry}/artifactory", credentialsId: "artifact-cred")
                    def properties = "buildid=${env.BUILD_ID},commitid=${env.GIT_COMMIT}"
                    def uploadSpec = """{
                        "files": [
                            {
                                "pattern": "jarstaging/(*)",
                                "target": "shai01-libs-release-local/{1}",
                                "flat": "false",
                                "props": "${properties}",
                                "exclusions": ["*.sha1", "*.md5"]
                            }
                        ]
                    }"""
                    def buildInfo = server.upload(uploadSpec)
                    buildInfo.env.collect()
                    server.publishBuildInfo(buildInfo)
                }
            }
        }  
        stage('Docker Operations') {
            steps {
                script {
                    parallel dockerBuildAndPushToDockerHub: {
                        withDockerRegistry([credentialsId: "dockerhub-cred", url: ""]) {
                            sh 'docker build -t shaykube/app_trend:"$GIT_COMMIT" .'
                            sh 'docker push shaykube/app_trend:"$GIT_COMMIT"'
                        }
                    }, dockerBuildAndPushToArtifactory: {
                        def app = docker.build("${imageName}:${version}")
                        docker.withRegistry(registry, 'artifact-cred') {
                            app.push()
                        }
                    }, failFast: true 
                }
            }
        }
        stage('Prompte to PROD?') {
            steps {
                timeout(time: 2, unit: 'DAYS') {
                input 'Would you like to give your approval for the deployment to the production environment/namespace?'
                }
            }
        }
        stage('Deploy') {
            steps {
                script {
                    sh './deploy.sh'
                }
            }
        }

    }
}
