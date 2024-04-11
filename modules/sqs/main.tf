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
  )
}

resource "aws_sqs_queue" "dlq_queue" {
  name                      = "${var.name}-dlq"
  sqs_managed_sse_enabled   = true
  message_retention_seconds = var.dlq_message_retention_seconds

  tags = merge(
    local.common_tags,
  )
}
