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
data "aws_region" "current_caller_region" {}

#---------------------------------------------------
# Notebook Instance
#---------------------------------------------------
resource "aws_sagemaker_notebook_instance" "notebook_instance" {
  name                   = "${var.name}-${random_string.resource_code.result}"
  role_arn               = aws_iam_role.sagemaker_execution_role.arn
  instance_type          = var.instance_type
  platform_identifier    = "notebook-al2-v2"
  root_access            = "Disabled"
  direct_internet_access = "Enabled"
  # TODO: Create NAT Gateway to allow outbound connections for notebook instance
  #checkov:skip=CKV_AWS_122:to train or host models from a notebook, you need internet access. no NAT gateway created yet.
  kms_key_id            = aws_kms_key.kms.key_id
  subnet_id             = aws_subnet.sagemaker_subnet.id
  security_groups       = [aws_security_group.sagemaker_sg.id]
  lifecycle_config_name = aws_sagemaker_notebook_instance_lifecycle_configuration.lifecycle_configuration.name


  tags = merge(
    local.common_tags,
    {
      git_commit           = "e131b949f91e6b10bef6ccdfdee957bae92b01b3"
      git_file             = "modules/sagemaker/main.tf"
      git_last_modified_at = "2023-09-24 20:09:33"
      git_last_modified_by = "kwame_mintah@hotmail.co.uk"
      git_modifiers        = "kwame_mintah"
      git_org              = "kwame-mintah"
      git_repo             = "terraform-aws-machine-learning-pipeline"
      yor_name             = "notebook_instance"
      yor_trace            = "b9fda050-f6ad-4029-ae4d-2cfee651deda"
  })
}


#---------------------------------------------------
# Lifecycle configurations
#---------------------------------------------------
resource "aws_sagemaker_notebook_instance_lifecycle_configuration" "lifecycle_configuration" {
  name     = "${var.name}-lifecycle-configuration"
  on_start = base64encode("echo how you doing")
}


#---------------------------------------------------
# IAM Role
#---------------------------------------------------
resource "aws_iam_role" "sagemaker_execution_role" {
  name               = "SageMakerExecutionRole"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.sagemaker_assume_policy.json

  tags = merge(
    local.common_tags,
    {
      git_commit           = "6a8a81c800dcaefed70b28d8692080306b9ae9fc"
      git_file             = "modules/sagemaker/main.tf"
      git_last_modified_at = "2023-10-03 21:19:32"
      git_last_modified_by = "kwame_mintah@hotmail.co.uk"
      git_modifiers        = "kwame_mintah"
      git_org              = "kwame-mintah"
      git_repo             = "terraform-aws-machine-learning-pipeline"
      yor_name             = "sagemaker_execution_role"
      yor_trace            = "42187633-f1cd-4c17-8b0d-e307f8abd446"
  })
}

resource "aws_iam_role_policy_attachment" "sagemaker_notebook_instance_policy" {
  role       = aws_iam_role.sagemaker_execution_role.name
  policy_arn = aws_iam_policy.sagemaker_notebook_policy.arn
}

