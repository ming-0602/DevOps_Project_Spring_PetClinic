pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                bat 'mvn clean package'
            }
        }
        stage('Test') {
            steps {
                bat 'mvn test'
            }
        }
        stage('Dependency Security Scan') {
            steps {
                bat 'dependency-check.bat --scan . --format HTML --out reports/'
            }
        }
    }
}
