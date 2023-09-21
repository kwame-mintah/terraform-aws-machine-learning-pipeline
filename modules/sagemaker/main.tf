# Sagemaker -------------------------------------
# -----------------------------------------------

locals {
  common_tags = merge(
    var.tags
  )
}

resource "random_string" "resource_code" {
  length  = 5
  special = false
  upper   = false
}

data "aws_caller_identity" "current_caller_identity" {}

#---------------------------------------------------
# Notebook Instance
#---------------------------------------------------
resource "aws_sagemaker_notebook_instance" "notebook_instance" {
  name            = "${var.name}-${random_string.resource_code.result}"
  role_arn        = aws_iam_role.sagemaker_execution_role.arn
  instance_type   = var.instance_type
  root_access     = "Disabled"
  kms_key_id      = aws_kms_key.kms.key_id
  subnet_id       = var.subnet_id
  security_groups = var.security_group

  tags = merge(
    local.common_tags
  )
}

#---------------------------------------------------
# IAM Role
#---------------------------------------------------
resource "aws_iam_role" "sagemaker_execution_role" {
  name               = "SageMakerExecutionRole"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.sagemaker_assume_policy.json
}

resource "aws_iam_role_policy_attachment" "sagemaker_notebook_instance_policy" {
  role       = aws_iam_role.sagemaker_execution_role.name
  policy_arn = aws_iam_policy.sagemaker_notebook_policy.arn
}

resource "aws_iam_policy" "sagemaker_notebook_policy" {
  name   = "sagemaker-notebook-policy"
  policy = data.aws_iam_policy_document.sagemaker_notebook_instance_policy.json
}

data "aws_iam_policy_document" "sagemaker_assume_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["sagemaker.amazonaws.com"]
    }
  }
}

# TODO: Policy matches AWS Lab role, could be less permissive (?)
#tfsec:ignore:aws-iam-no-policy-wildcards
data "aws_iam_policy_document" "sagemaker_notebook_instance_policy" {
  statement {
    actions = [
      "cloudwatch:*",
      "elasticfilesystem:DescribeFileSystems",
      "elasticfilesystem:DescribeMountTargets",
      "fsx:DescribeFileSystems",
      "iam:GetRole",
      "iam:PassRole",
      "kms:DescribeKey",
      "kms:ListAliases",
      "logs:*",
      "s3:CreateBucket",
      "s3:DeleteObject",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:PutObject",
      "sagemaker:AddTags",
      "sagemaker:CreateEndpoint",
      "sagemaker:CreateModel",
      "sagemaker:CreateModelPackage",
      "sagemaker:CreatePresignedNotebookInstanceUrl",
      "sagemaker:Delete*",
      "sagemaker:Describe*",
      "sagemaker:GetSearchSuggestions",
      "sagemaker:InvokeEndpoint",
      "sagemaker:List*",
      "sagemaker:RenderUiTemplate",
      "sagemaker:Search",
      "sagemaker:StartNotebookInstance",
      "sagemaker:Stop*"
    ]
    effect    = "Allow"
    resources = [aws_sagemaker_notebook_instance.notebook_instance.arn]
  }
}

#---------------------------------------------------
# Key Management Service
#---------------------------------------------------
resource "aws_kms_key" "kms" {
  description             = "Amazon SageMaker to encrypt model aritifacts at rest using Amazon S3 server-side encryption"
  deletion_window_in_days = 30
  enable_key_rotation     = true

  tags = merge(
    local.common_tags
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
    actions = [
      "kms:Decrypt",
      "kms:DescribeKey",
      "kms:Encrypt",
      "kms:ListKeys",
    ]
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current_caller_identity.account_id}:role/SageMakerExecutionRole"]
    }
    resources = [aws_sagemaker_notebook_instance.notebook_instance.arn]
  }
}
