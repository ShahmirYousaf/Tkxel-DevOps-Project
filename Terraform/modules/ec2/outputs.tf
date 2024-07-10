output "instance_id" {
  description = "The ID of the EC2 instance"
  value       = aws_instance.Proj_Shahmir_Ec2_Instance.id
}

output "public_ip" {
  description = "The public IP of the EC2 instance"
  value       = aws_instance.Proj_Shahmir_Ec2_Instance.public_ip
}

output "ec2_instance_public_dns" {
  description = "The public DNS of the EC2 instance"
  value       = aws_instance.Proj_Shahmir_Ec2_Instance.public_dns
}
