provider "aws" {
  region = var.region
}

data "aws_vpc" "get_terraform_created_vpc_id" {
  id = module.vpc.vpc_id
}

# data "aws_security_group" "get_terraform_created_security_group_id" {
#   name   = "terraform-created-vpc-id"
#   vpc_id = data.aws_vpc.get_terraform_created_vpc_id.id
# }

data "aws_security_groups" "get_terraform_created_security_group_id" {

  filter {
    name   = "vpc-id"
    values = [module.vpc.vpc_id]
  }
}

resource "aws_security_group" "ec2_security_group" {
  name   = "${var.name}-security-group"
  vpc_id = module.vpc.vpc_id
  ingress {
    description = "ssh from vpc"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "ssh from vpc"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # ingress {
  #   description = "http from vpc"
  #   from_port   = 80
  #   to_port     = 80
  #   protocol    = "tcp"
  #   cidr_blocks = ["172.31.1.0/24"]
  # }

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

resource "aws_instance" "myec2" {
  ami                    = data.aws_ami.linux_ami.id
  instance_type          = var.instance
  subnet_id              = module.vpc.public_subnets[0] #if there are multiple subnets--->count.index % length(module.vpc.public_subnets)]
  vpc_security_group_ids = [aws_security_group.ec2_security_group.id]
  key_name = aws_key_pair.generated_key.key_name
  tags = {
    Name = "${var.name}"
  }
  # provisioner "local-exec" {
  #     command = "echo ${aws_instance.myec2.public_ip} >> public_ip.txt"
  # }
  connection {
    type        = "ssh"
    user        = "ec2-user" 
    host        = "${self.public_ip}"
    private_key = "${file("/home/maneeshry/.ssh/manualkeypair.pem")}"
    timeout     = "5m"
    agent = false
  }
  provisioner "remote-exec" {
    inline = [
      "sudo amazon-linux-extras enable nginx1.12",
      "sudo yum -y install nginx",
      "sudo systemctl start nginx",
    ]
  }

}
