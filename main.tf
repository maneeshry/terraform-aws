provider "aws" {
  region  = var.region
}

resource "aws_security_group" "ec2_security_group" {
  name   = "${var.name}-security-group"
  vpc_id = module.vpc.vpc_id
  ingress {
    description = "ssh from vpc"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.security_group_cidr]
  }
  ingress {
    description = "http from vpc"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.security_group_cidr]
  }
  ingress {
    description = "for lb"
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = [var.security_group_cidr]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
}

data "aws_ami" "linux_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

resource "aws_instance" "myec2" {
  ami             = data.aws_ami.linux_ami.id
  instance_type   = var.instance
  count = 2
  #vpc_security_group_ids = ["${aws_security_group.ec2_security_group.id}"]
  tags = {
    Name = "${var.name}-${count.index}"
  }
}
