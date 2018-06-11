provider "aws" {
  region = "us-west-2"
}

module "dynamic-iam-group" {
  source         = "../../"
  name           = "dyna-resource-iam-groups"
  description    = "example usage of terraform-aws-authenticating-resources"
  time_to_expire = 300
  log_level      = "DEBUG"


  resources_type = "iam_group"

    resources = [
      {
        "group_name" = "test1",
        "user_names" = [
          "phuonghqh1",
          "phuonghqh2"
        ]
      },
      {
        "group_name" = "test2",
        "user_names" = [
          "phuonghqh1",
          "phuonghqh2"
        ]
      }
    ],

//  sec_groups     = [
//    {
//      "group_ids" = [
//        "sg-df7a88a3",
//        "sg-c9c72eb5"
//      ],
//      "rules" = [
//        {
//          "type" = "ingress",
//          "from_port" = "78",
//          "to_port" = "78",
//          "protocol" = "tcp"
//        }
//      ],
//      "region_name" = "us-west-2"
//    },
//    {
//      "group_ids" = [
//        "sg-a1a9d8d8"
//      ],
//      "rules" = [
//        {
//          "type" = "ingress",
//          "from_port" = "79",
//          "to_port" = "79",
//          "protocol" = "tcp"
//        }
//      ],
//      "region_name" = "us-west-1"
//    }
//  ]

  path_part      = "membership"
}

//resource "aws_iam_policy" "this" {
//  description = "Policy Developer IAM Access"
//  policy      = "${data.aws_iam_policy_document.access_policy_doc.json}"
//}

//data "aws_iam_policy_document" "access_policy_doc" {
//  statement {
//    effect    = "Allow"
//    actions   = [
//      "execute-api:Invoke"
//    ]
//    resources = [
//      "${module.dynamic-iam-group.execution_resources}"
//    ]
//  }
//}

output "dynamic-secgroup-api-invoke-url" {
  value = "${module.dynamic-iam-group.invoke_url}"
}
