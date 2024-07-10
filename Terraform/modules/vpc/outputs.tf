output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.Proj_Shahmir_Vpc.id
}

output "subnet_id" {
  description = "The ID of the subnet"
  value       = aws_subnet.Proj_Shahmir_Subnet.id
}
