//module "sts_lambda" {
//  count
//  source             = "modules/sts_assume_role"

//  service_identifier = "lambda.amazonaws.com"
//  name               = "${var.name}-lambda"
//  actions            = [
//    "iam:DeleteUserPolicy",
//    "iam:PutUserPolicy",
//    "iam:GetUser",
//    "iam:GetGroup",
//    "iam:AddUserToGroup",
//    "iam:RemoveUserFromGroup",
//    "iam:GetUserPolicy",
//    "iam:GetUserPolicy",

//    "logs:CreateLogGroup",
//    "logs:CreateLogStream",
//    "logs:PutLogEvents"
//  ]
//  description        = "used by Lambda Funcitions in Module ${local.module_name}"
//}

//locals {
//  iam_groups_actions = []
//}



data "template_file" "iam_groups_policies" {
  count = "${length(var.iam_groups) > 0 ? 1 : 0}"
//    count = "${var.something ? 1 : 0}"
//  template = "${length(var.sec_groups) > 0 ? file("${path.module}/iam_groups_policies.json")}"
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

//data "template_file" "sec_groups_policies" {
//  count = "${length(var.sec_groups)}"
//  template = "${file("${path.module}/iam_groups_policies.json")}"
//}

module "sts_lambda" {
  source             = "modules/sts_assume_role"

  service_identifier = "lambda.amazonaws.com"
  name               = "${var.name}-lambda"
  actions            = [
//    lookup(lookup(local.resource_types, var.resource_type), "policies"),
    "${concat(
        split(",\n", chomp(data.template_file.iam_groups_policies.rendered)),
        list(
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        )
    )}"
  ]
  description        = "used by Lambda Funcitions in Module ${local.module_name}"
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
  description        = "used by Api Gateway to write log (cloudwatch)"
}
