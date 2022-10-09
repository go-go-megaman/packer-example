data "aws_region" "current" {}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.16.0"

  name = "vpc_for_building_ami_on_${terraform.workspace}"
  cidr = "10.0.0.0/24"

  azs            = ["${data.aws_region.current.name}a"]
  public_subnets = ["10.0.0.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = true

  manage_default_security_group = true
  default_security_group_ingress = [
    {
      cidr_blocks = "0.0.0.0/0"
      from_port   = 22
      to_port     = 22
      protocol    = "TCP"
    }
  ]

  tags = {
    Class = "packer"
  }
}
