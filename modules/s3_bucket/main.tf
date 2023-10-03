# S3 Buckets ------------------------------------
# -----------------------------------------------

locals {
  common_tags = merge(
    var.tags
  )
}

resource "random_string" "rnd_str" {
  length  = 5
  special = false
  upper   = false
}

data "aws_caller_identity" "current_caller_identity" {}

#---------------------------------------------------
# Main S3 Bucket
#---------------------------------------------------

resource "aws_s3_bucket" "s3_bucket" {
  bucket = "${var.name}-${random_string.rnd_str.result}"
  #checkov:skip=CKV_AWS_144:no need to copy objects to another bucket in a different region OOS.
  #checkov:skip=CKV2_AWS_61:no expectation to delete objects in the bucket.
  #checkov:skip=CKV2_AWS_62:no lambda function, sns topic or sqs queue exits for notifications purposes.

  tags = merge(
    local.common_tags,
  )
}

resource "aws_s3_bucket_acl" "s3_bucket_acl" {
  bucket = aws_s3_bucket.s3_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "s3_bucket_access_block" {
  bucket = aws_s3_bucket.s3_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "s3_bucket_sse" {
  bucket = aws_s3_bucket.s3_bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.kms.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_versioning" "s3_bucket_versioning" {
  bucket = aws_s3_bucket.s3_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_policy" "s3_access_logging_policy" {
  bucket = aws_s3_bucket.s3_bucket.id
  policy = data.aws_iam_policy_document.enable_s3_access_logging.json
}

data "aws_iam_policy_document" "enable_s3_access_logging" {
  statement {
    sid    = "S3ServerAccessLogsPolicy"
    effect = "Allow"
    actions = [
      "s3:PutObject"
    ]
    principals {
      type        = "Service"
      identifiers = ["logging.s3.amazonaws.com"]
    }
    resources = ["arn:aws:s3:::${var.name}-logging-${random_string.rnd_str.result}/*"]
  }
}

#---------------------------------------------------
# Logging S3 Bucket
#---------------------------------------------------

resource "aws_s3_bucket" "logging_bucket" {
  bucket = "${var.name}-logging-${random_string.rnd_str.result}"
  #checkov:skip=CKV_AWS_144:no need to copy objects to another bucket in a different region OOS.
  #checkov:skip=CKV2_AWS_61:no expectation to delete objects in the bucket.
  #checkov:skip=CKV2_AWS_62:no lambda function, sns topic or sqs queue exits for notifications purposes.


  tags = merge(
    local.common_tags,
  )
}

resource "aws_s3_bucket_acl" "logging_bucket_acl" {
  bucket = aws_s3_bucket.logging_bucket.id
  acl    = "log-delivery-write"
}

resource "aws_s3_bucket_public_access_block" "logging_bucket_access_block" {
  bucket = aws_s3_bucket.logging_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "logging_bucket_sse" {
  bucket = aws_s3_bucket.logging_bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.kms.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_versioning" "logging_bucket_versioning" {
  bucket = aws_s3_bucket.logging_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_logging" "logging" {
  bucket = aws_s3_bucket.s3_bucket.id

  target_bucket = aws_s3_bucket.logging_bucket.id
  target_prefix = "log/"
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
  )
}

resource "aws_kms_alias" "kms_alias" {
  name          = "alias/${var.name}-kms-key"
  target_key_id = aws_kms_key.kms.key_id
}

resource "aws_kms_key_policy" "kms_key_policy" {
  key_id = aws_kms_key.kms.key_id
  policy = data.aws_iam_policy_document.kms_policy.json
}

#tfsec:ignore:aws-iam-no-policy-wildcards
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

  statement {
    effect = "Allow"
    actions = [
      "kms:Decrypt",
    ]
    principals {
      type        = "AWS"
      identifiers = var.principles_identifiers
    }
    resources = ["*"]
  }
}
