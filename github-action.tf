module "github_action" {
  source             = "./modules/github_action"
  s3_bucket          = [module.ml_data.s3_bucket_arn]
  github_repository  = "kwame-mintah/github-action-test"
  github_thumbprints = ["1b511abead59c6ce207077c0bf0e0043b1382612"]

  tags = merge(
    var.tags,
  )
}
