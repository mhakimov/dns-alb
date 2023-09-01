provider "aws" {
  region = "eu-west-2"  
}

locals {
  ssh_port = 22
  http_port = 80
  https_port = 443
  any_port = 0
  all_ips      = ["0.0.0.0/0"]
  tcp_protocol = "tcp"
}

resource "aws_instance" "server_instance" {
  count = var.instance_count
  ami           = "ami-0055e70f580e9ae80"  
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.server_security_group.id]
  subnet_id = aws_subnet.subnet_aza.id
  key_name = aws_key_pair.example_keypair.key_name  
  associate_public_ip_address = true
  tags = {
    Name = "web-server-${count.index}"
  }
}

resource "aws_key_pair" "example_keypair" {
  key_name   = "my-keypair" 
  public_key = file("~/.ssh/id_rsa.pub")  
}

resource "aws_lb" "wu-tang" {
  name               = "alb-wu-tang"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = [aws_subnet.subnet_aza.id, aws_subnet.subnet_azb.id]
}

resource "aws_lb_target_group" "ec2_target_group" {
  name     = "cool-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.dns_alb_vpc.id 
  
  health_check {
    path = "/"
  }
}

resource "aws_lb_target_group_attachment" "ec2_attachment" {
  count          = var.instance_count
  target_group_arn = aws_lb_target_group.ec2_target_group.arn
  target_id      = aws_instance.server_instance[count.index].id
  # target_id      = aws_instance.server_instance[*].id
  port           = 80
}

resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.wu-tang.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.ec2_target_group.arn
    type             = "forward"
  }
}




output "instance_ip" {
  value = aws_instance.server_instance[*].public_ip
}