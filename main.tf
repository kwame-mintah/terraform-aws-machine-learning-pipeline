data "aws_availability_zones" "avaliabile_zones" {}
data "aws_caller_identity" "current_caller_identity" {}

locals {
  name_prefix = "${var.project_name}-${var.aws_region}-${var.env_prefix}"
}

resource "aws_vpc" "application_vpc" {
  cidr_block           = var.application_vpc_ipv4_cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(
    var.tags,
    {
      "Name" = "${local.name_prefix}-vpc"
    },
    {
      git_commit           = "5e20a51478800b5c8e03688b3198d7f0de72a190"
      git_file             = "main.tf"
      git_last_modified_at = "2023-09-24 20:29:25"
      git_last_modified_by = "kwame_mintah@hotmail.co.uk"
      git_modifiers        = "kwame_mintah"
      git_org              = "kwame-mintah"
      git_repo             = "terraform-aws-machine-learning-pipeline"
      yor_name             = "application_vpc"
      yor_trace            = "4630664e-a95a-4395-8329-2428b99f02b6"
    }
  )
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
  source                 = "./modules/s3_bucket"
  name                   = "${local.name_prefix}-data"
  principles_identifiers = [module.sagemaker.sagemaker_notebook_execution_role_arn, module.github_action.github_action_role_arn]

  tags = var.tags
}
