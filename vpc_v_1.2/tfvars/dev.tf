# Provider region
aws_region        = "us-east-1"
# VPC
vpc_cidr_block    = "10.0.0.0/16"
instance_tenancy  = "default"
is_enabled_dns_support = true
is_enabled_dns_hostnames = true
rt_cidr_block  = "0.0.0.0/0"
# Subnet
subnet_azs         = ["us-east-1a", "us-east-1b","us-east-1c"  ]
pub_cidr_subnet  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24" ]
priv_cidr_subnet = ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]
# Tags
env               = "dev"
project_name      = "wordpress"