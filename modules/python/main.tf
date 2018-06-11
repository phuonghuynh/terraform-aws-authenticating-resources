resource "template_dir" "this" {
  source_dir      = "${path.module}/src"
  destination_dir = "${path.module}/.archive"

  vars {
    log_level  = "${var.log_level}"
    resources = "${jsonencode(var.resources)}"
    resources_type = "${var.resources_type}"
//    iam_groups = "${jsonencode(var.iam_groups)}"
    time_to_expire  = "${var.time_to_expire}"
    module_name = "${var.module_name}"
  }
}

data "archive_file" "service_py" {
  depends_on  = [
    "template_dir.this"
  ]
  type        = "zip"
  output_path = "${path.module}/.archive.zip"
  source_dir  = "${template_dir.this.destination_dir}"
}
