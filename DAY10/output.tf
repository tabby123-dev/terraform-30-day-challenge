# Produce a list of uppercase names
output "upper_names" {
  value = [for name in keys(var.users) : upper(name)]
}

# Produce a map of name → ARN from the for_each users resource
output "user_arns" {
  value = { for name, user in aws_iam_user.example : name => user.arn }
}