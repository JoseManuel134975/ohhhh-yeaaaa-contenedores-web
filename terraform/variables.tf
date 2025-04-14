# Variable definida
variable "aws_region" {
  description = "AWS region"
  type = string
}

variable "ami_id" {
  description = "ID of the AMI to provision. Default is Ubuntu 14.04 Base Image"
  type = string
}

variable "instance_type" {
  description = "type of EC2 instance to provision."
  type = string
}

variable "name" {
  description = "name to pass to Name tag"
  type = string
}

variable "access_key" {
  type = string
}

variable "secret_key" {
  type = string
}

variable "session_token" {
  type = string
}