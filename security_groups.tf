resource "aws_security_group" "server_security_group" {
  name_prefix = "wssec-group"
  description = "security group for ec2"
  vpc_id      = aws_vpc.dns_alb_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = local.tcp_protocol
    cidr_blocks = local.all_ips
  }

  ingress {
    from_port = local.http_port
    to_port   = local.http_port
    protocol  = local.tcp_protocol
    # cidr_blocks = local.all_ips
    security_groups = [aws_security_group.lb_sg.id]
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

resource "aws_security_group" "lb_sg" {
  name_prefix = "alb_sg_"
  vpc_id      = aws_vpc.dns_alb_vpc.id
  description = "security group for alb"

  # ingress {
  #   from_port   = local.ssh_port
  #   to_port     = local.ssh_port
  #   protocol    = local.tcp_protocol
  #   cidr_blocks = local.all_ips
  # }

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
    Name = "alb-security-group"
  }
}