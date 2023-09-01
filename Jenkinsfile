pipeline{
    agent any
    tools{
        jdk 'jdk11'
        maven 'maven3'
    }
    stages{
        stage('clean workspace'){
            steps{
                cleanWs()
            }
        }
        stage('checkout scm'){
            steps{
                checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/Harsha8464/petclinic-Real.git']])
            }
        }
        stage('Maven Compile'){
            steps{
                sh 'mvn clean compile'
            }
        }
        stage('sonarqube Analysis'){
            steps{
                script{
                    withSonarQubeEnv(credentialsId: 'sonar-token') {
                    sh 'mvn sonar:sonar'
                }
            }
        }
    }
        stage('Quality Gate'){
            steps{
                script{
                    waitForQualityGate abortPipeline: false, credentialsId: 'sonar-token'
                }
            }
        }
        stage('OWASP Dependency-Check Vulnerabilities'){
            steps{
                dependencyCheck additionalArguments: '--scan ./ --format HTML', odcInstallation: 'DP-Check'
                dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
            }
        }     
        stage('Build war file'){
            steps{
                sh 'mvn clean install package'
            }
        }
        stage('Build and push to Dockerhub'){
            steps{
                script{
                    withDockerRegistry(credentialsId: 'dokcer', toolName: 'docker') {
                        sh 'docker build -t petclinic1 .'
                        sh 'docker tag petclinic1 harshavardhan19/pet-clinic123:latest'
                        sh 'docker push harshavardhan19/pet-clinic123:latest'
                    }
                }
            }
        }
        stage('TRIVY'){
            steps{
                sh 'trivy image harshavardhan19/pet-clinic123:latest'
            }
        }
        stage('Deploy to container'){
            steps{
                sh 'docker run -d --name pet1 -p 8082:8080 harshavardhan19/pet-clinic123:latest'
            }
        }
    }
}
