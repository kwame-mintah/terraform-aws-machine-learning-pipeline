variable "aws_region" {
  description = <<-EOF
  The AWS region.

EOF

  type = string
}

variable "environment" {
  description = <<-EOF
  The name of the _environment_ to help identify resources.

EOF

  type = string
}

variable "env_prefix" {
  description = <<-EOF
  The prefix added to resources in the environment.

EOF

  type = string
  validation {
    condition     = contains(["dev", "staging", "prod", "sandbox"], var.env_prefix)
    error_message = "The env_prefix value must be either: dev, staging, prod or sandbox."
  }
}

variable "tags" {
  description = <<-EOF
    Tags to be added to resources created.
    
EOF

  type    = map(string)
  default = {}
}
