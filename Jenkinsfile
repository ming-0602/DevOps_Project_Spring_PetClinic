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
        stage('Test') {
            steps {
                bat 'mvn test -Dcheckstyle.skip=true'
            }
        }
        stage('Dependency Security Scan') {
            steps {
                bat 'dependency-check.bat --scan . --format HTML --out reports/'
            }
        }
        stage('Static Code Analysis') {
            steps {
                  bat 'mvn sonar:sonar -Dsonar.organization=DevOps-Pipeline-Project -Dsonar.host.url=https://sonarcloud.io -Dsonar.login=$SONAR_TOKEN'
            }
        }
    }
}
