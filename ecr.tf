# Ideally, ECR repositories would not be deployed to each AWS environment / account.
# A shared location can be used and access given for each account to perform
# necassary actions.

# Repository for lambda docker image for running data preprocessing
module "lambda_data_preprocessing_ecr" {
  source                 = "./modules/ecr"
  repository_name        = "${var.project_name}-data-preprocessing"
  principles_identifiers = [module.github_action.github_action_role_arn]
  tags = merge(
    var.tags,
    {
      image_source = "https://github.com/kwame-mintah/aws-lambda-data-preprocessing"
    }
  )
}

# Repository for lambda docker image for running training job
module "lambda_model_training_ecr" {
  source                 = "./modules/ecr"
  repository_name        = "${var.project_name}-model-training"
  principles_identifiers = [module.github_action.github_action_role_arn]
  tags = merge(
    var.tags,
    {
      image_source = "https://github.com/kwame-mintah/aws-lambda-model-training"
    }
  )
}

# Repository for lambda docker image for deploying machine learning models
module "lambda_model_deployment_ecr" {
  source                 = "./modules/ecr"
  repository_name        = "${var.project_name}-model-deployment"
  principles_identifiers = [module.github_action.github_action_role_arn]
  tags = merge(
    var.tags,
    {
      image_source = "https://github.com/kwame-mintah/aws-lambda-model-deployment"
    }
  )
}
