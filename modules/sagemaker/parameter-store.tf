#---------------------------------------------------
# Parameter store
#---------------------------------------------------
resource "aws_ssm_parameter" "sagemaker_execution_role_arn" {
  count  = var.store_sagemaker_role_in_ssm_arn ? 1 : 0
  name   = "${var.name}-role-arn"
  type   = "SecureString"
  value  = aws_iam_role.sagemaker_execution_role.arn
  key_id = aws_kms_key.kms.id

  tags = merge(
    local.common_tags,
    {
      yor_name  = "sagemaker_execution_role_arn"
      yor_trace = "69e20d15-60d4-4669-8a6c-ea3c02c1467f"
  })
}