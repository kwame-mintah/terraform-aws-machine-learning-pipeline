output "availability_zones" {
  description = <<-EOF
    List of the Availability Zone names available to the account.

EOF

  value = data.aws_availability_zones.avaliabile_zones.names
}

output "current_caller_identity" {
  description = <<-EOF
    AWS Account ID number of the account that owns or contains the 
    calling entity.

EOF

  value = data.aws_caller_identity.current_caller_identity.account_id
}
