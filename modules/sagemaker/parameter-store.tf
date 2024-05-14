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
      yor_name             = "sagemaker_execution_role_arn"
      yor_trace            = "69e20d15-60d4-4669-8a6c-ea3c02c1467f"
      git_commit           = "b6a31a5aa5e813cbd8c3754076cf625c247c6293"
      git_file             = "modules/sagemaker/parameter-store.tf"
      git_last_modified_at = "2024-05-11 10:21:10"
      git_last_modified_by = "kwame_mintah@hotmail.co.uk"
      git_modifiers        = "kwame_mintah"
      git_org              = "kwame-mintah"
      git_repo             = "terraform-aws-machine-learning-pipeline"
  })
}
