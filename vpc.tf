module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.name}-vpc"
  cidr = "172.31.1.0/24"

  azs = ["${var.region}a"]
  #private_subnets = ["10.0.1.0/24"]
  public_subnets = ["172.31.1.0/28"]

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}