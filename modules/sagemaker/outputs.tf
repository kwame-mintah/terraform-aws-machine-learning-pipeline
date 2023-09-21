output "sagemaker_notebook_instance_arn" {
  value       = aws_sagemaker_notebook_instance.notebook_instance.arn
  description = <<-EOF
    The Amazon Resource Name (ARN) assigned by AWS to this notebook instance.

EOF
}
