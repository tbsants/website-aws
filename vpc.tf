resource "aws_vpc" "this" {
  cidr_block           = "192.168.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = "true"
  enable_dns_support   = "true"

  tags = {
    Name = "vpc-terraform-website"
  }
}

resource "aws_subnet" "subnet-priv1" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = "192.168.10.0/24"
  availability_zone = var.az_1a

  tags = {
    Name = "subnet-privada1-website"
  }
}

resource "aws_subnet" "subnet-priv2" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = "192.168.20.0/24"
  availability_zone = var.az_1b

  tags = {
    Name = "subnet-privada2-website"
  }
}

resource "aws_subnet" "subnet-pub1" {
  vpc_id     = aws_vpc.this.id
  cidr_block = "192.168.50.0/24"

  tags = {
    Name = "subnet-publica-website"
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "igw-terraform-website"
  }
}

resource "aws_eip" "nat_gateway_eip" {
  domain = "vpc"
  tags = {
    Name = "eip_igw_website"
  }
}

resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.nat_gateway_eip.id
  subnet_id     = aws_subnet.subnet-pub1.id
  depends_on    = [aws_internet_gateway.this]
  tags = {
    Name = "nat-gateway-terraform-website"
  }
}

resource "aws_route_table" "rtb-priv" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = var.cidr_block
    gateway_id = aws_nat_gateway.this.id
  }

  tags = {
    Name = "rtb-privada-terraform-website"
  }
}

resource "aws_route_table_association" "rtb-assoc-priv1" {
  subnet_id      = aws_subnet.subnet-priv1.id
  route_table_id = aws_route_table.rtb-priv.id
}

resource "aws_route_table_association" "rtb-assoc-priv2" {
  subnet_id      = aws_subnet.subnet-priv2.id
  route_table_id = aws_route_table.rtb-priv.id
}


resource "aws_route_table" "rtb-pub" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = var.cidr_block
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name = "rtb-publica-terraform-website"
  }
}

resource "aws_route_table_association" "this" {
  subnet_id      = aws_subnet.subnet-pub1.id
  route_table_id = aws_route_table.rtb-pub.id
}

resource "aws_vpc_endpoint" "ec2" {
  vpc_id            = aws_vpc.this.id
  service_name      = "com.amazonaws.${var.region}.ec2"
  vpc_endpoint_type = "Interface"

  security_group_ids = [
    aws_security_group.sg_endpoint.id,
  ]
  private_dns_enabled = true
  tags = {
    Name = "ec2"
  }
  subnet_ids = [
    aws_subnet.subnet-priv1.id, aws_subnet.subnet-priv2.id
  ]
}

resource "aws_vpc_endpoint" "ssm" {
  vpc_id            = aws_vpc.this.id
  service_name      = "com.amazonaws.${var.region}.ssm"
  vpc_endpoint_type = "Interface"

  security_group_ids = [
    aws_security_group.sg_endpoint.id,
  ]
  private_dns_enabled = true
  tags = {
    Name = "ssm"
  }
  subnet_ids = [
    aws_subnet.subnet-priv1.id, aws_subnet.subnet-priv2.id
  ]
}

resource "aws_vpc_endpoint" "ssm-messages" {
  vpc_id            = aws_vpc.this.id
  service_name      = "com.amazonaws.${var.region}.ssmmessages"
  vpc_endpoint_type = "Interface"

  security_group_ids = [
    aws_security_group.sg_endpoint.id,
  ]
  private_dns_enabled = true
  tags = {
    Name = "ssm-messages"
  }

  subnet_ids = [
    aws_subnet.subnet-priv1.id, aws_subnet.subnet-priv2.id
  ]
}