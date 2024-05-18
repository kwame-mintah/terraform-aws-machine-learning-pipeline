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

resource "aws_ssm_parameter" "sagemaker_kms_arn" {
  count  = var.store_sagemaker_role_in_ssm_arn ? 1 : 0
  name   = "${var.name}-kms-key-arn"
  type   = "SecureString"
  value  = aws_kms_key.kms.arn
  key_id = aws_kms_key.kms.id

  tags = merge(
    local.common_tags,
    {
      git_commit           = "6c9d2c0be6c5663fc5e1e5e08fe2651bf155df9f"
      git_file             = "modules/sagemaker/parameter-store.tf"
      git_last_modified_at = "2024-05-18 12:23:34"
      git_last_modified_by = "kwame_mintah@hotmail.co.uk"
      git_modifiers        = "kwame_mintah"
      git_org              = "kwame-mintah"
      git_repo             = "terraform-aws-machine-learning-pipeline"
      yor_name             = "sagemaker_kms_arn"
      yor_trace            = "08bf09b8-3c62-4758-904f-6008b48a6d22"
  })
}
