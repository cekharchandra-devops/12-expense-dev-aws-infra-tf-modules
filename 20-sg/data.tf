data "aws_ssm_parameter" "vpc_id" {
  name = "/${var.project_name}/${var.environmet}/vpc_id"
}