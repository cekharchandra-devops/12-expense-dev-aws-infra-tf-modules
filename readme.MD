# Create Infra for 3-tier architecture application using Terraform modules.

![alt text](3-tier-infra-tf.drawio.svg)



This Terraform setup provisions a comprehensive infrastructure for an expense application in the AWS cloud. It includes VPC, subnets, security groups, EC2 instances, and Route 53 configurations. Additionally, it uses Ansible for configuration management to deploy backend, frontend, and MySQL roles.

## Features

1. **VPC and Networking**:
   - VPC with associated CIDR blocks.
   - Public, private, and database subnets distributed across Availability Zones.
   - Internet Gateway (IGW) and Route Tables with appropriate routes.

2. **Security Groups**:
   - Security groups for MySQL, backend, frontend, bastion, and ansible hosts.
   - Ingress rules for communication between components and public access.

3. **Instances**:
   - EC2 instances for bastion, MySQL, backend, frontend, and ansible hosts.
   - Bastion host for secure SSH access.
   - Ansible for deploying roles to backend, frontend, and MySQL hosts.

4. **Route 53 DNS Records**:
   - Private DNS records for instances.
   - Public DNS record for frontend.

## Modules

### VPC
```hcl
module "vpc" {
  source = "git::https://github.com/cekharchandra-devops/09-tf-aws-vpc-module.git?ref=main"
  project_name = "expense"
  environmet = "dev"
  public_subnet_cidr_blocks = var.public_subnet_cidr_blocks
  private_subnet_cidr_blocks = var.private_subnet_cidr_blocks
  db_subnet_cidr_blocks = var.db_subnet_cidr_blocks
  is_peering_required = var.is_peering_required
}
```

### Security Groups
```hcl
module "mysql_sg" {
  source       = "../../11-tf-aws-security-group-module"
  sg_name      = "mysql"
  vpc_id       = local.vpc_id
  project_name = var.project_name
  environmet   = var.environmet
  common_tags  = var.common_tags
  sg_tags      = var.sg_mysql_tags
}
# Additional security group modules for backend, frontend, bastion, and ansible follow a similar structure.
```

### EC2 Instances
```hcl
module "bastion_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  name = "bastion-host"
  ami = data.aws_ami.ami_info.id
  instance_type          = "t3.micro"
  vpc_security_group_ids = [module.bastion_sg.sg_id]
  subnet_id              = local.public_subnet_id
  tags = var.common_tags
}

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
  tags = var.common_tags
}
```

### Route 53 Records
```hcl
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
```

## Deployment Workflow
1. Clone the repository and initialize Terraform.
2. Update the variables to match your environment in `terraform.tfvars` or a similar file.
3. Deploy the infrastructure using:
   ```sh
   terraform init
   terraform apply
   ```
4. Use the Ansible script (`expense.sh`) to deploy backend, frontend, and MySQL roles.

## Prerequisites
- AWS CLI installed and configured.
- Terraform installed on your system.
- Ansible installed for configuration management.
