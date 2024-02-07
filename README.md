## Setup Jenkins Server

![image](https://github.com/karthi770/Hosting-Wordpress-AWS/assets/102706119/d99b8212-f184-4ad3-b898-1a2094791db8)
![image](https://github.com/karthi770/Hosting-Wordpress-AWS/assets/102706119/10973bef-d433-4478-ab32-e1bb987f34dc)

Installing the Jenkins Server:
```bash
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update
sudo apt-get install jenkins
```

Retrieving the Jenkins Secret password
```bash
cat /var/lib/jenkins/secrets/initialAdminPassword
```
Jenkins password: 9bd4198c8d374a2fbd8590aa742327ba

## Installing Docker

```bash
sudo apt-get update   
sudo apt-get install docker.io -y   
sudo usermod -aG docker $USER   
newgrp docker   
sudo chmod 777 /var/run/docker.sock
```

## Run sonarqube

```bash
docker run -d --name sonar -p 9000:9000 sonarqube:lts-community
```
If you check the docker containers running you can find the sonarqube container. Command is `docker ps`
![image](https://github.com/karthi770/Hosting-Wordpress-AWS/assets/102706119/75664d19-30ce-4559-b45a-5aee1c96a2d0)
pass: karthi770

## Installing Trivy

In the EC2 instance open vi text editor to add the commands to install Tivy
```bash
sudo vi trivy.sh
```
```bash
sudo apt-get install wget apt-transport-https gnupg lsb-release -y  
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | gpg --dearmor | sudo tee /usr/share/keyrings/trivy.gpg > /dev/null  
echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main" | sudo tee -a /etc/apt/sources.list.d/trivy.list  
sudo apt-get update  
sudo apt-get install trivy -y

sudo chmod +x trivy.sh

sh trivy.sh
```

## Plugins in Terraform

![image](https://github.com/karthi770/Hosting-Wordpress-AWS/assets/102706119/2bbb2378-60fc-4685-9020-4ae0b6bdb8d9)
Plugins that needs to be installed are:
- SonarQube Scanner
- Eclipse Temurin installer Plugin
- Terraform

## Install Terraform on Jenkins server

```bash
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform
```
```bash
which terraform
/usr/bin/terraform
```
We need to know the above path to use it in the tools section of Jenkins.

## Tools configuration in Jekins

### JDK
![image](https://github.com/karthi770/Hosting-Wordpress-AWS/assets/102706119/384776b6-4e12-44c0-a95f-8a67b754cfc3)
JDK installation
![image](https://github.com/karthi770/Hosting-Wordpress-AWS/assets/102706119/e9b56383-6fd5-4a59-9f48-9f365f65e15f)

### Terraform
![image](https://github.com/karthi770/Hosting-Wordpress-AWS/assets/102706119/b913471b-1a40-4f48-ab60-6b3c3634d295)

### Sonarqube
![image](https://github.com/karthi770/Hosting-Wordpress-AWS/assets/102706119/262680fb-61bb-43d3-9c8c-115563c67b4b)
>[!note]
>In order to configure sonarqube in Jenkins we need to go to Sonarqube -> Administrator → Security tab → users → click on Tokens → give a name and generate tokens. 

![image](https://github.com/karthi770/Hosting-Wordpress-AWS/assets/102706119/90f10f9c-1bdd-4c91-a123-e2ab340a5463)
![image](https://github.com/karthi770/Hosting-Wordpress-AWS/assets/102706119/12bcb284-97bf-4959-925a-4353d40db645)
![image](https://github.com/karthi770/Hosting-Wordpress-AWS/assets/102706119/64863aff-1067-4007-9295-4a32c9db90b2)
![image](https://github.com/karthi770/CICD_Terraform_DevSecOps/assets/102706119/8c93c2e5-ff87-4e2d-93f4-4cba8bdd11fb)
>[!note]
>make sure to give the right names in the Jenkins pipeline we are about to build.
#### Sonar webhooks
![image](https://github.com/karthi770/Hosting-Wordpress-AWS/assets/102706119/ac1c0d9b-d1cc-4bd1-82bf-6d26d11e0388)
![image](https://github.com/karthi770/Hosting-Wordpress-AWS/assets/102706119/7c4e8c61-6379-4d3d-9ee2-7f1adb619ff7)
>[!note]
>Click on “create” and create the webhook
>In the end of the Jenkins URL we need to add the “/sonarqube-webhook/”
>

### Terraform State file storage and state locking

#### Creating IAM role
![image](https://github.com/karthi770/Hosting-Wordpress-AWS/assets/102706119/d82d0fdc-c9f5-4400-ae89-37627e84b7f9)
![image](https://github.com/karthi770/Hosting-Wordpress-AWS/assets/102706119/592eb19b-cbda-4e5a-baa1-582da7e0c601)
Edit the IAM role of the EC2 instance
![image](https://github.com/karthi770/Hosting-Wordpress-AWS/assets/102706119/2a64af16-b00b-403a-815f-3aed38d16303)

### Create an S3 bucket
This bucket is to store the terraform statefile
![image](https://github.com/karthi770/Hosting-Wordpress-AWS/assets/102706119/eaa8c43f-82a1-41fb-bf96-43de39faa312)

### Create DynamoDB
This table is created to lock the terraform statefile
![image](https://github.com/karthi770/Hosting-Wordpress-AWS/assets/102706119/3f421ec6-5463-4932-a088-e033cfb26eab)
>[!note]
>Make sure the partition key is same as the format shown above.

### Docker Configuration 

![image](https://github.com/karthi770/Hosting-Wordpress-AWS/assets/102706119/e35f4c5f-4b84-4647-af59-fde633fc39dd)
![image](https://github.com/karthi770/Hosting-Wordpress-AWS/assets/102706119/b6e57c4b-f2eb-4e2f-9b5c-83558783a863)

![image](https://github.com/karthi770/Hosting-Wordpress-AWS/assets/102706119/0cd83eca-101d-49a4-9f96-962cec2c881c)
![image](https://github.com/karthi770/Hosting-Wordpress-AWS/assets/102706119/1c030994-a0a4-4b2e-8352-3d1b4eeec4db)

### Terraform codes

```python
#provider.tf
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  required_version = ">= 1.2.0"
}

provider "aws" {
  region = var.aws_region
}
```

```python
#main.tf
resource "aws_instance" "website" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.ec2_security_group.id]
  user_data              = base64encode(file("../website.sh"))
  tags = {
    Name = "web-EC2"
  }
}

resource "aws_security_group" "ec2_security_group" {
  name        = "ec2 security group"
  description = "allow access on ports 80 and 22 and 443"

  ingress {
    description      = "ssh access"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 0    # Allow all ports
    protocol    = "-1" # All protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description      = "https"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "http"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "web_sg"
  }
}
```

### Jenkins Pipeline
![image](https://github.com/karthi770/CICD_Terraform_DevSecOps/assets/102706119/0128aff1-d190-40be-9f0f-33d8c6d08d81)
```groovy
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
                    waitForQualityGate abortPipeline: false, credentialsId: 'Sonar-token'   
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
        stage('Terraform action'){
            steps{
                sh'terraform ${action} --auto-approve'
            }
        }  
    }  
}
```

>[!important] 
>add ubuntu as a user to the sudo group since the we need permissions to execute the website.sh file.
`sudo usermod -aG sudo ubuntu`  
`sudo apt update`


![image](https://github.com/karthi770/CICD_Terraform_DevSecOps/assets/102706119/daca46b8-c2ed-435f-9208-3711fc42b9d8)

In order for jenkins to give us the option to apply and destroy, we need to parameterize some of the commands.
![image](https://github.com/karthi770/Hosting-Wordpress-AWS/assets/102706119/becf5d51-7a1b-4689-b1ce-f63fa174ada3)
![image](https://github.com/karthi770/Hosting-Wordpress-AWS/assets/102706119/92af8b20-bd6f-4d9e-b335-5b76e4f8e266)

![image](https://github.com/karthi770/Hosting-Wordpress-AWS/assets/102706119/8e178ae2-941f-463f-a740-4268cfcd596a)
>[!info]
>Now the build option comes with “Build with Parameters”

![image](https://github.com/karthi770/Hosting-Wordpress-AWS/assets/102706119/662799c7-d6c4-404c-96c4-ec2c51aab914)
>[!info]
>If we click on it we can see the option to apply and destroy

![image](https://github.com/karthi770/Hosting-Wordpress-AWS/assets/102706119/f04c082b-ffad-4117-b61b-9034eb90fc51)



### Results

![image](https://github.com/karthi770/Hosting-Wordpress-AWS/assets/102706119/20a9c96c-1a51-4bc6-8cc8-e0ab1531d493)
![image](https://github.com/karthi770/Hosting-Wordpress-AWS/assets/102706119/cdb76b13-a3f0-4f44-808e-f26bfc7a73b7)

![image](https://github.com/karthi770/Hosting-Wordpress-AWS/assets/102706119/3affd1a2-0d84-4bd0-8298-c5b8ef33c8e1)
![image](https://github.com/karthi770/Hosting-Wordpress-AWS/assets/102706119/651877d7-8ac5-49e2-9d16-943a868cd05f)

![image](https://github.com/karthi770/Hosting-Wordpress-AWS/assets/102706119/3a2243b3-9c35-4237-a2a2-c9b433527e11)
![image](https://github.com/karthi770/Hosting-Wordpress-AWS/assets/102706119/a9e3eb14-1441-42c8-9e6c-6e95c42d7c36)
![image](https://github.com/karthi770/Hosting-Wordpress-AWS/assets/102706119/30fc519d-3450-4b1a-9002-dfa5194c9af4)
