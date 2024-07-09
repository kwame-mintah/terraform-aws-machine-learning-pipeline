# Terraform AWS Machine Learning Pipeline

The main purpose of this repository is to create resources needed for Machine Learning within AWS. And have a better understanding of Machine Learning Operations (MLOps). Notes can be found in my [notes-md](https://github.com/kwame-mintah/notes-md) repository, data used can be found in [ml-data-copy-to-aws-s3](https://github.com/kwame-mintah/ml-data-copy-to-aws-s3).

Additionally, the [serverless framework](https://www.serverless.com/) is used to deploy various AWS Lambda functions, this can be
found in [aws-automlops-serverless-deployment](https://github.com/kwame-mintah/aws-automlops-serverless-deployment).

## Development

### Dependencies

- [aws-vault](https://github.com/99designs/aws-vault)
- [terraform](https://www.terraform.io/)
- [terragrunt](https://terragrunt.gruntwork.io/)
- [terraform-docs](https://terraform-docs.io/) this is required for `terraform_docs` hooks
- [pre-commit](https://pre-commit.com/)

## Prerequisites

1. Have a [AWS account](https://aws.amazon.com/free) account and [associated credentials](https://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html)

## Usage

1. Navigate to the environment you would like to deploy,
2. Initialize the configuration with:

   ```bash
   aws-vault exec <profile> --no-session terragrunt init
   ```
3. Plan your changes with:

   ```bash
   aws-vault exec <profile> --no-session terragrunt plan
   ``` 
4. If you're happy with the changes:

   ```bash
   aws-vault exec <profile> --no-session terragrunt apply
   ```

> [!NOTE]
>
> Please note that terragrunt will create an S3 Bucket and DynamoDB table, for storing the remote state. 
> Ensure the account deploying the resources has the appropriate permissions to create or connect to these resources.

## GitHub Action (CI/CD)

A IAM user will need to be created within the AWS account, this will be used for the GitHub workflows (`.github/workflows`) that will deploy resources using [`terragrunt-action`](https://github.com/gruntwork-io/terragrunt-action). The following repository actions secrets and variables need to be set

| Secret                | Description                                      |
| --------------------- | ------------------------------------------------ |
| AWS_REGION            | The AWS Region, can also use AWS_DEFAULT_REGION. |
| AWS_ACCESS_KEY_ID     | The AWS access key.                              |
| AWS_SECRET_ACCESS_KEY | The AWS secret key.                              |

## Pre-Commit hooks

Git hook scripts are very helpful for identifying simple issues before pushing any changes. Hooks will run on every commit automatically pointing out issues in the code e.g. trailing whitespace.

To help with the maintenance of these hooks, [pre-commit](https://pre-commit.com/) is used, along with [pre-commit-hooks](https://pre-commit.com/#install).

Please following [these instructions](https://pre-commit.com/#install) to install `pre-commit` locally and ensure that you have run `pre-commit install` to install the hooks for this project.

Additionally, once installed, the hooks can be updated to the latest available version with `pre-commit autoupdate`.

## Documentation Generation

Code formatting and documentation for `variables` and `outputs` is generated using [pre-commit-terraform](https://github.com/antonbabenko/pre-commit-terraform/releases) hooks that in turn uses [terraform-docs](https://github.com/terraform-docs/terraform-docs) that will insert/update documentation. The following markers have been added to the `README.md`:

```
<!-- {BEGINNING|END} OF PRE-COMMIT-TERRAFORM DOCS HOOK --->
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK --->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.4 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.57.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.57.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_automl_data"></a> [automl\_data](#module\_automl\_data) | ./modules/s3_bucket | n/a |
| <a name="module_github_action"></a> [github\_action](#module\_github\_action) | ./modules/github_action | n/a |
| <a name="module_lambda_data_preprocessing_ecr"></a> [lambda\_data\_preprocessing\_ecr](#module\_lambda\_data\_preprocessing\_ecr) | ./modules/ecr | n/a |
| <a name="module_lambda_model_deployment_ecr"></a> [lambda\_model\_deployment\_ecr](#module\_lambda\_model\_deployment\_ecr) | ./modules/ecr | n/a |
| <a name="module_lambda_model_evaluation_ecr"></a> [lambda\_model\_evaluation\_ecr](#module\_lambda\_model\_evaluation\_ecr) | ./modules/ecr | n/a |
| <a name="module_lambda_model_training_ecr"></a> [lambda\_model\_training\_ecr](#module\_lambda\_model\_training\_ecr) | ./modules/ecr | n/a |
| <a name="module_ml_data"></a> [ml\_data](#module\_ml\_data) | ./modules/s3_bucket | n/a |
| <a name="module_model_eval_queue"></a> [model\_eval\_queue](#module\_model\_eval\_queue) | ./modules/sqs | n/a |
| <a name="module_model_monitoring"></a> [model\_monitoring](#module\_model\_monitoring) | ./modules/s3_bucket | n/a |
| <a name="module_model_output"></a> [model\_output](#module\_model\_output) | ./modules/s3_bucket | n/a |
| <a name="module_sagemaker"></a> [sagemaker](#module\_sagemaker) | ./modules/sagemaker | n/a |
| <a name="module_serverless_deployment"></a> [serverless\_deployment](#module\_serverless\_deployment) | ./modules/s3_bucket | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_default_security_group.default_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_security_group) | resource |
| [aws_vpc.application_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_availability_zones.available_zones](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_caller_identity.current_caller_identity](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application_vpc_ipv4_cidr_block"></a> [application\_vpc\_ipv4\_cidr\_block](#input\_application\_vpc\_ipv4\_cidr\_block) | TThe IPv4 CIDR block for the VPC. | `string` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The AWS region. | `string` | n/a | yes |
| <a name="input_env_prefix"></a> [env\_prefix](#input\_env\_prefix) | The prefix added to resources in the environment. | `string` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | The name of the project. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to be added to resources created. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_availability_zones"></a> [availability\_zones](#output\_availability\_zones) | List of the Availability Zone names available to the account. |
| <a name="output_current_caller_identity"></a> [current\_caller\_identity](#output\_current\_caller\_identity) | AWS Account ID number of the account that owns or contains the <br>calling entity. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK --->
