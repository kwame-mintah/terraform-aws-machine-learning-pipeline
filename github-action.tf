module "github_action" {
  source              = "./modules/github_action"
  s3_bucket           = ["${module.ml_data.s3_bucket_arn}/*", module.ml_data.s3_bucket_arn, "${module.automl_data.s3_bucket_arn}/*", module.automl_data.s3_bucket_arn, "${module.model_output.s3_bucket_arn}/*", module.model_output.s3_bucket_arn, "${module.serverless_deployment.s3_bucket_arn}/*", module.serverless_deployment.s3_bucket_arn]
  github_repositories = ["repo:kwame-mintah/ml-data-copy-to-aws-s3:ref:refs/heads/main", "repo:kwame-mintah/aws-lambda-data-preprocessing:ref:refs/heads/main", "repo:kwame-mintah/aws-lambda-model-training:ref:refs/heads/main", "repo:kwame-mintah/aws-lambda-model-deployment:ref:refs/heads/main", "repo:kwame-mintah/aws-lambda-model-evaluation:ref:refs/heads/main"]
  github_thumbprints  = ["1b511abead59c6ce207077c0bf0e0043b1382612"]
  ecr_repository      = ["*", module.lambda_data_preprocessing_ecr.ecr_repository_arn, module.lambda_model_training_ecr.ecr_repository_arn, module.lambda_model_deployment_ecr.ecr_repository_arn]
  tags = merge(
    var.tags,
  )
}
