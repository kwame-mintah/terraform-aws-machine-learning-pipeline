data "aws_availability_zones" "available_zones" {}
data "aws_caller_identity" "current_caller_identity" {}

locals {
  name_prefix = "${var.project_name}-${var.aws_region}-${var.env_prefix}"
}

#---------------------------------------------------
# Application virtual private network (VPC)
#---------------------------------------------------

#trivy:ignore:AVD-AWS-0178
resource "aws_vpc" "application_vpc" {
  #checkov:skip=CKV2_AWS_11:out of scope for this demostration.
  cidr_block           = var.application_vpc_ipv4_cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(
    var.tags,
    {
      "Name" = "${local.name_prefix}-vpc"
    },
    {
      git_commit           = "N/A"
      git_file             = "main.tf"
      git_last_modified_at = "2024-01-06 20:05:20"
      git_last_modified_by = "kwame_mintah@hotmail.co.uk"
      git_modifiers        = "kwame_mintah"
      git_org              = "kwame-mintah"
      git_repo             = "terraform-aws-machine-learning-pipeline"
      yor_name             = "application_vpc"
      yor_trace            = "4630664e-a95a-4395-8329-2428b99f02b6"
    }
  )
}

resource "aws_default_security_group" "default_security_group" {
  vpc_id  = aws_vpc.application_vpc.id
  ingress = []
  egress  = []

  tags = merge(
    var.tags,
    {
      git_commit           = "50099d4f09f2eb9b871f799b543875169445851c"
      git_file             = "main.tf"
      git_last_modified_at = "2023-11-14 18:35:59"
      git_last_modified_by = "kwame_mintah@hotmail.co.uk"
      git_modifiers        = "kwame_mintah"
      git_org              = "kwame-mintah"
      git_repo             = "terraform-aws-machine-learning-pipeline"
      yor_name             = "default_security_group"
      yor_trace            = "e0216982-fa56-42db-abc6-732fb7a74c6f"
  })
}


module "sagemaker" {
  source               = "./modules/sagemaker"
  name                 = "${local.name_prefix}-sagemaker"
  vpc_id               = aws_vpc.application_vpc.id
  vpc_ipv4_cidr_block  = aws_vpc.application_vpc.cidr_block
  additional_resources = ["${module.ml_data.s3_bucket_arn}/*", module.ml_data.s3_bucket_arn]

  tags = var.tags
}

module "ml_data" {
  source                             = "./modules/s3_bucket"
  name                               = "${local.name_prefix}-data"
  principles_identifiers             = [module.sagemaker.sagemaker_notebook_execution_role_arn, module.github_action.github_action_role_arn]
  store_bucket_arn_in_ssm_parameter  = true
  store_bucket_name_in_ssm_parameter = true
  store_kms_key_arn_in_ssm_parameter = true

  tags = var.tags
}

module "automl_data" {
  source                             = "./modules/s3_bucket"
  name                               = "${local.name_prefix}-automl-data"
  principles_identifiers             = [module.sagemaker.sagemaker_notebook_execution_role_arn, module.github_action.github_action_role_arn]
  store_bucket_arn_in_ssm_parameter  = true
  store_bucket_name_in_ssm_parameter = true
  store_kms_key_arn_in_ssm_parameter = true

  tags = var.tags
}

module "serverless_deployment" {
  source                             = "./modules/s3_bucket"
  name                               = "${local.name_prefix}-serverless-deployment"
  principles_identifiers             = [module.github_action.github_action_role_arn]
  store_bucket_name_in_ssm_parameter = true

  tags = var.tags
}
