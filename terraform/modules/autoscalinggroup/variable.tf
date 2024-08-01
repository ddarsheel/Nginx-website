variable "launch_configuration_id" {
  description = "The ID of the launch configuration"
  type        = string
}

variable "subnet_ids" {
  description = "The IDs of the subnets"
  type        = list(string)
}

variable "min_size" {
  description = "The minimum size of the auto-scaling group"
  type        = number
}

variable "max_size" {
  description = "The maximum size of the auto-scaling group"
  type        = number
}

variable "desired_capacity" {
  description = "The desired capacity of the auto-scaling group"
  type        = number
}
