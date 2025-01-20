module "mysql_sg" {
  source       = "git::https://github.com/cekharchandra-devops/11-tf-aws-security-group-module.git?ref=main"
  project_name = var.project_name
  vpc_id       = local.vpc_id
  environmet   = var.environmet
  sg_name      = "mysql"
  common_tags  = var.common_tags
  sg_tags      = var.sg_mysql_tags
}

module "backend_sg" {
  source       = "git::https://github.com/cekharchandra-devops/11-tf-aws-security-group-module.git?ref=main"
  sg_name      = "backend"
  project_name = var.project_name
  environmet   = var.environmet
  vpc_id       = local.vpc_id
  common_tags  = var.common_tags
  sg_tags      = var.sg_backend_tags
}

module "frontend_sg" {
  source       = "git::https://github.com/cekharchandra-devops/11-tf-aws-security-group-module.git?ref=main"
  vpc_id       = local.vpc_id
  project_name = var.project_name
  environmet   = var.environmet
  sg_name      = "frontend"
  common_tags  = var.common_tags
  sg_tags      = var.sg_frontend_tags
}

module "bastion_sg" {
  source       = "git::https://github.com/cekharchandra-devops/11-tf-aws-security-group-module.git?ref=main"
  vpc_id       = local.vpc_id
  project_name = var.project_name
  environmet   = var.environmet
  sg_name      = "bastion"
  common_tags  = var.common_tags
  sg_tags      = var.sg_bastion_tags
}

module "ansible_sg" {
  source       = "git::https://github.com/cekharchandra-devops/11-tf-aws-security-group-module.git?ref=main"
  vpc_id       = local.vpc_id
  project_name = var.project_name
  environmet   = var.environmet
  sg_name      = "ansible"
  common_tags  = var.common_tags
  sg_tags      = var.sg_ansible_tags
}

resource "aws_security_group_rule" "database_backend" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = module.backend_sg.sg_id
  security_group_id        = module.mysql_sg.sg_id
}

resource "aws_security_group_rule" "backend_frontend" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  source_security_group_id = module.frontend_sg.sg_id
  security_group_id        = module.backend_sg.sg_id
}

resource "aws_security_group_rule" "frontend_public" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  cidr_blocks              = ["0.0.0.0/0"]
  security_group_id        = module.frontend_sg.sg_id
}

resource "aws_security_group_rule" "mysql_bastion" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = module.bastion_sg.sg_id
  security_group_id        = module.mysql_sg.sg_id
}

resource "aws_security_group_rule" "backend_bastion" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = module.bastion_sg.sg_id
  security_group_id        = module.backend_sg.sg_id
}

resource "aws_security_group_rule" "frontend_bastion" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = module.bastion_sg.sg_id
  security_group_id        = module.frontend_sg.sg_id
}

resource "aws_security_group_rule" "bastion_public" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  cidr_blocks              = [ "0.0.0.0/0" ]
  security_group_id        = module.bastion_sg.sg_id
}

resource "aws_security_group_rule" "mysql_ansible" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = module.ansible_sg.sg_id
  security_group_id        = module.mysql_sg.sg_id
}

resource "aws_security_group_rule" "backend_ansible" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = module.ansible_sg.sg_id
  security_group_id        = module.backend_sg.sg_id
}

resource "aws_security_group_rule" "frontend_ansible" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = module.ansible_sg.sg_id
  security_group_id        = module.frontend_sg.sg_id
}

resource "aws_security_group_rule" "ansible_public" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  cidr_blocks              = [ "0.0.0.0/0" ]
  security_group_id        = module.ansible_sg.sg_id
}