resource "aws_iam_policy" "sagemaker_notebook_policy" {
  name   = "sagemaker-notebook-policy"
  policy = data.aws_iam_policy_document.sagemaker_notebook_instance_policy.json

  tags = merge(
    local.common_tags,
    {
      git_commit           = "fdfa8766a6d7a30bc266c5266960b1305a1c6be3"
      git_file             = "modules/sagemaker/main.tf"
      git_last_modified_at = "2023-10-03 21:31:23"
      git_last_modified_by = "kwame_mintah@hotmail.co.uk"
      git_modifiers        = "kwame_mintah"
      git_org              = "kwame-mintah"
      git_repo             = "terraform-aws-machine-learning-pipeline"
      yor_name             = "sagemaker_notebook_policy"
      yor_trace            = "9e5cda28-f847-4a49-b780-ffa51c3ab15d"
  })
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
    sid = "limitInstanceSize"
    actions = [
      "sagemaker:CreateEndpointConfig",
      "sagemaker:CreateHyperParameterTuningJob",
      "sagemaker:CreateProcessingJob",
      "sagemaker:CreateTrainingJob",
      "sagemaker:CreateTransformJob"
    ]
    effect = "Allow"
    condition {
      test     = "ForAnyValue:StringEquals"
      variable = "sagemaker:InstanceTypes"
      values   = ["ml.m4.xlarge", "ml.m4.xlarge", "ml.m4.xlarge"]
    }
    resources = [
      "arn:aws:sagemaker:${data.aws_region.current_caller_region.name}:${data.aws_caller_identity.current_caller_identity.account_id}:endpoint-config/xgboost*",
      "arn:aws:sagemaker:${data.aws_region.current_caller_region.name}:${data.aws_caller_identity.current_caller_identity.account_id}:processing-job/*",
      "arn:aws:sagemaker:${data.aws_region.current_caller_region.name}:${data.aws_caller_identity.current_caller_identity.account_id}:training-job/xgboost*",
    ]
  }

  statement {
    sid = "AdditionalPolicy"
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
      "sagemaker:CreateTrainingJob",
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
    effect = "Allow"
    resources = var.additional_resources != null ? concat(var.additional_resources, [
      aws_sagemaker_notebook_instance.notebook_instance.arn,
      aws_iam_role.sagemaker_execution_role.arn,
      "arn:aws:sagemaker:${data.aws_region.current_caller_region.name}:${data.aws_caller_identity.current_caller_identity.account_id}:endpoint-config/xgboost*",
      "arn:aws:sagemaker:${data.aws_region.current_caller_region.name}:${data.aws_caller_identity.current_caller_identity.account_id}:endpoint/xgboost*",
      "arn:aws:sagemaker:${data.aws_region.current_caller_region.name}:${data.aws_caller_identity.current_caller_identity.account_id}:model/xgboost*",
      "arn:aws:sagemaker:${data.aws_region.current_caller_region.name}:${data.aws_caller_identity.current_caller_identity.account_id}:training-job/*",
      "${aws_cloudwatch_log_group.sagemaker_training_jobs.arn}:*",
    ]) : [aws_sagemaker_notebook_instance.notebook_instance.arn, aws_iam_role.sagemaker_execution_role.arn]
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
    local.common_tags,
    {
      git_commit           = "fdfa8766a6d7a30bc266c5266960b1305a1c6be3"
      git_file             = "modules/sagemaker/main.tf"
      git_last_modified_at = "2023-10-03 21:31:23"
      git_last_modified_by = "kwame_mintah@hotmail.co.uk"
      git_modifiers        = "kwame_mintah"
      git_org              = "kwame-mintah"
      git_repo             = "terraform-aws-machine-learning-pipeline"
      yor_name             = "kms"
      yor_trace            = "75d75562-0366-4d8c-912e-5c9730137e23"
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

#tfsec:ignore:aws-iam-no-policy-wildcards
data "aws_iam_policy_document" "kms_policy" {
  statement {
    sid     = "Enable IAM User Permissions"
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

  statement {
    sid    = "Allow logs to (encryp,decryp)t messages"
    effect = "Allow"

    actions = [
      "kms:Encrypt*",
      "kms:Decrypt*",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:Describe*"
    ]
    resources = ["*"]

    principals {
      identifiers = ["logs.${data.aws_region.current_caller_region.name}.amazonaws.com"]
      type        = "Service"
    }

    condition {
      test     = "ArnEquals"
      variable = "kms:EncryptionContext:aws:logs:arn"
      values = [
        "arn:aws:logs:${data.aws_region.current_caller_region.name}:${data.aws_caller_identity.current_caller_identity.account_id}:log-group:/aws/sagemaker/NotebookInstances",
        "arn:aws:logs:${data.aws_region.current_caller_region.name}:${data.aws_caller_identity.current_caller_identity.account_id}:log-group:/aws/sagemaker/TrainingJobs",
        "arn:aws:logs:${data.aws_region.current_caller_region.name}:${data.aws_caller_identity.current_caller_identity.account_id}:log-group:/aws/sagemaker/Endpoints/linear-learner"
      ]
    }

    # Potentially useful, will re-consider at a later date.
    # condition {
    #   test     = "StringEquals"
    #   variable = "kms:ViaService"
    #   values   = ["logs.${data.aws_region.current_caller_region.name}.amazonaws.com"]
    # }
  }
}


#---------------------------------------------------
# Networking
#---------------------------------------------------
#tfsec:ignore:aws-vpc-no-public-egress-sgr
resource "aws_security_group" "sagemaker_sg" {
  name        = "${var.name}-sagemaker-sg"
  description = "Allow access to SageMaker"
  vpc_id      = var.vpc_id

  egress {
    description = "All traffic"
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    local.common_tags,
    {
      "Name" = "${var.name}-sagemaker-sg"
    },
    {
      git_commit           = "fdfa8766a6d7a30bc266c5266960b1305a1c6be3"
      git_file             = "modules/sagemaker/main.tf"
      git_last_modified_at = "2023-10-03 21:31:23"
      git_last_modified_by = "kwame_mintah@hotmail.co.uk"
      git_modifiers        = "kwame_mintah"
      git_org              = "kwame-mintah"
      git_repo             = "terraform-aws-machine-learning-pipeline"
      yor_name             = "sagemaker_sg"
      yor_trace            = "2bd66a0b-97dc-4d6a-9233-2d91671970f8"
  })
}

resource "aws_subnet" "sagemaker_subnet" {
  vpc_id     = var.vpc_id
  cidr_block = cidrsubnet(var.vpc_ipv4_cidr_block, "10", 1)

  tags = merge(
    local.common_tags,
    {
      "Name" = "${var.name}-subnet-1"
      "Tier" = "Private"
    },
    {
      git_commit           = "fdfa8766a6d7a30bc266c5266960b1305a1c6be3"
      git_file             = "modules/sagemaker/main.tf"
      git_last_modified_at = "2023-10-03 21:31:23"
      git_last_modified_by = "kwame_mintah@hotmail.co.uk"
      git_modifiers        = "kwame_mintah"
      git_org              = "kwame-mintah"
      git_repo             = "terraform-aws-machine-learning-pipeline"
      yor_name             = "sagemaker_subnet"
      yor_trace            = "97b46e2a-b83c-4921-8698-5f57fee65925"
  })
}

resource "aws_route_table" "route_table" {
  vpc_id = var.vpc_id
  tags = merge(
    local.common_tags,
    {
      Name = "${var.name}-route-table"
    },
    {
      git_commit           = "fdfa8766a6d7a30bc266c5266960b1305a1c6be3"
      git_file             = "modules/sagemaker/main.tf"
      git_last_modified_at = "2023-10-03 21:31:23"
      git_last_modified_by = "kwame_mintah@hotmail.co.uk"
      git_modifiers        = "kwame_mintah"
      git_org              = "kwame-mintah"
      git_repo             = "terraform-aws-machine-learning-pipeline"
      yor_name             = "route_table"
      yor_trace            = "07004bb7-76cb-4c41-8541-342a8377beea"
  })
}

resource "aws_route_table_association" "route_table_association" {
  subnet_id      = aws_subnet.sagemaker_subnet.id
  route_table_id = aws_route_table.route_table.id
}


#---------------------------------------------------
# CloudWatch Log Group
#---------------------------------------------------
resource "aws_cloudwatch_log_group" "sagemaker_notebook_instances" {
  name              = "/aws/sagemaker/NotebookInstances"
  kms_key_id        = aws_kms_key.kms.arn # Same KMS as SageMaker?
  retention_in_days = "7"

  tags = merge(
    local.common_tags
    , {
      git_commit           = "e2dad50a718976154a90f5802ca4acc53fb1f676"
      git_file             = "modules/sagemaker/main.tf"
      git_last_modified_at = "2023-11-09 20:46:13"
      git_last_modified_by = "kwame_mintah@hotmail.co.uk"
      git_modifiers        = "kwame_mintah"
      git_org              = "kwame-mintah"
      git_repo             = "terraform-aws-machine-learning-pipeline"
      yor_name             = "sagemaker_notebook_instances"
      yor_trace            = "8627a100-8d39-4c55-92ed-72d9aa296b40"
  })
}

resource "aws_cloudwatch_log_group" "sagemaker_training_jobs" {
  name              = "/aws/sagemaker/TrainingJobs"
  kms_key_id        = aws_kms_key.kms.arn # Same KMS as SageMaker?
  retention_in_days = "7"

  tags = merge(
    local.common_tags
    , {
      git_commit           = "e2dad50a718976154a90f5802ca4acc53fb1f676"
      git_file             = "modules/sagemaker/main.tf"
      git_last_modified_at = "2023-11-09 20:46:13"
      git_last_modified_by = "kwame_mintah@hotmail.co.uk"
      git_modifiers        = "kwame_mintah"
      git_org              = "kwame-mintah"
      git_repo             = "terraform-aws-machine-learning-pipeline"
      yor_name             = "sagemaker_training_jobs"
      yor_trace            = "72fae4f5-f38e-4bab-b261-8dc462b95e68"
  })
}

resource "aws_cloudwatch_log_group" "sagemaker_endpoints" {
  name              = "/aws/sagemaker/Endpoints/linear-learner"
  kms_key_id        = aws_kms_key.kms.arn # Same KMS as SageMaker?
  retention_in_days = "7"

  tags = merge(
    local.common_tags,
    {
      git_commit           = "e2dad50a718976154a90f5802ca4acc53fb1f676"
      git_file             = "modules/sagemaker/main.tf"
      git_last_modified_at = "2023-11-09 20:46:13"
      git_last_modified_by = "kwame_mintah@hotmail.co.uk"
      git_modifiers        = "kwame_mintah"
      git_org              = "kwame-mintah"
      git_repo             = "terraform-aws-machine-learning-pipeline"
      yor_name             = "sagemaker_endpoints"
      yor_trace            = "03641519-4501-4690-826b-7fbb3d118018"
  })
}

resource "aws_cloudwatch_log_group" "processing_jobs" {
  name              = "/aws/sagemaker/ProcessingJobs"
  kms_key_id        = aws_kms_key.kms.arn # Same KMS as SageMaker?
  retention_in_days = "7"

  tags = merge(
    local.common_tags,
    {
      git_commit           = "ea4f3f3011bc91d8e746cdfc7d4cccbae01f0625"
      git_file             = "modules/sagemaker/main.tf"
      git_last_modified_at = "2023-11-15 20:39:57"
      git_last_modified_by = "kwame_mintah@hotmail.co.uk"
      git_modifiers        = "kwame_mintah"
      git_org              = "kwame-mintah"
      git_repo             = "terraform-aws-machine-learning-pipeline"
      yor_name             = "processing_jobs"
      yor_trace            = "74413d7b-7710-4622-b46a-1c6df1377c38"
  })
}

resource "aws_cloudwatch_log_group" "endpoints" {
  name              = "/aws/sagemaker/Endpoints"
  kms_key_id        = aws_kms_key.kms.arn # Same KMS as SageMaker?
  retention_in_days = "7"

  tags = merge(
    local.common_tags,
    {
      git_commit           = "ea4f3f3011bc91d8e746cdfc7d4cccbae01f0625"
      git_file             = "modules/sagemaker/main.tf"
      git_last_modified_at = "2023-11-15 20:39:57"
      git_last_modified_by = "kwame_mintah@hotmail.co.uk"
      git_modifiers        = "kwame_mintah"
      git_org              = "kwame-mintah"
      git_repo             = "terraform-aws-machine-learning-pipeline"
      yor_name             = "endpoints"
      yor_trace            = "ddb05177-7cbf-49ba-a6ce-ba0c70906746"
  })
}
