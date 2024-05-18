# Parameter Store -------------------------------
# -----------------------------------------------

data "aws_caller_identity" "current_caller_identity" {}

resource "aws_ssm_parameter" "queue_arn" {
  count  = var.store_queue_arn ? 1 : 0
  name   = "${var.name}-queue-arn"
  type   = "SecureString"
  value  = aws_sqs_queue.sqs_queue.arn
  key_id = aws_kms_key.kms.id

  tags = merge(
    local.common_tags,
    {
      yor_name  = "queue_arn"
      yor_trace = "e295390b-d895-4537-8312-4b480d062a12"
      }, {
      git_commit           = "538bdd42189f0d6afbc33afaca6a4832124aefa8"
      git_file             = "modules/sqs/parameter-store.tf"
      git_last_modified_at = "2024-05-14 07:51:21"
      git_last_modified_by = "kwame_mintah@hotmail.co.uk"
      git_modifiers        = "kwame_mintah"
      git_org              = "kwame-mintah"
      git_repo             = "terraform-aws-machine-learning-pipeline"
  })
}

resource "aws_ssm_parameter" "dlq_arn" {
  count  = var.store_dlq_arn ? 1 : 0
  name   = "${var.name}-dlq-arn"
  type   = "SecureString"
  value  = aws_sqs_queue.dlq_queue.arn
  key_id = aws_kms_key.kms.id

  tags = merge(
    local.common_tags,
    {
      yor_name  = "dlq_arn"
      yor_trace = "15ff26d6-345f-4e19-86a3-b98e4e54dee4"
      }, {
      git_commit           = "e5bfc6fed0a9397b7daf343aa0728b99db49105d"
      git_file             = "modules/sqs/parameter-store.tf"
      git_last_modified_at = "2024-04-17 19:19:21"
      git_last_modified_by = "kwame_mintah@hotmail.co.uk"
      git_modifiers        = "kwame_mintah"
      git_org              = "kwame-mintah"
      git_repo             = "terraform-aws-machine-learning-pipeline"
  })
}

resource "aws_ssm_parameter" "queue_name" {
  count  = var.store_queue_name ? 1 : 0
  name   = "${var.name}-queue-name"
  type   = "SecureString"
  value  = aws_sqs_queue.sqs_queue.name
  key_id = aws_kms_key.kms.id

  tags = merge(
    local.common_tags,
    {
      yor_name  = "queue_name"
      yor_trace = "37f0d9c5-fd9b-4391-8682-735410cccb4b"
      }, {
      git_commit           = "538bdd42189f0d6afbc33afaca6a4832124aefa8"
      git_file             = "modules/sqs/parameter-store.tf"
      git_last_modified_at = "2024-05-14 07:51:21"
      git_last_modified_by = "kwame_mintah@hotmail.co.uk"
      git_modifiers        = "kwame_mintah"
      git_org              = "kwame-mintah"
      git_repo             = "terraform-aws-machine-learning-pipeline"
  })
}

resource "aws_ssm_parameter" "dlq_name" {
  count  = var.store_dlq_name ? 1 : 0
  name   = "${var.name}-dlq-name"
  type   = "SecureString"
  value  = aws_sqs_queue.dlq_queue.name
  key_id = aws_kms_key.kms.id

  tags = merge(
    local.common_tags,
    {
      yor_name  = "dlq_name"
      yor_trace = "3457eb70-1f1c-4cae-9493-610cb2029df8"
      }, {
      git_commit           = "e5bfc6fed0a9397b7daf343aa0728b99db49105d"
      git_file             = "modules/sqs/parameter-store.tf"
      git_last_modified_at = "2024-04-17 19:19:21"
      git_last_modified_by = "kwame_mintah@hotmail.co.uk"
      git_modifiers        = "kwame_mintah"
      git_org              = "kwame-mintah"
      git_repo             = "terraform-aws-machine-learning-pipeline"
  })
}

resource "aws_ssm_parameter" "ssm_kms_key_arn" {
  count  = var.store_dlq_name ? 1 : 0
  name   = "${var.name}-kms-key-arn"
  type   = "SecureString"
  value  = aws_kms_key.kms.arn
  key_id = aws_kms_key.kms.id

  tags = merge(
    local.common_tags,
  )
}

#---------------------------------------------------
# Key Management Service
#---------------------------------------------------

resource "aws_kms_key" "kms" {
  description             = "Encrypt S3 Bucket data stored."
  deletion_window_in_days = 30
  enable_key_rotation     = true

  tags = merge(
    local.common_tags,
    {
      yor_name             = "kms"
      yor_trace            = "c2977178-c76f-4df9-a73e-6c46fb28f32f"
      git_commit           = "e5bfc6fed0a9397b7daf343aa0728b99db49105d"
      git_file             = "modules/sqs/parameter-store.tf"
      git_last_modified_at = "2024-04-17 19:19:21"
      git_last_modified_by = "kwame_mintah@hotmail.co.uk"
      git_modifiers        = "kwame_mintah"
      git_org              = "kwame-mintah"
      git_repo             = "terraform-aws-machine-learning-pipeline"
  })
}

resource "aws_kms_alias" "kms_alias" {
  name          = "alias/${var.name}-kms-key"
  target_key_id = aws_kms_key.kms.key_id
}

resource "aws_kms_key_policy" "kms_key_policy" {
  key_id = aws_kms_key.kms.key_id
  policy = data.aws_iam_policy_document.kms_policy.json
}

data "aws_iam_policy_document" "kms_policy" {
  statement {
    effect  = "Allow"
    actions = ["kms:*"]
    #checkov:skip=CKV_AWS_356:root account needs access to resolve error, the new key policy will not allow you to update the key policy in the future.
    #checkov:skip=CKV_AWS_111:root account needs access to resolve error, the new key policy will not allow you to update the key policy in the future.
    #checkov:skip=CKV_AWS_109:root account needs access to resolve error, the new key policy will not allow you to update the key policy in the future.
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current_caller_identity.account_id}:root"]
    }
    resources = ["*"]
  }
}
