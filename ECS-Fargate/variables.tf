# variables.tf

variable "aws_region" {
  description = "The AWS region things are created in"

}

variable "name" {
  description = "name of this project"

}

variable "env" {
  description = "environment of this project"

}
variable "ecs_task_execution_role_name" {
  description = "ECS task execution role name"
  default     = "myEcsTaskExecutionRole"
}

variable "az_count" {
  description = "Number of AZs to cover in a given region"
  default     = "2"
}

variable "app_image" {
  description = "Docker image to run in the ECS cluster"

}

variable "app_port" {
  description = "Port exposed by the docker image to redirect traffic to"

}

variable "app_count" {
  description = "Number of docker containers to run"

}

variable "health_check_path" {
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
}


variable "statefilepath" {
  type = string
}
variable "vpc_cidr_block" {

}
