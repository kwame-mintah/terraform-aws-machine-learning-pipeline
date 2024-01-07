resource "aws_ssm_parameter" "s3_bucket_arn" {
  name   = "${var.name}-arn"
  type   = "SecureString"
  value  = aws_s3_bucket.s3_bucket.arn
  key_id = aws_kms_key.kms.id

  tags = merge(
    local.common_tags,
    {
      yor_name  = "s3_bucket_arn"
      yor_trace = "d03fa2dd-a80c-4825-bb0c-e4d52965a331"
  })
}

resource "aws_ssm_parameter" "s3_bucket_name" {
  name   = var.name
  type   = "SecureString"
  value  = aws_s3_bucket.s3_bucket.id
  key_id = aws_kms_key.kms.id

  tags = merge(
    local.common_tags,
    {
      yor_name  = "s3_bucket_name"
      yor_trace = "71ebf1ca-1183-479c-af9b-9a2572574ebf"
  })
}
