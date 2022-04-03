locals {
  create_iam_users = toset(flatten([
    for key, value in var.iam-users : {
      "username" : key,
      "user" : value["username"],
    }
  ]))
}

locals {
  create_iam_groups = toset(flatten([
    for key, value in var.iam-groups : {
      "groupname" : key,
      "group" : value["groupname"]
    }
  ]))
}

##################
#Creating IAM users
##################

module "iam_user" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-user"
  version = "~> 4"
  for_each = {
    for value in local.create_iam_users : "${value.user} ${value.username}" => value
  }
  name          = each.value.user
  force_destroy = true
}

##################
#Creating IAM groups
##################

resource "aws_iam_group" "group" {
  for_each = {
    for value in local.create_iam_groups : "${value.group} ${value.groupname}" => value
  }
  name = each.value.group
}


##################
#Assigning users to groups
##################

resource "aws_iam_group_membership" "devops_membership" {
  name = "devops-group-membership"
  users = [
    module.iam_user["manoj manoj"].iam_user_name,
    module.iam_user["itachi itachi"].iam_user_name
  ]
  group = aws_iam_group.group["devops devops"].name
}

resource "aws_iam_group_membership" "dev_membership" {
  name = "dev-group-membership"
  users = [
    module.iam_user["maneesh maneesh"].iam_user_name
  ]
  group = aws_iam_group.group["dev dev"].name
}

resource "aws_iam_group_membership" "qa_membership" {
  name = "qa-group-membership"
  users = [
    module.iam_user["chinni chinni"].iam_user_name
  ]
  group = aws_iam_group.group["qa qa"].name
}

##################
#Attaching IAM policies
##################

resource "aws_iam_policy_attachment" "devops_group_policy" {
  name = "devops-group-policy"
  groups = [
    aws_iam_group.group["devops devops"].name
  ]
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

resource "aws_iam_policy_attachment" "dev_group_policy" {
  name = "dev-group-policy"
  groups = [
    aws_iam_group.group["dev dev"].name
  ]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforAWSCodeDeploy"
}

resource "aws_iam_policy_attachment" "qa-group-policy" {
  name = "qa_group_policy"
  groups = [
    aws_iam_group.group["qa qa"].name
  ]
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
}



