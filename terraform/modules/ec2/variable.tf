variable "ami_id" {
  description = "The AMI ID for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "The instance type"
  type        = string
}

variable "region" {
  description = "The AWS region"
  type        = string
}

variable "ecr_repository_url" {
  description = "The ECR repository URL"
  type        = string
}

variable "ec2_role_name" {
  description = "The EC2 role name"
  type        = string
}

variable "security_group_id" {
  description = "security group id"
  type        = string
}

variable "key_pair_name" {
  description = "Name of the SSH key pair to use for instances"
  type        = string
}

variable "subnet_id" {
  description = "The IDs of the subnets"
  type        = string
}
