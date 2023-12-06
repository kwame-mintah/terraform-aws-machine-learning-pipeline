# GitHub Action

A module to create a IAM role and configure a IAM identify provider for GitHub. This is then used in conjunction with the GitHub action [configure-aws-credentials
](https://github.com/aws-actions/configure-aws-credentials).

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK --->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.4 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.17.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.17.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_openid_connect_provider.github_openid_connect](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_openid_connect_provider) | resource |
| [aws_iam_policy.s3_allow_action_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.github_action_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.s3_bucket_inline_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_caller_identity.current_caller_identity](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.oidc_assume_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.s3_allow_action_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_github_branch"></a> [github\_branch](#input\_github\_branch) | The GitHub repository branch that is allowed to run the [configure-aws-credentials](https://github.com/aws-actions/configure-aws-credentials/)<br>action. | `string` | `"refs/heads/main"` | no |
| <a name="input_github_repository"></a> [github\_repository](#input\_github\_repository) | The GitHub repository using the [configure-aws-credentials](https://github.com/aws-actions/configure-aws-credentials/)<br>action. | `string` | n/a | yes |
| <a name="input_github_thumbprints"></a> [github\_thumbprints](#input\_github\_thumbprints) | The GitHub server certificate thumbprint(s). | `list(string)` | n/a | yes |
| <a name="input_s3_bucket"></a> [s3\_bucket](#input\_s3\_bucket) | The S3 Bucket that the GitHub action will be uploading buckets to. | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to be added to resources created. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_github_action_role_arn"></a> [github\_action\_role\_arn](#output\_github\_action\_role\_arn) | The ARN of the AWSGitHubAction role. |
| <a name="output_github_openid_connect_arn"></a> [github\_openid\_connect\_arn](#output\_github\_openid\_connect\_arn) | The ARN assigned by AWS for this provider. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK --->