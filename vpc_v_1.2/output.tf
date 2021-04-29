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