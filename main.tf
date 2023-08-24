provider "aws" {
  region = "eu-west-2"  

locals {
  http_port = 80
  https_port = 443
  any_port = 0
  all_ips      = ["0.0.0.0/0"]
  tcp_protocol = "tcp"
}


resource "aws_instance" "server_instance" {
  ami           = "ami-0055e70f580e9ae80"  
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.server_security_group.id]
  key_name = aws_key_pair.example_keypair.key_name  
  tags = {
    Name = "web_server"
  }
}

resource "aws_key_pair" "example_keypair" {
  key_name   = "my-keypair" 
  public_key = file("~/.ssh/id_rsa.pub")  
}

resource "aws_security_group" "server_security_group" {
  # id          = "example-security-group-id"
  name_prefix = "wssec-group"
  # name_prefix = "example-security-group"
  description = "security group for ec2"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = local.tcp_protocol
    cidr_blocks = local.all_ips
  }

  ingress {
    from_port   = local.http_port
    to_port     = local.http_port
    protocol    = local.tcp_protocol
    cidr_blocks = local.all_ips
  }

  ingress {
    from_port   = local.https_port
    to_port     = local.https_port
    protocol    = local.tcp_protocol
    cidr_blocks = local.all_ips
  }

  egress {
    from_port   = local.any_port
    to_port     = local.any_port
    protocol    = "-1"
    cidr_blocks = local.all_ips
  }

  tags = {
    Name = "webserver-security-group"
  }
}



output "instance_ip" {
  value = aws_instance.server_instance.public_ip
}