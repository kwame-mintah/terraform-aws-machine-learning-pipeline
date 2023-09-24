# Configure the AWS Provider
provider "aws" {}
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
      git_commit           = "N/A"
      git_file             = "main.tf"
      git_last_modified_at = "2023-09-24 19:22:54"
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
  source              = "./modules/sagemaker"
  name                = "${local.name_prefix}-sagemaker"
  vpc_id              = aws_vpc.application_vpc.id
  vpc_ipv4_cidr_block = aws_vpc.application_vpc.cidr_block

  tags = var.tags
}
