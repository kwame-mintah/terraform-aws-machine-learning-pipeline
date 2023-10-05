output "github_action_role_arn" {
  value       = aws_iam_role.github_action_role.arn
  description = <<-EOF
    The ARN of the AWSGitHubAction role.

EOF
}

output "github_openid_connect_arn" {
  value       = aws_iam_openid_connect_provider.github_openid_connect.arn
  description = <<-EOF
    The ARN assigned by AWS for this provider.

EOF
}
