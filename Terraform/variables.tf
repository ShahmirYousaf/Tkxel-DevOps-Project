variable "region" {
  description = "The AWS region to create resources in"
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "The CIDR block for the subnet"
  default     = "10.0.1.0/24"
}

variable "instance_type" {
  description = "The type of instance we need to create"
  default     = "t2.micro"
}

variable "ami" {
  description = "The AMI to use for the instance"
  default     = "ami-04a81a99f5ec58529"
}



# variable "public_key_path" {
#   description = "The path to your public key for SSH access"
#   default     = "~/.ssh/id_rsa.pub"
# }

# variable "private_key_path" {
#   description = "The path to your private key for SSH access"
#   default = "~/.ssh/id_rsa"
# }

# variable "ACCESS_KEY" {
#   description = "AWS access key"
#   type        = string
#   sensitive   = true
# }

# variable "SECRET_KEY" {
#   description = "AWS secret key"
#   type        = string
#   sensitive   = true
# }
