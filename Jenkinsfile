pipeline {
    agent any

    tools {
        tool name: 'terraform', type: 'terraform'
        tool name: 'maven', type: 'maven'
    }

    stages {
        stage('git checkout') {
            steps {
                // Get some code from a GitHub repository
                git branch: 'main', credentialsId: 'git', url: 'https://github.com/anselmenumbisia/jjtech-maven-sonarqube-nexus-prometheus-project.git'
                
            }

            }
        stage('test') {
            steps {
                dir('JavaWebApp/pom.xml') {
                    echo 'performing mcn test'
                    sh 'mvn test'
                    
                }
                
            }

            }
        stage('build') {
            steps {
                dir('JavaWebApp/pom.xml') {
                    sh 'mvn package'
                    
                }
                
            }
        }
    }
}
