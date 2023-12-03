output "ecr_repository_arn" {
  value       = aws_ecr_repository.repository.arn
  description = <<-EOF
    Full ARN of the repository.

EOF
}

output "ecr_repository_url" {
  value       = aws_ecr_repository.repository.repository_url
  description = <<-EOF
    The URL of the repository.

EOF
}
