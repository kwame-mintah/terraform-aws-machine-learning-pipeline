variable "force_delete" {
  description = <<-EOF
     If `true`, will delete the repository even if it contains images.
    
EOF

  type    = bool
  default = false
}

variable "repository_name" {
  description = <<-EOF
    Name of the repository.
    
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

  type = list(string)
}