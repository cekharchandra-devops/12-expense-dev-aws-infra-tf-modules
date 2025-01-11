resource "aws_ssm_parameter" "mysql_sg" {
  name  = "/${var.project_name}/${var.environmet}/mysql_sg"
  type  = "String"
  value = module.mysql_sg.sg_id
}

resource "aws_ssm_parameter" "backend_sg" {
  name  = "/${var.project_name}/${var.environmet}/backend_sg"
  type  = "String"
  value = module.backend_sg.sg_id
}

resource "aws_ssm_parameter" "frontend_sg" {
  name  = "/${var.project_name}/${var.environmet}/frontend_sg"
  type  = "String"
  value = module.frontend_sg.sg_id
}

resource "aws_ssm_parameter" "bastion_sg" {
  name  = "/${var.project_name}/${var.environmet}/bastion_sg"
  type  = "String"
  value = module.bastion_sg.sg_id
}

resource "aws_ssm_parameter" "ansible_sg" {
  name  = "/${var.project_name}/${var.environmet}/ansible_sg"
  type  = "String"
  value = module.ansible_sg.sg_id
}
resource "aws_ssm_parameter" "app_alb_sg" {
  name  = "/${var.project_name}/${var.environmet}/app_alb_sg"
  type  = "String"
  value = module.app_alb_sg.sg_id
}