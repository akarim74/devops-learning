variable "aws_region" {
  description = "AWS region for the WordPress deployment."
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Prefix used for AWS resource names and tags."
  type        = string
  default     = "wordpress"
}

variable "instance_type" {
  description = "EC2 instance size."
  type        = string
  default     = "t3.micro"
}

variable "ami_id" {
  description = "Optional AMI override. Null uses the latest Amazon Linux 2023 x86_64 AMI from AWS SSM."
  type        = string
  default     = null
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet; must fit inside vpc_cidr."
  type        = string
  default     = "10.0.0.0/24"
}

variable "availability_zone" {
  description = "Optional availability zone. Null selects the first available AZ in the configured region."
  type        = string
  default     = null
}

variable "http_port" {
  description = "HTTP port exposed by Apache. The supplied WordPress script uses port 80."
  type        = number
  default     = 80
}

variable "http_ingress_cidr" {
  description = "IPv4 CIDR allowed to access the HTTP website."
  type        = string
  default     = "0.0.0.0/0"
}
