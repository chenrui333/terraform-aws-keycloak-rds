variable "aws_region" {
  description = "The AWS region for creating the infrastructure"
  default     = "us-east-1"
}

variable "key_name" {
  description = "Name of the AWS key pair to use"
  default     = "keycloak"
}

variable "docker_image_url" {
  default = "jboss/keycloak:11.0.0"
}

variable "ecs_cluster_name" {
  default = "keycloak_cluster"
}

variable "ecs_log_level" {
  description = "The ECS log level"
  default     = "info"
}

variable "admin_cidr_ingress" {
  default = "10.15.0.0/16"
}

variable "keycloak_admin_username" {
  description = "KeyCloak Admin Username"
  default = "rg"
}

variable "keycloak_admin_password" {
  description = "KeyCloak Admin Password"
  default = "rgdemo1"
}

variable "public_dns_name" {
  description = "The public-facing DNS name"
  default = "keycloak.meetuphq.io"
}

variable "zone_name" {
  description = "The DNS zone name"
  default = "meetuphq.io"
}
