variable "ami" {
  description = "The AMI to use for the instance"
}

variable "instance_type" {
  description = "The type of instance to create"
}

variable "subnet_id" {
  description = "The subnet ID to launch the instance in"
}

# variable "public_key_path" {
#   description = "The path to your public key for SSH access"
# }

variable "vpc_id" {
  description = "The ID of the VPC"
}

# variable "private_key_path" {
#   description = "The path to your private key for SSH access"
# }