locals {
  project_name = "mlops"
  aws_region   = "eu-west-2"
  # Could use `find_in_parent_folders()` if file was in the parent directory.
  account     = read_terragrunt_config("account.hcl")
  environment = read_terragrunt_config("environment.hcl")

  account_id       = local.account.locals.account_id
  account_name     = local.account.locals.account_name
  environment_name = local.environment.locals.environment_name
}


generate "provider" {
  path      = "provider_override.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region              = "${local.aws_region}"
  allowed_account_ids = ["${local.account_id}"]
}
EOF
}


remote_state {
  backend = "s3"
  config = {
    encrypt        = true
    bucket         = "tfstate-${local.project_name}-${local.aws_region}-${local.environment_name}"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = local.aws_region
    dynamodb_table = "lock-${local.project_name}-${local.aws_region}-${local.environment_name}"
    s3_bucket_tags = {
      "Account name" = "${local.account_name}"
      "Project name" = "${local.project_name}"
    }
  }
  generate = {
    path      = "backend_override.tf"
    if_exists = "overwrite_terragrunt"
  }
}


#-------------------------------------------------------------------------------------------
# GLOBAL INPUTS
# These inputs apply to all terragrunt configurations in this subfolder. 
# There will be automatically merged into the child `terragrunt.hcl` using `include {}` block.
#-------------------------------------------------------------------------------------------
inputs = {
  aws_region   = "${local.aws_region}"
  project_name = "${local.project_name}"
}

# Retry terragrunt actions due to reasons below.
retryable_errors = [
  "(?s).*A conflicting conditional operation is currently in progress against this resource. Please try again*",
  "(?s).*The specified KMS key does not exist or is not allowed to be used with Arn 'arn:aws:logs:eu-west-2:*"
]
