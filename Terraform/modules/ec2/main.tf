resource "aws_security_group" "Proj_Shahmir_instance_sg" {
  vpc_id = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
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

resource "aws_key_pair" "Proj_Shahmir_deployer_key" {
  key_name   = "deployer-key"
  public_key = file(var.public_key_path)
}

resource "aws_instance" "Proj_Shahmir_Ec2_Instance" {
  ami               = var.ami
  instance_type     = var.instance_type
  subnet_id         = var.subnet_id
  key_name          = aws_key_pair.Proj_Shahmir_deployer_key.key_name
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

 
}
