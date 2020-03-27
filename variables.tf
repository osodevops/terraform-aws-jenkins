variable "common_tags" {
  type = "map"
}

# ---------------------------------------------------------------------------------------------------------------------
# Misc
# ---------------------------------------------------------------------------------------------------------------------
variable "name_preffix" {
  description = "Name preffix for resources on AWS"
}

# ---------------------------------------------------------------------------------------------------------------------
# AWS CREDENTIALS AND REGION
# ---------------------------------------------------------------------------------------------------------------------
variable "profile" {
  description = "AWS API key credentials to use"
}

variable "region" {
  description = "AWS Region the infrastructure is hosted in"
}

# ---------------------------------------------------------------------------------------------------------------------
# AWS Networking
# ---------------------------------------------------------------------------------------------------------------------
variable "vpc_id" {
  description = "ID of the VPC"
}

variable "public_subnets_ids" {
  description = "List of Public Subnets IDs"
  type        = "list"
}

variable "private_subnets_ids" {
  description = "List of Private Subnets IDs"
  type        = "list"
}
variable "web_whitelist" {
  description = "Whitelist of IPs which can connect."
  type = "list"
  default = []
}
variable "dns_zone_id" {
  default = ""
}
variable "dns_name" {
  default = "jenkins"
}

variable "alb_certifcate_arn" {
  default = ""
}
variable "jenkins_admin_password" {
  description = "REQUIRED: Jenkins Master node username."
  type = string
}
variable "jenkins_admin_username" {
  description = "REQUIRED: Jenkins Master node password."
  type = string
}