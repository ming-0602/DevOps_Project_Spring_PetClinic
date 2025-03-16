// pipeline {
//     agent any
//     environment {
//             SONAR_TOKEN = credentials('SonarCloud-Token') // Store in Jenkins Credentials
//             AWS_ACCESS_KEY_ID = credentials('aws_access_key_id')
//             AWS_SECRET_ACCESS_KEY = credentials('aws_secret_access_key')
//             AWS_SESSION_TOKEN = credentials('aws_session_token')
//             AWS_REGION = "us-east-1"
//             ECR_REPO = "805755495314.dkr.ecr.us-east-1.amazonaws.com/my-app"
//     }
//     stages {
//         stage('Build') {
//             steps {
//                 bat 'mvn clean package -Dcheckstyle.skip=true'
//             }
//         }
//         stage('Test') {
//             steps {
//                 bat 'mvn test -DskipTests=true -DskipITs=true -Dspring.profiles.active=default  -Dcheckstyle.skip=true'
//             }
//         }
//         stage('Verify JAR Exists') {
//             steps {
//                 script {
//                     bat 'echo "Current Jenkins Workspace: %CD%"'  // Print the current Jenkins directory
//                     bat 'dir'  // List all files and folders in the current workspace
//                     bat 'dir target'  // List all files inside the target directory
//                     def jarExists = fileExists 'target/spring-petclinic-3.4.0-SNAPSHOT.jar'
//                     if (!jarExists) {
//                         error "ERROR: JAR file not found in target directory! Build failed."
//                     } else {
//                         echo "JAR file found. Proceeding with deployment."
//                     }
//                 }
//             }
//         }
// //         stage('Test') {
// //             steps {
// //                 bat 'mvn test -DskipITs=true -Dspring.profiles.active=default  -Dcheckstyle.skip=true'
// //             }
// //         }
//         stage('Dependency Security Scan') {
//             steps {
//                 bat 'dependency-check.bat --scan . --format HTML --out reports/'
//             }
//         }
//         stage('Static Code Analysis') {
//             steps {
//                 bat 'set SONAR_TOKEN=%SONAR_TOKEN%' // Explicitly set token
//                 bat 'mvn sonar:sonar -Dsonar.projectKey=ming-0602_DevOps_Project_Spring_PetClinic -Dsonar.organization=devops-pipeline-project -Dsonar.host.url=https://sonarcloud.io -Dsonar.login=%SONAR_TOKEN%'
//             }
//         }
// //         stage('Docker Build') {
// //             steps {
// //                 bat 'if not exist target\\*.jar exit 1' // Fails pipeline if JAR is missing
// //                 bat 'docker build -t my-app:latest .'
// //             }
// //         }
//         stage('Docker Build') {
//             steps {
//                 script {
//                     def jarPath = "target/spring-petclinic-3.4.0-SNAPSHOT.jar"
//                     def workspace = env.WORKSPACE
//
//                     // Print JAR existence
//                     bat "echo Checking JAR file at ${workspace}\\${jarPath}"
//                     bat "dir target"
//
//                     // Ensure the JAR file exists
//                     def jarExists = fileExists(jarPath)
//                     if (!jarExists) {
//                         error "ERROR: JAR file not found in target directory! Docker build cannot proceed."
//                     }
//
//                     // Run Docker build command
//                     bat "docker build -t my-app:latest --build-arg JAR_FILE=${jarPath} ."
//                 }
//             }
//         }
//
//         stage('Trivy Scan') {
//             steps {
//                 script {
//                     def trivyPath = "C:\\ProgramData\\chocolatey\\bin\\trivy.exe" // Adjust based on where.exe result
//                     bat "\"${trivyPath}\" image --severity HIGH,CRITICAL my-app:latest"
//                 }
//             }
//         }
//
//         stage('Authenticate with AWS ECR') {
//             steps {
//                 script {
//                     bat '''
//                     aws configure set aws_access_key_id %AWS_ACCESS_KEY_ID%
//                     aws configure set aws_secret_access_key %AWS_SECRET_ACCESS_KEY%
//                     aws configure set aws_session_token %AWS_SESSION_TOKEN%
//                     aws configure set region %AWS_REGION%
//                     aws ecr get-login-password --region %AWS_REGION% | docker login --username AWS --password-stdin %ECR_REPO%
//                     '''
//                 }
//             }
//         }
//
//         stage('Tag & Push to AWS ECR') {
//             steps {
//                 script {
//                     bat '''
//                     docker tag my-app:latest %ECR_REPO%:latest
//                     docker push %ECR_REPO%:latest
//                     '''
//                 }
//             }
//         }
//
//
//     }
// }
//
// ///////////////////////////////////////

