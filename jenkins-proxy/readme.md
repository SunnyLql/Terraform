# jenkins-master for CICD , Set ALB , lauch with userdata ,with ssl,rout53

#.tfvars : save in s3, or in jenkins ec2 

# create job in jenkins, free-style ,pipeline script is below

```pipeline {
    agent any
    tools {
          terraform 'Terraform'
    }
    stages {
         stage('Cleanup Workspace') {
            steps {
                 cleanWs()
              echo "Cleaned Up Workspace For Project"
             }
         }
         stage('Git checkout') {
          steps{
                  sh "git clone https://github.com/SunnyLql/Terraform.git"
          }
         }
         stage('terraform format check') {
             steps{
                 sh 'cd Terraform/jenkins-proxy; terraform fmt'
            }
        }
        stage('terraform Init') {
            steps{
                sh 'cd Terraform/jenkins-proxy; terraform init'
                //sh 'cd Terraform/jenkins-proxy; terraform workspace new ${environment}'
                //sh 'cd Terraform/jenkins-proxy; terraform workspace select ${environment}'
                sh "cd Terraform/jenkins-proxy; terraform plan -input=false -out tfplan "
                sh 'cd Terraform/jenkins-proxy; terraform show -no-color tfplan > tfplan.txt'
            }
        }
         stage('Approval') {
             when {
                 not {
                      equals expected: true, actual: params.autoapprove
                 }
             }

             steps {
                 script {
                      def plan = readFile 'Terraform/jenkins-proxy/tfplan.txt'
                      input message: "Do you want to apply the plan?",
                      parameters: [text(name: 'Plan', description: 'Please review the plan', defaultValue: plan)]
                 }
             }        
         }
         stage('Apply') {
             steps{
                 sh 'cd Terraform/jenkins-proxy; terraform apply -input=false tfplan'
             }
         }
    }
}```
