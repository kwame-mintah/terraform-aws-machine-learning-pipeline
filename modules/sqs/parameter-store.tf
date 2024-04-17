# Parameter Store -------------------------------
# -----------------------------------------------

resource "aws_ssm_parameter" "queue_arn" {
  count = var.store_queue_arn ? 1 : 0
  name  = "${var.name}-arn"
  type  = "SecureString"
  value = aws_sqs_queue.sqs_queue.arn

  tags = merge(
    local.common_tags,
    {
      yor_name  = "queue_arn"
      yor_trace = "e295390b-d895-4537-8312-4b480d062a12"
  })
}

resource "aws_ssm_parameter" "dlq_arn" {
  count = var.store_dlq_arn ? 1 : 0
  name  = "${var.name}-dlq-arn"
  type  = "SecureString"
  value = aws_sqs_queue.dlq_queue.arn

  tags = merge(
    local.common_tags,
    {
      yor_name  = "dlq_arn"
      yor_trace = "15ff26d6-345f-4e19-86a3-b98e4e54dee4"
  })
}

resource "aws_ssm_parameter" "queue_name" {
  count = var.store_queue_name ? 1 : 0
  name  = "${var.name}-name"
  type  = "SecureString"
  value = aws_sqs_queue.sqs_queue.name

  tags = merge(
    local.common_tags,
    {
      yor_name  = "queue_name"
      yor_trace = "37f0d9c5-fd9b-4391-8682-735410cccb4b"
  })
}

resource "aws_ssm_parameter" "dlq_name" {
  count = var.store_dlq_name ? 1 : 0
  name  = "${var.name}-dlq-name"
  type  = "SecureString"
  value = aws_sqs_queue.dlq_queue.name

  tags = merge(
    local.common_tags,
    {
      yor_name  = "dlq_name"
      yor_trace = "3457eb70-1f1c-4cae-9493-610cb2029df8"
  })
}
