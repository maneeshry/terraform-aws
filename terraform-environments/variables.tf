variable "instance" {
  default = "t2.micro"

}

variable "name" {
  type = any
  default =  {
    dev = "dev"
    qa = "qa"
  } 
}


variable "region" {
  default = "ap-south-1"
}

variable "security_group_cidr" {
  type = any
  default =  {
    dev = "173.31.2.0/24"
    qa = "174.31.3.0/24"
  } 
  
}

variable "key_name" {
  default = "mysshkey"
}

variable "cidr" {
  type = any
  default = {
    
    #default = "172.31.1.0/24"
    dev = "175.31.2.0/24"
    qa = "174.31.3.0/24"
    }
  
}

variable "test" {
  type = any
  default = [
    {
    #default = "172.31.1.0/24"
    dev = "173.31.2.0/24"
    qa = "174.31.3.0/24"
    }
  ]
}