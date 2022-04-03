variable "instance" {
  default = "t2.micro"
}

variable "name" {
  type = any
  default = {
    dev = "dev"
    qa  = "qa"
  }
}


variable "region" {
  default = "ap-south-1"
}

variable "security_group_cidr" {
  type = any
  default = {
    dev = "174.31.1.1/24"
    qa  = "174.31.1.0/24"
  }
}

variable "key_name" {
  default = "mysshkey"
}

variable "cidr" {
  type = any
  default = {
    dev = "174.31.1.1/28"
    qa  = "174.31.1.0/28"
  }
}

variable "iam-user-groups" {
  type = any
  default = {
    devops = "devops"
    dev    = "dev"
    qa     = "qa"
  }
}

variable "iam-users" {
  type = map(any)
  default = {
    manoj = {
      username = "manoj"
    }
    chinni = {
      username = "chinni"
    }
    maneesh = {
      username = "maneesh"
    }
    itachi = {
      username = "itachi"
    }
  }
}

variable "iam-groups" {
  type = map(any)
  default = {
    devops = {
      groupname = "devops"
    }
    dev = {
      groupname = "dev"
    }
    qa = {
      groupname = "qa"
    }
  }
}

