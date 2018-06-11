variable "description" {
  default     = "Authenticating Resources API"
  description = "API Description"
}

variable "name" {
  default     = "terraform-aws-authenticating-resources"
  description = "the module name"
}

variable "deployment_stage" {
  default     = "dev"
  description = "Name of API deployment stage, ex: dev, staging, production..."
}

variable "resources_type" {
  description = "set the resource type, supported values: 'iam_group', 'ec2_security_group'"
}

variable "resources" {
  type = "list"
  description = "List of authenticating resource, can be iam_groups/sec_groups"
}

variable "path_part" {
  description = "The last path segment of this API resource"
}

variable "time_to_expire" {
  default     = 600
  description = "Time to expiry for every rule (in seconds)"
}

variable "log_level" {
  default     = "INFO"
  description = "Set level of Cloud Watch Log to INFO or DEBUG"
}
