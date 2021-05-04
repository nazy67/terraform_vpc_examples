output "vpc_id" {
  value = aws_vpc.my_vpc.id
}
output "public_subnet_ids" {
  value = aws_subnet.public_subnet[*].id
}
output "private_subnets_ids" {
  value = aws_subnet.private_subnet[*].id
}