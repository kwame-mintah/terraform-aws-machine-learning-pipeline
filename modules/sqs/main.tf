# Simple Queue Service --------------------------
# -----------------------------------------------

locals {
  common_tags = merge(
    var.tags
  )
}

resource "aws_sqs_queue" "sqs_queue" {
  name                       = "${var.name}-queue"
  message_retention_seconds  = var.message_retention_seconds
  sqs_managed_sse_enabled    = true
  visibility_timeout_seconds = var.queue_visibility_timeout_seconds

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dlq_queue.arn
    maxReceiveCount     = 4
  })

  tags = merge(
    local.common_tags,
    {
      git_commit           = "5a0076bb33c093b3e982fea30075951e2525dba5"
      git_file             = "modules/sqs/main.tf"
      git_last_modified_at = "2024-04-17 19:06:45"
      git_last_modified_by = "kwame_mintah@hotmail.co.uk"
      git_modifiers        = "kwame_mintah"
      git_org              = "kwame-mintah"
      git_repo             = "terraform-aws-machine-learning-pipeline"
      yor_name             = "sqs_queue"
      yor_trace            = "d4e61dd3-ea0e-4710-a9fc-27ec9b9b1c87"
  })
}

resource "aws_sqs_queue" "dlq_queue" {
  name                      = "${var.name}-dlq"
  sqs_managed_sse_enabled   = true
  message_retention_seconds = var.dlq_message_retention_seconds

  tags = merge(
    local.common_tags,
    {
      git_commit           = "5a0076bb33c093b3e982fea30075951e2525dba5"
      git_file             = "modules/sqs/main.tf"
      git_last_modified_at = "2024-04-17 19:06:45"
      git_last_modified_by = "kwame_mintah@hotmail.co.uk"
      git_modifiers        = "kwame_mintah"
      git_org              = "kwame-mintah"
      git_repo             = "terraform-aws-machine-learning-pipeline"
      yor_name             = "dlq_queue"
      yor_trace            = "45871797-5e20-40e8-9dd3-ee5fb1539433"
  })
}
