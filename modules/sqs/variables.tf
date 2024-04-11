variable "name" {
  description = <<-EOF
    The name of the queue.
    
EOF

  type = string
}

variable "dlq_message_retention_seconds" {
  description = <<-EOF
    The number of seconds Amazon SQS DLQ retains a message.
    
EOF

  type    = number
  default = 345600
}

variable "message_retention_seconds" {
  description = <<-EOF
    The number of seconds Amazon SQS retains a message.
    
EOF

  type    = number
  default = 345600
}

variable "queue_visibility_timeout_seconds" {
  description = <<-EOF
    The visibility timeout for the queue.
    
EOF

  type    = number
  default = 30
}

variable "tags" {
  description = <<-EOF
    Tags to be added to resources created.
    
EOF

  type    = map(string)
  default = {}
}
