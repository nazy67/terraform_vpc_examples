# Providers variables
variable "aws_region" {
  type        = string
  description = "The region Terraform deploys your infra"
}

# VPC variables
variable "vpc_cidr_block" {
  type        = string
  description = "CIDR block for the VPC"
}

variable "instance_tenancy" {
  type        = string
  description = "the tenancy of existing VPCs from dedicated to default instantly"
}

variable "is_enabled_dns_support" {
  type        = bool
  description = "enabling dns support"
}

variable "is_enabled_dns_hostnames" {
  type        = bool
  description = "enabling dns hostnames"
}

variable "cidr_block" {
  description = "ingress/egress cidr block"
  type        = string
}

# Subnet variables
variable "aws_az_1a" {
  type        = string
  description = "The region Terraform deploys your infra"
}

variable "aws_az_1b" {
  type        = string
  description = "The region Terraform deploys your infra"
}

variable "aws_az_1c" {
  type        = string
  description = "The region Terraform deploys your infra"
}

variable "pub_cidr1_subnet" {
  type        = string
  description = "CIDR block for the  1st public subnet"
}

variable "pub_cidr2_subnet" {
  type        = string
  description = "CIDR block for the 2nd public subnet"
}

variable "pub_cidr3_subnet" {
  type        = string
  description = "CIDR block for the 2nd public subnet"
}

variable "priv_cidr1_subnet" {
  type        = string
  description = "CIDR block for the 1st private subnet"
}

variable "priv_cidr2_subnet" {
  type        = string
  description = "CIDR block for the 2nd private subnet"
}

variable "priv_cidr3_subnet" {
  type        = string
  description = "CIDR block for the 2nd private subnet"
}

# Tags variables
variable "env" {
  type        = string
  description = "name of the environment"
}

variable "project_name" {
  type        = string
  description = "name of the project"
}