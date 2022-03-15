provider "aws" {
  region = var.region
}

data "aws_vpc" "get_terraform_vpc_id" {
  id= module.vpc.vpc_id
}

data "aws_security_groups" "get_terraform_security_group_id" {

  filter {
    name   = "vpc-id"
    values = [module.vpc.vpc_id]
  }
}

data "aws_ami" "linux_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

data "aws_subnets" "get_subnet_id" {
  filter {
    name   = "vpc-id"
    values = [module.vpc.vpc_id]
  }

}

resource "aws_key_pair" "generated_key" {
  key_name   = var.key_name
  public_key = "${file("/home/maneeshry/.ssh/manualkeypair.pub")}"
}

resource "aws_security_group" "ec2_security_group" {
  name = lookup(var.name,terraform.workspace)
  vpc_id = module.vpc.vpc_id
  ingress {
    description = "ssh from vpc"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [lookup(var.cidr,terraform.workspace)]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "myec2" {
  ami                    = data.aws_ami.linux_ami.id
  instance_type          = var.instance
  subnet_id              = module.vpc.public_subnets[0] #if there are multiple subnets--->count.index % length(module.vpc.public_subnets)]
  vpc_security_group_ids = [aws_security_group.ec2_security_group.id]
  key_name = aws_key_pair.generated_key.key_name
  tags = {
    Name =  lookup(var.name,terraform.workspace)
  }
}