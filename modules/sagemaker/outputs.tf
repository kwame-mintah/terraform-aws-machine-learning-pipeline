output "sagemaker_notebook_instance_arn" {
  value       = aws_sagemaker_notebook_instance.notebook_instance.arn
  description = <<-EOF
    The Amazon Resource Name (ARN) assigned by AWS to this notebook instance.

EOF
}

output "sagemaker_notebook_execution_role_arn" {
  value       = aws_iam_role.sagemaker_execution_role.arn
  description = <<-EOF
    The ARN of the IAM role to be used by the notebook instance which allows 
    SageMaker to call other services on your behalf.

EOF
}
