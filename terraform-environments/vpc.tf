module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "environmet-${lookup(var.name, terraform.workspace)}"
  cidr = lookup(var.cidr, terraform.workspace)

  azs = ["${var.region}a"]

  public_subnets = ["174.31.1.0/28"]

  enable_nat_gateway = true
  enable_vpn_gateway = true
}