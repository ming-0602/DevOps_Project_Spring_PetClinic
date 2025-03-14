pipeline {
    agent any
    environment {
            SONAR_TOKEN = credentials('SonarCloud-Token') // Store in Jenkins Credentials
    }
    stages {
        stage('Build') {
            steps {
                bat 'mvn clean package -Dcheckstyle.skip=true'
            }
        }
        stage('Verify JAR Exists') {
            steps {
                script {
                    def jarExists = fileExists 'target/spring-petclinic-3.4.0-SNAPSHOT.jar'
                    if (!jarExists) {
                        error "❌ ERROR: JAR file not found in target directory! Build failed."
                    }
                }
            }
        }
        stage('Test') {
            steps {
                bat 'mvn test -DskipTests=true -DskipITs=true -Dspring.profiles.active=default  -Dcheckstyle.skip=true'
            }
        }
//         stage('Test') {
//             steps {
//                 bat 'mvn test -DskipITs=true -Dspring.profiles.active=default  -Dcheckstyle.skip=true'
//             }
//         }
        stage('Dependency Security Scan') {
            steps {
                bat 'dependency-check.bat --scan . --format HTML --out reports/'
            }
        }
        stage('Static Code Analysis') {
            steps {
                bat 'set SONAR_TOKEN=%SONAR_TOKEN%' // Explicitly set token
                bat 'mvn sonar:sonar -Dsonar.projectKey=ming-0602_DevOps_Project_Spring_PetClinic -Dsonar.organization=devops-pipeline-project -Dsonar.host.url=https://sonarcloud.io -Dsonar.login=%SONAR_TOKEN%'
            }
        }
//         stage('Docker Build') {
//             steps {
//                 bat 'if not exist target\\*.jar exit 1' // Fails pipeline if JAR is missing
//                 bat 'docker build -t my-app:latest .'
//             }
//         }
        stage('Docker Build') {
            steps {
                script {
                    def jarExists = fileExists 'target/*.jar'
                    if (!jarExists) {
                        error "ERROR: No JAR file found in target directory! Build failed."
                    }
                }
                bat 'docker build -t my-app:latest .'
            }
        }
        stage('Trivy Scan') {
            steps {
                bat 'trivy image --severity HIGH,CRITICAL my-app:latest'
            }
        }
    }
}
