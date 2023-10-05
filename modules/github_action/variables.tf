variable "tags" {
  description = <<-EOF
    Tags to be added to resources created.
    
EOF

  type    = map(string)
  default = {}
}

variable "github_repository" {
  description = <<-EOF
    The GitHub repository using the [configure-aws-credentials](https://github.com/aws-actions/configure-aws-credentials/)
    action.
    
EOF

  type = string
}

variable "github_branch" {
  description = <<-EOF
    The GitHub repository branch that is allowed to run the [configure-aws-credentials](https://github.com/aws-actions/configure-aws-credentials/)
    action.
    
EOF

  type    = string
  default = "refs/heads/main"
}

variable "github_thumbprints" {
  description = <<-EOF
    The GitHub server certificate thumbprint(s).
    
EOF

  type = list(string)
  validation {
    condition     = (length([var.github_thumbprints])) < 5
    error_message = "You can only add up to 5 thumbprints."
  }
}

variable "s3_bucket" {
  description = <<-EOF
    The S3 Bucket that the GitHub action will be uploading buckets to.
    
EOF

  type    = list(string)
  default = []
}

