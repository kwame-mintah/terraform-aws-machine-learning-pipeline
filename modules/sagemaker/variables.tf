variable "additional_resources" {
  description = <<-EOF
    Additional resources to add to the `sagemaker_notebook_instance_policy` policy
    for `SageMakerExecutionRole` IAM role.

EOF

  type    = list(string)
  default = []
}

variable "name" {
  description = <<-EOF
    The name of the notebook instance (must be unique).
    
EOF

  type = string
}

variable "instance_type" {
  description = <<-EOF
    The name of ML compute instance type.
    
EOF

  type    = string
  default = "ml.t3.medium"
}

variable "tags" {
  description = <<-EOF
    Tags to be added to resources created.
    
EOF

  type    = map(string)
  default = {}
}

variable "vpc_id" {
  description = <<-EOF
    The VPC ID.
    
EOF

  type = string
}

variable "vpc_ipv4_cidr_block" {
  description = <<-EOF
    The IPv4 CIDR block for the VPC.
    
EOF

  type = string
}
