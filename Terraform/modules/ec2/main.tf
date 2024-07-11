resource "aws_security_group" "Proj_Shahmir_instance_sg" {
  vpc_id = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Proj_Shahmir_instance_sg"
  }
}

resource "aws_security_group" "Proj_Shahmir_allow_http" {
  name = "allow_http"
  description = "Allow HTTP traffic"
  vpc_id = var.vpc_id
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }
}

resource "tls_private_key" "rsa_4096" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "private_key" {
  content  = tls_private_key.rsa_4096.private_key_pem
  filename = "terraform-key.pem" 
  provisioner "local-exec" {
    command = "chmod 400 terraform-key.pem"  # Secure the private key file
  }
}

resource "aws_key_pair" "key_pair" {
  key_name   = "terraform-key"
  public_key = tls_private_key.rsa_4096.public_key_openssh
}

# resource "aws_key_pair" "Proj_Shahmir_deployer_key" {
#   key_name   = "id_rsa"
#   public_key = file(var.public_key_path)
# }

# resource "local_file" "ansible_inventory" {
#   filename = "../ansible/inventory.ini"
#   content = <<EOT
# [ubuntu_servers]
# #ubuntu_server ansible_host = ${aws_eip.Proj_Shahmir_Ec2_EIP.public_ip}

# [ubuntu_servers:vars]
# ansible_user = ubuntu
# ansible_ssh_private_key_file =~/.ssh/id_rsa
# EOT

  
# }

resource "aws_instance" "Proj_Shahmir_Ec2_Instance" {
  ami               = var.ami
  instance_type     = var.instance_type
  subnet_id         = var.subnet_id
  key_name          = aws_key_pair.key_pair.key_name
  associate_public_ip_address = true
  security_groups = [
    aws_security_group.Proj_Shahmir_instance_sg.id,
    aws_security_group.Proj_Shahmir_allow_http.id
    ] 

  root_block_device {
    volume_type = "gp2"
    volume_size = 8
  }

  tags = {
    Name = "Proj_Shahmir_Ec2_Instance"
  }

  provisioner "local-exec" {
    command = "cd ../ansible && touch dynamic_inventory.ini"
  }


   provisioner "remote-exec" {
      inline = [
        "echo 'EC2 instance is ready.'"
      ]
      connection {
        type        = "ssh"
        host        = aws_instance.Proj_Shahmir_Ec2_Instance.public_ip
        user        = "ubuntu"
        private_key = tls_private_key.rsa_4096.private_key_pem
      }
  }
 
}

data "template_file" "inventory" {
  template = <<-EOT
  [ec2_instances]
  ${aws_instance.Proj_Shahmir_Ec2_Instance.public_ip} ansible_user=ubuntu ansible_ssh_private_key_file=terraform-key.pem
  EOT
}

resource "local_file" "dynamic_inventory" {
  depends_on = [aws_instance.Proj_Shahmir_Ec2_Instance]

  filename = "../ansible/dynamic_inventory.ini"
  content = data.template_file.inventory.rendered

  provisioner "local-exec" {
    command = "chmod 400 ${local_file.dynamic_inventory.filename}"
  }
}

resource "null_resource" "run_ansible" {
  depends_on = [ local_file.dynamic_inventory ]

  provisioner "local-exec" {
     command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ../ansible/dynamic_inventory.ini ../ansible/playbook.yml -- "
     
   }
  
}

# resource "aws_eip" "Proj_Shahmir_Ec2_EIP" {
#   instance = aws_instance.Proj_Shahmir_Ec2_Instance.id
#   vpc      = true
# }

# resource "aws_eip_association" "Proj_Shahmir_Ec2_EIP_assoc" {
#   instance_id    = aws_instance.Proj_Shahmir_Ec2_Instance.id
#   allocation_id  = aws_eip.Proj_Shahmir_Ec2_EIP.id
# }
