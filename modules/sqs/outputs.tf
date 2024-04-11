output "queue_arn" {
  value       = aws_sqs_queue.sqs_queue.arn
  description = <<-EOF
  The ARN of the SQS queue

EOF
}

output "dlq_arn" {
  value       = aws_sqs_queue.dlq_queue.arn
  description = <<-EOF
    The ARN of the SQS DLQ queue.

EOF
}
