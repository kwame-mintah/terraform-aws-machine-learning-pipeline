# Configure the AWS Provider
provider "aws" {
  region = var.aws_region
}
data "aws_availability_zones" "avaliabile_zones" {}
data "aws_caller_identity" "current_caller_identity" {}

locals {
  name_prefix = var.env_prefix
}

module "sagemaker" {
  source = "./modules/sagemaker"
  name   = "${local.name_prefix}-sagemaker"
  tags   = var.tags
}
