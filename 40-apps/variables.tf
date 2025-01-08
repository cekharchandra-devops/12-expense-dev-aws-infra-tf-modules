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

variable "instances_info" {
  type = list(object({
    instance = string
    security_group_id  = list(string)
    subnet_id = string
  }))
  default = [ ]
}

variable "zone_id" {
  default = "Z081461419PCT70J0BCQ6"
}

variable "domain_name" {
  default = "devsecmlops.online"
}