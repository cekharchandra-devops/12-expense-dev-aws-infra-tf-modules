locals {
  instance_name = "${var.project_name}-${var.environmet}"
  mysql_sg = data.aws_ssm_parameter.mysql_sg.value
  backend_sg = data.aws_ssm_parameter.backend_sg.value
  frontend_sg = data.aws_ssm_parameter.frontend_sg.value
  ansible_sg = data.aws_ssm_parameter.ansible_sg.value

  public_subnet_id = split(",",data.aws_ssm_parameter.public_subnet_ids.value)[0]
  private_subnet_id = split(",",data.aws_ssm_parameter.private_subnet_ids.value)[0]
  db_subnet_id = split(",",data.aws_ssm_parameter.db_subnet_ids.value)[0]

  instances_info = concat([
    { instance = "mysql" , security_group_id = [local.mysql_sg] , subnet_id = local.db_subnet_id},
    { instance = "backend" , security_group_id = [local.backend_sg] , subnet_id = local.private_subnet_id},
    { instance = "frontend" , security_group_id = [local.frontend_sg] , subnet_id = local.public_subnet_id},
    { instance = "ansible" , security_group_id = [local.ansible_sg] , subnet_id = local.public_subnet_id}
  ])

}