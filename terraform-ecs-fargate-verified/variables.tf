# variables.tf

variable "aws_region" {
  description = "The AWS region things are created in"
  
}

variable "name"{
  description = "name of this project"
  default   ="CCSL"
}

variable "env"{
  description = "environment of this project"
  default   ="UAT"
}
variable "ecs_task_execution_role_name" {
  description = "ECS task execution role name"
  default = "myEcsTaskExecutionRole"
}

variable "az_count" {
  description = "Number of AZs to cover in a given region"
  default     = "2"
}

variable "app_image" {
  description = "Docker image to run in the ECS cluster"
  default     = "497551902879.dkr.ecr.us-west-2.amazonaws.com/ccs-backend-repo:latest"
}

variable "app_port" {
  description = "Port exposed by the docker image to redirect traffic to"
  default     = 8000
}

variable "app_count" {
  description = "Number of docker containers to run"
  default     = 1
}

variable "health_check_path" {
  default = "/api-docs"
}

variable "fargate_cpu" {
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
  default     = "1024"
}

variable "fargate_memory" {
  description = "Fargate instance memory to provision (in MiB)"
  default     = "2048"
}

variable "website_name" {

  default = "uat.apisl.courtcanva.com"
}

variable "ecrname" {

  default = "backendrepo"
}

