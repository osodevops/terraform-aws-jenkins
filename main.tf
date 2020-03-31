# ---------------------------------------------------------------------------------------------------------------------
# PROVIDER
# ---------------------------------------------------------------------------------------------------------------------
provider "aws" {
  profile = var.profile
  region  = var.region
}

# ---------------------------------------------------------------------------------------------------------------------
# Variables
# ---------------------------------------------------------------------------------------------------------------------
locals {
  jenkins_master_container_name      = "jenkins_master"
  jenkins_master_cloudwatch_log_path = "/ecs/service/${var.name_preffix}-jenkins-master"
  jenkins_container_web_port         = 8080
  jenkins_container_slave_port       = 50000
  jenkins_fargate_cpu_value          = 2048 # 2 vCPU  - https://docs.aws.amazon.com/AmazonECS/latest/developerguide/AWS_Fargate.html#fargate-task-defs
  jenkins_fargate_memory_value       = 4096 # 4 GB    - https://docs.aws.amazon.com/AmazonECS/latest/developerguide/AWS_Fargate.html#fargate-task-defs
  jenkins_url                        = "https://${aws_route53_record.load-balancer.fqdn}"
  jenkins_slave_cloudwatch_log_path  = "/ecs/service/${var.name_preffix}-jenkins-slave"
  jenkins_slave_container_name       = "jenkins-slave"
  jenkins_fargate_slave_cpu_value    = 512
  jenkins_fargate_slave_memory_value = 1024
}

# ---------------------------------------------------------------------------------------------------------------------
# ECS Cluster
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_ecs_cluster" "jenkins_cluster" {
  name = "${var.name_preffix}-jenkins"
}

