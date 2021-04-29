## VPC using Terraform

This repository contains a different version of VPC templates, where each VPC provisions the resources for networking such as:

- VPC (Virtual Private Cloud)
- Three Public and Private subnets
- Internet Gateway
- Nat Gateway
- Public Route Table
- Public Route Table Association
- Private Route Table
- Private Route Table Association

1. Version ```vpc_v_1.0``` is hard coded, it is easy to read and great if you just started of with Terraform. Another reason why I have this example is to compare and show of how you can shorten your code using functions and meta-argumets by avoiding repeatable resources. The only trick we used here is on tags, we used ```merge``` function since we don't want to repeat the same environment and project name we used locals.tf file for it, where common tags were defined, and in the resource blocks we merged the common tags with the name of the resouce which are unique.

locals.tf
```
locals {
  common_tags = {
    Environment = var.env
    Project     = var.project_name
  }
}
```
vpc.tf
```
  tags = merge(
    local.common_tags,
    {
      Name = "${var.env}_vpc"
    }
  )
```

2. Version ```vpc_v_1.2``` configured with [count meta-argument](https://www.terraform.io/docs/language/meta-arguments/count.html). 

This version of VPC template is configured with ```count.index``` object, ```element```, ```lenght```, and ```merge``` functions. Here we have repeatable resources such as public/private subnets and public/private route table associations.  With one public/private subnet resource block we are able to provision three public/private subnets and instead of repeating the route table association three times we cofigured it with one resource block. For tags we used ```merge``` function for ```common_tags``` same as on previous example it's helpful to make your code clean and short.

variables.tf where we defined our variables.
```
# Subnet variables
variable "subnet_azs" {
  type        = list(string)
  description = "The availabitily zones where terraform deploys your infra"
}

variable "pub_cidr_subnet" {
  type        = list(string)
  description = "cird blocks for the public subnets"
}

variable "priv_cidr_subnet" {
  type        = list(string)
  description = "cidr blocks for the private subnets"
}
```

tfvars/dev.tf contains values for attributes given in variables.tf
```
# Subnet
subnet_azs         = ["us-east-1a", "us-east-1b","us-east-1c"  ]
pub_cidr_subnet  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24" ]
priv_cidr_subnet = ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]
```

Public subnet resource block
```
# Public Subnets
resource "aws_subnet" "public_subnet_" {
  count             = length(var.subnet_azs)
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = element(var.pub_cidr_subnet, count.index)
  availability_zone = element(var.subnet_azs, count.index)
  tags = merge(
    local.common_tags,
    {
      Name = "${var.env}_pub_sub_${count.index}"
    }
  )
}
```

Public Subnet Association
```
# Public Route Table Association
resource "aws_route_table_association" "pub_subnets" {
  count = length(var.subnet_azs)

  subnet_id      = element(aws_subnet.public_subnet_.*.id, count.index)
  route_table_id = element(aws_route_table.pub_rtb.*.id, count.index)
}
```

Also outputs.tf file is added in this case, which will output subnets ids and cidr blocks, and vpc id.
```
output "vpc_id" {
  value = aws_vpc.my_vpc.id
}
output "public_subnets" {
  value = aws_subnet.public_subnet_[*].*.id
}
output "private_subnets" {
  value = aws_subnet.private_subnet_[*].*.id
}
output "public_subnets_cidr" {
  value = aws_subnet.public_subnet_[*].*.id
}
output "private_subnets_cidr" {
  value = aws_subnet.private_subnet_[*].*.id
}
```

3. Version ```vpc_v_1.3``` with [for_each meta-argument](https://www.terraform.io/docs/language/meta-arguments/for_each.html).

In this template we used ```for_each``` meta-argument with ```locals``` and for tags we used ```merge``` function, using hepls us to create  three subnets and and three route table association with one resource block. In our case we are working with "map" value, 
although "for_each" can work with "string" value as well as with "map" value. We are passing
separate settings for each subnet, while using the keys/values for generating subnets.

locals.tf
```
locals {
  public_subnet = {
    1 = { availability_zone = "us-east-1a", cidr_block = "10.0.1.0/24" },
    2 = { availability_zone = "us-east-1b", cidr_block = "10.0.2.0/24" },
    3 = { availability_zone = "us-east-1c", cidr_block = "10.0.3.0/24" }
  }
}
```
vpc.tf public subnet
```
# Public Subnets

resource "aws_subnet" "public_subnet_" {
  for_each          = local.public_subnet
  vpc_id            = aws_vpc.my_vpc.id
  availability_zone = each.value.availability_zone
  cidr_block        = each.value.cidr_block
  tags = merge(
    local.common_tags,
    {
      Name = "${var.env}_pub_sub_${each.key}"
    }
  )
}
```
vpc.tf public route table association
```
# Public Route Table Association

resource "aws_route_table_association" "pub_subnet" {
  for_each       = local.public_subnet
  subnet_id      = aws_subnet.public_subnet_[each.key].id
  route_table_id = aws_route_table.pub_rtb.id
}
```