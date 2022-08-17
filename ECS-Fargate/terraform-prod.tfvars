aws_region = "ap-southeast-2"

name = "CCS-F"

env = "PROD"

ecs_task_execution_role_name = "myEcsTaskExecutionRole"

az_count = "2"

app_image = "497551902879.dkr.ecr.ap-southeast-2.amazonaws.com/backend-dockerimage-repo:4-3c81680-2022-06-09-21-00"

app_port = "8080"

app_count = 1

health_check_path = "/api-docs"

fargate_cpu = "1024"

fargate_memory = "2048"

website_name = "api.courtcanva.com"

vpc_cidr_block = "172.18.0.0/16"

statefilepath = "prod/backend/terraform.tfstate"

