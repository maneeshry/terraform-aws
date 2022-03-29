#Definition of IAM users and groups

resource "aws_iam_user" "devops" {
  name = "devops"
}

resource "aws_iam_user" "dev" {
  name = "dev"
}

resource "aws_iam_user" "qa" {
  name = "qa"
}

resource "aws_iam_group" "aws-ec2-user-group-admin" {
  name = "aws-ec2-user-group-admin"
}

resource "aws_iam_group" "aws-ec2-user-group-dev" {
  name = "aws-ec2-user-group-dev"
}

resource "aws_iam_group" "aws-ec2-user-group-qa" {
  name = "aws-ec2-user-group-qa"
}

##################
#Assign users to groups
##################

resource "aws_iam_group_membership" "admin-group-membership" {
  name = "admin-group-membership"
  users = [
    aws_iam_user.devops.name
  ]

  group = aws_iam_group.aws-ec2-user-group-admin.name
}

resource "aws_iam_group_membership" "dev-group-membership" {
  name = "dev-group-membership"
  users = [
    aws_iam_user.dev.name
  ]

  group = aws_iam_group.aws-ec2-user-group-dev.name
}

resource "aws_iam_group_membership" "qa-group-membership" {
  name = "qa-group-membership"
  users = [
    aws_iam_user.qa.name
  ]

  group = aws_iam_group.aws-ec2-user-group-qa.name
}

##########
#Attach policy to the group
##########

resource "aws_iam_policy_attachment" "admin-policy" {
  name = "admin-policy"
  groups = [aws_iam_group.aws-ec2-user-group-admin.name]

  #The permission policy required you to specify the resource using ARN format
  #arn:partition:service:region:account:resource

  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

resource "aws_iam_policy_attachment" "dev-policy" {
  name = "dev-policy"
  groups = [aws_iam_group.aws-ec2-user-group-dev.name]

  #The permission policy required you to specify the resource using ARN format
  #arn:partition:service:region:account:resource

  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforAWSCodeDeploy"
}

resource "aws_iam_policy_attachment" "qa-policy" {
  name = "qa-policy"
  groups = [aws_iam_group.aws-ec2-user-group-qa.name]

  #The permission policy required you to specify the resource using ARN format
  #arn:partition:service:region:account:resource

  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
}