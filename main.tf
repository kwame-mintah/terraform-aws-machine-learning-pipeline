# Configure the AWS Provider
provider "aws" {}

data "aws_availability_zones" "avaliabile_zones" {}

data "aws_caller_identity" "current_caller_identity" {}
