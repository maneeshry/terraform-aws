#Defining IAM users and groups
# locals {
#   create_iam_users = toset(flatten([
#     for key,value in var.iam-users : {
#       "user1" : key,
#       "username" : value["user1"],
#       "user2" : value["user2"],
#       "user3" : value["user3"]
#     }

#   ]))
# }
# resource "aws_iam_user" "create-iam-users" {
#   for_each = {
#     for value in local.create_iam_users : "${value.user1} ${value.username}"
#   }
#   name="${each.value.username}"

# }

# resource "aws_iam_user" "create_iam_users" {
#   for_each = var.iam-users
#   name = "${each.key}"
# }

# resource "aws_iam_user" "dev" {
#   name = "dev"
# }

# resource "aws_iam_user" "qa" {
#   name = "qa"
# }

# resource "aws_iam_group" "aws-ec2-user-group-names" {
#   for_each = var.iam-user-groups
#     name="${each.key}"

# }

# resource "aws_iam_group" "aws-ec2-user-group-dev" {
#   name = "aws-ec2-user-group-dev"
# }

# resource "aws_iam_group" "aws-ec2-user-group-qa" {
#   name = "aws-ec2-user-group-qa"
# }

##################
#Assigning users to groups
##################

# resource "aws_iam_group_membership" "iam-group-memberships" {
#   for_each = var.iam-user-names
#   name = "${each.key}-group-memberships"
#   #name = "iam-group-memberships"
#   users = [
#     aws_iam_user.create-iam-users[each.value]

#   ]
# #for_each = var.iam-user-groups
#   group = aws_iam_group.aws-ec2-user-group-names[each.value]
# }

# resource "aws_iam_group_membership" "dev-group-membership" {
#   name = "dev-group-membership"
#   users = [
#     aws_iam_user.dev.name
#   ]

#   group = aws_iam_group.aws-ec2-user-group-names.name
# }

# resource "aws_iam_group_membership" "qa-group-membership" {
#   name = "qa-group-membership"
#   users = [
#     aws_iam_user.qa.name
#   ]

#   group = aws_iam_group.aws-ec2-user-group-names.name
# }

##########
#Attaching policy to the group
##########

# resource "aws_iam_policy_attachment" "iam-users-policy" {
#   for_each = var.iam-user-groups
#   devops = "devops-group-membership"
#   dev = "dev-group-membership"
#   qa = "qa-group-membership"
#   groups = [aws_iam_group.aws-ec2-user-group-names[each.key]]

#   #The permission policy required you to specify the resource using ARN format
#   #arn:partition:service:region:account:resource

#   policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
# }

# resource "aws_iam_policy_attachment" "dev-policy" {
#   name = "dev-policy"
#   groups = [aws_iam_group.aws-ec2-user-group-names.name]

#   #The permission policy required you to specify the resource using ARN format
#   #arn:partition:service:region:account:resource

#   policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforAWSCodeDeploy"
# }

# resource "aws_iam_policy_attachment" "qa-policy" {
#   name = "qa-policy"
#   groups = [aws_iam_group.aws-ec2-user-group-names.name]

#   #The permission policy required you to specify the resource using ARN format
#   #arn:partition:service:region:account:resource

#   policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
# }