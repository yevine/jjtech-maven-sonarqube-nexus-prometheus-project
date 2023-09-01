pipeline {
    
//      agent {
//       node {
//     label 'jenkins-agent1'
//   }
// }
    
    agent {
        docker { image 'maven:3.8.6-openjdk-11' }
    }
    
    tools {
      maven 'maven'
    }

    stages {
        stage('git checkout') {
            steps {
                // Get some code from a GitHub repository
                 git branch: 'main', url: 'https://github.com/anselmenumbisia/jjtech-maven-sonarqube-nexus-prometheus-project.git'
            }

            }
        stage('test') {
            steps {
                dir('JavaWebApp/') {
                    echo 'performing mvn test'
                    sh 'mvn clean test'
                    
                }
                
            }

            }
          stage('approval') {
            steps {
                input "Please review the test and click 'Proceed' to apply it"
            }
        }

        stage('build') {
            steps {
                dir('JavaWebApp/') {
                    echo 'performing mvn build'
                    sh 'mvn clean package'
                    
                }
                    
                
            }
        }
        
    //     stage('SonarQube scanning') {
    //         steps {
    //             dir('JavaWebApp/') {
    //             withSonarQubeEnv('SonarQube') {
    //                 withCredentials([string(credentialsId: 'sonarqube-token', variable: 'SONAR_TOKEN')]) {
    //                     sh """
    //                 mvn sonar:sonar \
    //                 -Dsonar.projectKey=test-project \
    //                 -Dsonar.host.url=http://54.208.116.33:9000 \
    //                 -Dsonar.login=$SONAR_TOKEN
    //                 """
    //                 }
    //             }
    //         }
    //     }
    // }

    //     stage('Quality Gate') {
        //     steps {
        //         waitForQualityGate abortPipeline: true
        //     }
        // }

            stage('SonarQube scanning') {
            steps {
                dir('JavaWebApp/') {
                // withSonarQubeEnv('SonarQube') {
                    withCredentials([string(credentialsId: 'sonarqube-token', variable: 'SONAR_TOKEN')]) {
                        sh """
                    mvn sonar:sonar \
                     -Dsonar.projectKey=tower-project \
                     -Dsonar.host.url=http://172.31.80.37:9000 \
                     -Dsonar.login=$SONAR_TOKEN
                     """
                    }
                // }
            }
        }
    }

    }
}