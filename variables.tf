variable "aws_region" {
  description = <<-EOF
  The AWS region.

EOF

  type = string
}

variable "application_vpc_ipv4_cidr_block" {
  description = <<-EOF
  TThe IPv4 CIDR block for the VPC.

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

variable "project_name" {
  description = <<-EOF
  The name of the project.

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
