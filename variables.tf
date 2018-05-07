//locals {
//  resource_types = {
//    iam_groups      = {
//      policies = [
//        "iam:DeleteUserPolicy",
//        "iam:PutUserPolicy",
//        "iam:GetUser",
//        "iam:GetGroup",
//        "iam:AddUserToGroup",
//        "iam:RemoveUserFromGroup",
//        "iam:GetUserPolicy"]
//    },
//
//    sec_groups = {
//      policies = [
//        "ec2:DescribeSecurityGroups",
//        "ec2:RevokeSecurityGroupIngress",
//        "ec2:AuthorizeSecurityGroupEgress",
//        "ec2:AuthorizeSecurityGroupIngress",
//        "ec2:UpdateSecurityGroupRuleDescriptionsEgress",
//        "ec2:RevokeSecurityGroupEgress",
//        "ec2:UpdateSecurityGroupRuleDescriptionsIngress",
//      ]
//    }
//  }
//}

variable "description" {
  default     = "Dynamically Authenticating Resources API"
  description = "Description of this api"
}

variable "name" {
  default     = "terraform-aws-authenticating-resources"
  description = "the module name"
}

variable "deployment_stage" {
  default     = "dev"
  description = "Api deployment stages, ex: staging, production..."
}

//variable "resource_type" {
//  default = "iam"
//  # see ${keys(local.resource_types)}
//  description = "set the resource type, values should be: 'iam', 'secgroup'"
//}

variable "iam_groups" {
  default = []
  type        = "list"
  description = "List of authenticated iam_groups"
//  description = "List of authenticated Resources"
}

variable "sec_groups" {
  default = []
  type        = "list"
  description = "List of authenticated sec_groups"
}

variable "time_to_expire" {
  default     = 600
  description = "Time to expiry for every rule (in seconds)"
}

variable "log_level" {
  default     = "INFO"
  description = "Set level of Cloud Watch Log to INFO or DEBUG"
}
