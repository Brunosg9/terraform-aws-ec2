## INSTACIA EC2 NA REGIAL OREGEON
resource "aws_instance" "web_instance" {
  ami           = "ami-0efcece6bed30fd98"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.terraform_sg.id]
  key_name = "TF_key"

  tags = {
    Name = "Terraform-ec2"
  }
# DATA SCRIPT
  user_data = file("script.sh")

}

# DATA SCRIPT


## SSH KEY PAIR AWS REGION OREGON
resource "aws_key_pair" "TF_key" {
  key_name   = "TF_key"
  public_key = tls_private_key.rsa.public_key_openssh
}

## CRIAÇÃO SSH KEY
resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

## CRIAR A CHAVE NO LOCAL
resource "local_file" "TF-key" {
  content  = tls_private_key.rsa.private_key_pem
  filename = "tfkey"
}

# SECURITY GROUP
resource "aws_security_group" "terraform_sg" {
  name        = "terraform_sg"
  description = "terraform_sg"
  vpc_id      = "vpc-05f70c4f4cfba3b0c"

  ingress {
    description      = "HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

    ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

    ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]

  }


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "terraform_sg"
  }
}