pipeline {
    agent any
    environment {
        SONAR_TOKEN = credentials('SonarCloud-Token') // Store in Jenkins Credentials
        AWS_ACCESS_KEY_ID = credentials('aws_access_key_id')
        AWS_SECRET_ACCESS_KEY = credentials('aws_secret_access_key')
        AWS_SESSION_TOKEN = credentials('aws_session_token')
        AWS_REGION = "us-east-1"
        ECR_REPO = "805755495314.dkr.ecr.us-east-1.amazonaws.com/my-app"
        TRIVY_PATH = "C:\\ProgramData\\chocolatey\\bin\\trivy.exe" // Adjusted for Windows
    }

    stages {
        stage('Checkout Code') {
            steps {
                git 'https://github.com/ming-0602/DevOps_Project_Spring_PetClinic.git'
            }
        }

        stage('Build Application') {
            steps {
                bat 'mvn clean package -Dcheckstyle.skip=true'
            }
        }

        stage('Verify JAR Exists') {
            steps {
                script {
                    def jarPath = "target/spring-petclinic-3.4.0-SNAPSHOT.jar"
                    def workspace = env.WORKSPACE

                    bat "echo Checking JAR file at ${workspace}\\${jarPath}"
                    bat "dir target"

                    def jarExists = fileExists(jarPath)
                    if (!jarExists) {
                        error "ERROR: JAR file not found in target directory! Build failed."
                    }
                }
            }
        }

        stage('Dependency Security Scan') {
            steps {
                bat 'dependency-check.bat --scan . --format HTML --out reports/'
            }
        }

        stage('Static Code Analysis') {
            steps {
                bat 'set SONAR_TOKEN=%SONAR_TOKEN%'
                bat 'mvn sonar:sonar -Dsonar.projectKey=ming-0602_DevOps_Project_Spring_PetClinic -Dsonar.organization=devops-pipeline-project -Dsonar.host.url=https://sonarcloud.io -Dsonar.login=%SONAR_TOKEN%'
            }
        }

        stage('Docker Build') {
            steps {
                script {
                    def jarPath = "target/spring-petclinic-3.4.0-SNAPSHOT.jar"
                    def workspace = env.WORKSPACE

                    bat "echo Checking JAR file at ${workspace}\\${jarPath}"
                    bat "dir target"

                    def jarExists = fileExists(jarPath)
                    if (!jarExists) {
                        error "ERROR: JAR file not found in target directory! Docker build cannot proceed."
                    }

                    bat "docker build -t my-app:latest --build-arg JAR_FILE=${jarPath} ."
                }
            }
        }

        stage('Trivy Security Scan') {
            steps {
                script {
                    bat "\"%TRIVY_PATH%\" image --severity HIGH,CRITICAL my-app:latest"
                }
            }
        }

        stage('Authenticate with AWS ECR') {
            steps {
                script {
                    bat '''
                    aws configure set aws_access_key_id %AWS_ACCESS_KEY_ID%
                    aws configure set aws_secret_access_key %AWS_SECRET_ACCESS_KEY%
                    aws configure set aws_session_token %AWS_SESSION_TOKEN%
                    aws configure set region %AWS_REGION%
                    aws ecr get-login-password --region %AWS_REGION% | docker login --username AWS --password-stdin %ECR_REPO%
                    '''
                }
            }
        }

        stage('Tag & Push to AWS ECR') {
            steps {
                script {
                    bat '''
                    docker tag my-app:latest %ECR_REPO%:latest
                    docker push %ECR_REPO%:latest
                    '''
                }
            }
        }
//                     cd C:\\Users\\mingx\\.jenkins\\workspace\\spring-petclinic-ci\\ansible-project
        stage('Deploy to AWS EC2') {
            steps {
                script {
                    sh '''
                    ssh -o StrictHostKeyChecking=no -i C:/Users/mingx/.ssh/DevOpsDeploy.pem ec2-user@54.235.40.107 << 'EOF'
                    cd ~/ansible-project
                    ansible-playbook -i inventory.ini deploy-app.yml
                    EOF
                    '''
                }
            }
        }
    }
}
