variable "name" {
  description = <<-EOF
    Name of the bucket. If omitted, Terraform will assign a random, unique name. 
    Must be lowercase and less than or equal to 63 characters in length.
    
EOF

  type = string
}

variable "tags" {
  description = <<-EOF
    Tags to be added to resources created.
    
EOF

  type    = map(string)
  default = {}
}

variable "principles_identifiers" {
  description = <<-EOF
    List of ARNs that have access to the key.
    
EOF

  type    = list(string)
  default = []
}

variable "store_bucket_arn_in_ssm_parameter" {
  description = <<-EOF
    Store the ARN of the bucket in Systems Manager Parameter Store.
    
EOF

  type    = bool
  default = false
}

variable "store_bucket_name_in_ssm_parameter" {
  description = <<-EOF
    Store the name of the bucket in Systems Manager Parameter Store.
    
EOF

  type    = bool
  default = false
}

variable "store_kms_key_arn_in_ssm_parameter" {
  description = <<-EOF
    Store the KMS Key in Systems Manager Parameter Store.
    
EOF

  type    = bool
  default = false
}

