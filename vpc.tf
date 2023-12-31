resource "aws_vpc" "dns_alb_vpc" {
  cidr_block = "172.16.0.0/16"
}

resource "aws_internet_gateway" "dns_alb_gw" {
  vpc_id = aws_vpc.dns_alb_vpc.id

  tags = {
    Name = "dns-alb-igw"
  }
}

resource "aws_subnet" "subnet_aza" {
  vpc_id            = aws_vpc.dns_alb_vpc.id
  cidr_block        = "172.16.10.0/24"
  availability_zone = "eu-west-2a"
}

resource "aws_subnet" "subnet_azb" {
  vpc_id            = aws_vpc.dns_alb_vpc.id
  cidr_block        = "172.16.11.0/24"
  availability_zone = "eu-west-2b"
}

resource "aws_route_table" "dns_alb_route_table" {
  vpc_id = aws_vpc.dns_alb_vpc.id
}

resource "aws_route" "dns_alb_route" {
  route_table_id         = aws_route_table.dns_alb_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.dns_alb_gw.id
}

resource "aws_route_table_association" "public_subnet_association_a" {
  subnet_id      = aws_subnet.subnet_aza.id
  route_table_id = aws_route_table.dns_alb_route_table.id
}

resource "aws_route_table_association" "public_subnet_association_b" {
  subnet_id      = aws_subnet.subnet_azb.id
  route_table_id = aws_route_table.dns_alb_route_table.id
}