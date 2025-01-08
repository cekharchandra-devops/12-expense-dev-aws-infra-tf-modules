module "expense_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  for_each = { 
    for inst in local.instances_info :
    inst.instance => inst
  }
  name = "${local.instance_name}-${each.key}"
  ami = data.aws_ami.ami_info.id
  instance_type          = "t3.micro"
  vpc_security_group_ids = each.value.security_group_id
  subnet_id              = each.value.subnet_id
  user_data = each.key == "ansible" ? file("expense.sh") : null
  tags = merge(
    var.common_tags,
    {
        Name = "${local.instance_name}-${each.key}"
    }
  )
}

resource "aws_route53_record" "private_records" {
  for_each = { 
    for inst in local.instances_info :
    inst.instance => inst if !contains(["ansible", "bastion"], inst.instance)
  }
  zone_id = var.zone_id
  name    = "${each.key}.${var.domain_name}"
  type    = "A"
  ttl     = 1
  records = [module.expense_instance[each.key].private_ip]  
}

resource "aws_route53_record" "public_record" {
  zone_id = var.zone_id
  name    = var.domain_name
  type    = "A"
  ttl     = 1
  records = [module.expense_instance["frontend"].public_ip]
}