data "template_file" "iam_group_actions" {
  template = <<EOF
iam:DeleteUserPolicy,
iam:PutUserPolicy,
iam:GetUser,
iam:GetGroup,
iam:AddUserToGroup,
iam:RemoveUserFromGroup,
iam:GetUserPolicy
EOF
}

data "template_file" "ec2_security_group_actions" {
  template = <<EOF
ec2:DescribeSecurityGroups,
ec2:RevokeSecurityGroupIngress,
ec2:AuthorizeSecurityGroupEgress,
ec2:AuthorizeSecurityGroupIngress,
ec2:UpdateSecurityGroupRuleDescriptionsEgress,
ec2:RevokeSecurityGroupEgress,
ec2:UpdateSecurityGroupRuleDescriptionsIngress
EOF
}

module "sts_lambda" {
  source             = "modules/sts_assume_role"

  service_identifier = "lambda.amazonaws.com"
  name               = "${var.name}-lambda"
  actions            = [//try this function trimspace(string)
    "${concat(
        split(",\n", chomp(var.resources_type == "ec2_security_group" ? data.template_file.ec2_security_group_actions.rendered : "logs:CreateLogGroup")),
        split(",\n", chomp(var.resources_type == "iam_group" ? data.template_file.iam_group_actions.rendered : "logs:CreateLogGroup")),
        list(
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        )
    )}"
  ]
  description        = "used by Lambda Function (${var.name})"
}

module "sts_gateway" {
  source             = "modules/sts_assume_role"

  service_identifier = "apigateway.amazonaws.com"
  name               = "${var.name}-gateway"
  actions            = [
    "logs:CreateLogGroup",
    "logs:CreateLogStream",
    "logs:DescribeLogGroups",
    "logs:DescribeLogStreams",
    "logs:PutLogEvents",
    "logs:GetLogEvents",
    "logs:FilterLogEvents"
  ]
  description        = "used by API Gateway to write CloudWatch Log (${var.name})"
}
