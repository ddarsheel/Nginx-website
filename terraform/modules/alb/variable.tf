variable "name" {
  description = "Name of the ALB"
  type        = string
}

variable "security_groups" {
  description = "List of security groups for the ALB"
  type        = list(string)
}

variable "subnets" {
  description = "List of subnet IDs for the ALB"
  type        = list(string)
}

variable "logs_bucket" {
  description = "S3 bucket for access logs"
  type        = string
}

variable "enable_logs" {
  description = "Whether to enable access logging"
  type        = bool
  default     = false
}

variable "certificate_arn" {
  description = "ARN of the ACM certificate for HTTPS"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}
