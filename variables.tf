variable "instance" {
  default = "t2.micro"

}

variable "name" {
  default = "ec2"
}

variable "region" {
  default = "ap-south-1"
}

variable "security_group_cidr" {
  default = "172.31.1.0/24"
}