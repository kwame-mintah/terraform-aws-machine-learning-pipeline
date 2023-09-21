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

variable "security_group" {
  description = <<-EOF
    The associated security groups.
    
EOF

  type    = set(string)
  default = null
}

variable "subnet_id" {
  description = <<-EOF
    The VPC subnet ID.
    
EOF

  type    = string
  default = null
}

variable "tags" {
  description = <<-EOF
    Tags to be added to resources created.
    
EOF

  type    = map(string)
  default = {}
}
