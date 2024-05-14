resource "aws_ssm_parameter" "s3_bucket_arn" {
  count  = var.store_bucket_arn_in_ssm_parameter ? 1 : 0
  name   = "${var.name}-arn"
  type   = "SecureString"
  value  = aws_s3_bucket.s3_bucket.arn
  key_id = aws_kms_key.kms.id

  tags = merge(
    local.common_tags,
    {
      yor_name             = "s3_bucket_arn"
      yor_trace            = "d03fa2dd-a80c-4825-bb0c-e4d52965a331"
      git_commit           = "b6a31a5aa5e813cbd8c3754076cf625c247c6293"
      git_file             = "modules/s3_bucket/parameter-store.tf"
      git_last_modified_at = "2024-05-11 10:21:10"
      git_last_modified_by = "kwame_mintah@hotmail.co.uk"
      git_modifiers        = "kwame_mintah"
      git_org              = "kwame-mintah"
      git_repo             = "terraform-aws-machine-learning-pipeline"
  })
}

resource "aws_ssm_parameter" "s3_bucket_name" {
  count  = var.store_bucket_name_in_ssm_parameter ? 1 : 0
  name   = var.name
  type   = "SecureString"
  value  = aws_s3_bucket.s3_bucket.id
  key_id = aws_kms_key.kms.id

  tags = merge(
    local.common_tags,
    {
      yor_name             = "s3_bucket_name"
      yor_trace            = "71ebf1ca-1183-479c-af9b-9a2572574ebf"
      git_commit           = "b6a31a5aa5e813cbd8c3754076cf625c247c6293"
      git_file             = "modules/s3_bucket/parameter-store.tf"
      git_last_modified_at = "2024-05-11 10:21:10"
      git_last_modified_by = "kwame_mintah@hotmail.co.uk"
      git_modifiers        = "kwame_mintah"
      git_org              = "kwame-mintah"
      git_repo             = "terraform-aws-machine-learning-pipeline"
  })
}

resource "aws_ssm_parameter" "s3_kms_key_arn" {
  count  = var.store_kms_key_arn_in_ssm_parameter ? 1 : 0
  name   = "${var.name}-kms-key-arn"
  type   = "SecureString"
  value  = aws_kms_key.kms.arn
  key_id = aws_kms_key.kms.id

  tags = merge(
    local.common_tags,
    {
      yor_name             = "s3_kms_key_arn"
      yor_trace            = "f616ff30-65f1-48dc-8258-1d3eb8dba0c7"
      git_commit           = "b6a31a5aa5e813cbd8c3754076cf625c247c6293"
      git_file             = "modules/s3_bucket/parameter-store.tf"
      git_last_modified_at = "2024-01-08 20:37:23"
      git_last_modified_by = "kwame_mintah@hotmail.co.uk"
      git_modifiers        = "kwame_mintah"
      git_org              = "kwame-mintah"
      git_repo             = "terraform-aws-machine-learning-pipeline"
  })
}
