pipeline{  
    agent any  
    tools{  
        jdk 'java17'  
        terraform 'terraform'  
    }  
    environment {  
        SCANNER_HOME=tool 'sonar-scanner'  
    }  
    stages {  
        stage('clean workspace'){  
            steps{  
                cleanWs()  
            }  
        }  
        stage('Checkout from Git'){  
            steps{  
                git branch: 'main', url: 'https://github.com/karthi770/CICD_Terraform_DevSecOps.git'  
            }  
        }  
        stage('Terraform version'){  
             steps{  
                 sh 'terraform --version'  
                }  
        }  
        stage("Sonarqube Analysis "){  
            steps{  
                withSonarQubeEnv('sonar-server') {  
                    sh ''' $SCANNER_HOME/bin/sonar-scanner -Dsonar.projectName=Terraform \
                    -Dsonar.projectKey=Terraform '''  
                }  
            }  
        }  
        stage("quality gate"){  
           steps {  
                script {  
                    waitForQualityGate abortPipeline: false, credentialsId: 'Sonarqube-token'   
                }  
            }   
        }  
        stage('TRIVY FS SCAN') {  
            steps {  
                sh "trivy fs . > trivyfs.txt"  
            }  
        }  
        stage('Executable premission to website file'){
            steps{
                sh 'chmod 777 website.sh'
            }
        }
                stage('Terraform init'){
            steps{
                sh 'terraform init'
            }
        }
        stage('Terraform plan'){
            steps{
                sh 'terraform plan'
            }
        }
    }  
}