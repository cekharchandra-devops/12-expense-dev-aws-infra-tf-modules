variable "project_name" {
  default = "expense"
}

variable "environmet" {
  default = "dev"
}

variable "common_tags" {
  default = {
    Project     = "Expense"
    Environment = "dev"
    Terraform   = "true"
  }
}
variable "sg_mysql_tags" {
  default = {
    Component = "mysql"
  }
}

variable "sg_backend_tags" {
  default = {
    Component = "backend"
  }
}

variable "sg_frontend_tags" {
  default = {
    Component = "frontend"
  }
}

variable "sg_bastion_tags" {
  default = {
    Component = "bastion"
  }
}

variable "sg_ansible_tags" {
  default = {
    Component = "ansible"
  }
}