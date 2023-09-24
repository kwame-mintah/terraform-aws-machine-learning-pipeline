# Terragrunt will copy the Terraform files from the locations specified into this directory
terraform {
  source = "../.."
}

locals {
  environment = "development"
}

# These are inputs that need to be passed for the terragrunt configuration
inputs = {
  aws_region = "eu-west-2"
  env_prefix = "dev"
  environment = "${local.environment}"
  tags = {
    Terraform   = "true"
    Environment = "${local.environment}"
  }
}

# (1) This block of code needs to be commented out first, before attempting to use the remote state/
remote_state {
  backend = "local"
  config = {
    path = "${local.environment}/${path_relative_to_include()}/terraform.tfstate"
  }
}

# (2) After all configurations have been populated run `terragrunt init -migrate-state` in the directory
# When prompted, answer yes and will copy the state file to the storage account.
// remote_state {
//   backend = "s3"
//   config = {
//     encrypt        = true
//     bucket         = ""
//     key            = "${local.environment}/${path_relative_to_include()}/terraform.tfstate"
//     region         = local.aws_region
//     dynamodb_table = ""
//     s3_bucket_tags = {
//       "Account name" = "${local.account_name}"
//     }
//   }
//   generate = {
//     path      = "backend_override.tf"
//     if_exists = "overwrite_terragrunt"
//   }
// }
