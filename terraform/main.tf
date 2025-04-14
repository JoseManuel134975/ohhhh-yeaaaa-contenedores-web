terraform {
  required_version = ">= 0.11.0"
}

provider "aws" {
  region     = var.aws_region
  access_key = var.access_key
  secret_key = var.secret_key
  token      = var.session_token
}

resource "aws_key_pair" "fedora" {
  key_name = "fedora-key"
  public_key = file("ec2-instance.pub")
}