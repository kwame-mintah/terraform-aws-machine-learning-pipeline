# Terragrunt will copy the Terraform files from the locations specified into this directory
terraform {
  source = "../.."
}

locals {
  environment = "development"
}

include {
  path = find_in_parent_folders()
}

# These are inputs that need to be passed for the terragrunt configuration
inputs = {
  env_prefix                      = "dev"
  application_vpc_ipv4_cidr_block = "10.20.0.0/16"
  tags = {
    Terraform   = "true"
    Environment = "${local.environment}"
  }
}
