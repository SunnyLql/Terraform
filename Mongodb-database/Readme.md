# .tfvars contains sensitive information, save in s3 ,pull it when run pipeline.

## create job in jenkins, free-style , Choice Parameter, pipeline script is below

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
                 sh "git clone https://github.com/courtcanva/courtcanva-terraform.git"
           }
        }
        stage('terraform format check') {
            steps{
                sh 'cd courtcanva-terraform/database; terraform fmt'
            }
        }
        stage('terraform Init') {
            steps{
                sh 'aws s3 cp s3://cc-tfvars-for-pipeline/prod/terraform.tfvars courtcanva-terraform/database'
                sh 'cd courtcanva-terraform/database; terraform init -backend-config="key=${environment}/database/terraform.tfstate"'
                //sh 'cd courtcanva-terraform/backend; terraform workspace new ${environment}'
                //sh 'cd courtcanva-terraform/backend; terraform workspace select ${environment}'
                sh "cd courtcanva-terraform/database; terraform plan -out tfplan"
                sh 'cd courtcanva-terraform/database; terraform show -no-color tfplan > tfplan.txt'
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
                     def plan = readFile 'courtcanva-terraform/database/tfplan.txt'
                     input message: "Do you want to apply the plan?",
                     parameters: [text(name: 'Plan', description: 'Please review the plan', defaultValue: plan)]
                }
            }
        }

        stage('Apply') {
            steps{
                sh 'cd courtcanva-terraform/database; terraform apply -input=false tfplan'
               //sh 'cd courtcanva-terraform/database; terraform apply -destroy'
            }
        }
    }    
     post {
         
		   failure {
			       echo "failed "
			       emailext attachLog: true, 
		           body: '${DEFAULT_CONTENT}',
			       subject: '${PROJECT_NAME} - Build # ${BUILD_NUMBER} - ${BUILD_STATUS}!',
			       replyTo: 'wwwkiki0316@gmail.com',
			       to: 'wwwkiki0316@gmail.com' 	
	 	  }
		
		success {
			       echo "well done" 
			       emailext attachLog: false, 
			       body: '${DEFAULT_CONTENT}',                         
			       subject: '${PROJECT_NAME} - Build # ${BUILD_NUMBER} - ${BUILD_STATUS}!',
			       //replyTo: //'${DEVOPS_TEAM}',
			       to: 'wwwkiki0316@gmail.com'        
		}
	   // always {
       //              cleanWs()
       // }
    }
}```