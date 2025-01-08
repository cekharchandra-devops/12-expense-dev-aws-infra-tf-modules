data "aws_ssm_parameter" "mysql_sg" {
    name = "/${var.project_name}/${var.environmet}/mysql_sg"
}

data "aws_ssm_parameter" "backend_sg" {
    name = "/${var.project_name}/${var.environmet}/backend_sg"
}

data "aws_ssm_parameter" "frontend_sg" {
    name = "/${var.project_name}/${var.environmet}/frontend_sg"
}

data "aws_ssm_parameter" "ansible_sg" {
    name = "/${var.project_name}/${var.environmet}/ansible_sg"
}

data "aws_ssm_parameter" "public_subnet_ids" {
    name = "/${var.project_name}/${var.environmet}/public_subnet_ids"  
}

data "aws_ssm_parameter" "private_subnet_ids" {
    name = "/${var.project_name}/${var.environmet}/private_subnet_ids"  
}

data "aws_ssm_parameter" "db_subnet_ids" {
    name = "/${var.project_name}/${var.environmet}/db_subnet_ids"  
}

data "aws_ami" "ami_info" {
  most_recent = true
  owners      = ["973714476881"]

  filter {
    name   = "name"
    values = ["RHEL-9-DevOps-Practice"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}