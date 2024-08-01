# Simple Queue Service (SQS)

This module creates an encrypted SQS and dead letter queue (DLQ).

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

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_kms_alias.kms_alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.kms](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_kms_key_policy.kms_key_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key_policy) | resource |
| [aws_sqs_queue.dlq_queue](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) | resource |
| [aws_sqs_queue.sqs_queue](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) | resource |
| [aws_ssm_parameter.dlq_arn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.dlq_name](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.queue_arn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.queue_name](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.ssm_kms_key_arn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_caller_identity.current_caller_identity](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.kms_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dlq_message_retention_seconds"></a> [dlq\_message\_retention\_seconds](#input\_dlq\_message\_retention\_seconds) | The number of seconds Amazon SQS DLQ retains a message. | `number` | `345600` | no |
| <a name="input_message_retention_seconds"></a> [message\_retention\_seconds](#input\_message\_retention\_seconds) | The number of seconds Amazon SQS retains a message. | `number` | `345600` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the queue. | `string` | n/a | yes |
| <a name="input_queue_visibility_timeout_seconds"></a> [queue\_visibility\_timeout\_seconds](#input\_queue\_visibility\_timeout\_seconds) | The visibility timeout for the queue. | `number` | `30` | no |
| <a name="input_store_dlq_arn"></a> [store\_dlq\_arn](#input\_store\_dlq\_arn) | Store the ARN of the DLQ in Systems Manager Parameter Store. | `bool` | `false` | no |
| <a name="input_store_dlq_name"></a> [store\_dlq\_name](#input\_store\_dlq\_name) | Store the name of the DLQ in Systems Manager Parameter Store. | `bool` | `false` | no |
| <a name="input_store_queue_arn"></a> [store\_queue\_arn](#input\_store\_queue\_arn) | Store the ARN of the queue in Systems Manager Parameter Store. | `bool` | `false` | no |
| <a name="input_store_queue_name"></a> [store\_queue\_name](#input\_store\_queue\_name) | Store the name of the queue in Systems Manager Parameter Store. | `bool` | `false` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to be added to resources created. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dlq_arn"></a> [dlq\_arn](#output\_dlq\_arn) | The ARN of the SQS DLQ queue. |
| <a name="output_queue_arn"></a> [queue\_arn](#output\_queue\_arn) | The ARN of the SQS queue |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK --->