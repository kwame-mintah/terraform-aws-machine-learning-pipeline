# (1) This block of code needs to be commented out first, before attempting to use the s3 backend
# After all configurations have been applied run `terragrunt init -migrate-state` in the directory
# When prompted, answer yes and will copy the state file to the remote storage.
terraform {
  backend "local" {}
}

# (2) Only uncomment out this code block, if you have an AWS S3 bucket ready to store the .tfstate file.
# terraform {
#   backend "s3" {}
# }
