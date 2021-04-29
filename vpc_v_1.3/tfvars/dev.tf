# Provider region
aws_region        = "us-east-1"

# VPC
vpc_cidr_block    = "10.0.0.0/16"
instance_tenancy  = "default"
is_enabled_dns_support = true
is_enabled_dns_hostnames = true
rt_cidr_block  = "0.0.0.0/0"

# Subnet variables

# Tags
env               = "dev"
project_name      = "wordpress"