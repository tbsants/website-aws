resource "aws_security_group" "sg_elb" {
  name        = "prd-elb-terraform"
  description = "security group for website elb"
  vpc_id      = aws_vpc.this.id

  ingress {
    description = "Allow access to 80 port"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.cidr_block]
  }

  ingress {
    description = "Allow access to 443 port"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.cidr_block]
  }

  egress {
    description = ""
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.cidr_block]
  }

  tags = {
    Name = "prd-elb-terraform"
    #ManagedBy = "Terraform"
  }
}

resource "aws_security_group" "sg_srv" {
  name        = "prd-servers-terraform"
  description = "security group for website servers"
  vpc_id      = aws_vpc.this.id

  # ingress {
  #   description = "Allow access to 443 port"
  #   from_port   = 443
  #   to_port     = 443
  #   protocol    = "tcp"
  #   cidr_blocks = [var.cidr_block]
  # }

  # ingress {
  #   description = "Allow access to 80 port"
  #   from_port   = 80
  #   to_port     = 80
  #   protocol    = "tcp"
  #   cidr_blocks = [var.cidr_block]
  # }

  # ingress {
  #   description = "Allow access to 22 port"
  #   from_port   = 22
  #   to_port     = 22
  #   protocol    = "tcp"
  #   cidr_blocks = [var.cidr_block]
  # }

  egress {
    description = ""
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.cidr_block]
  }

  tags = {
    Name = "prd-servers-terraform"
  }
}

resource "aws_security_group_rule" "allow_elb_to_srv" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.sg_srv.id
  source_security_group_id = aws_security_group.sg_elb.id
  description              = "Allow ELB to access port 80 on server SG"
}

resource "aws_security_group_rule" "allow_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = [var.cidr_block]
  security_group_id = aws_security_group.sg_srv.id
  description       = "Allow access to 443 port"
}

resource "aws_security_group_rule" "allow_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = [var.cidr_block]
  security_group_id = aws_security_group.sg_srv.id
  description       = "Allow access to 22 port"
}

resource "aws_security_group" "sg_endpoint" {
  name        = "prd-endpoint-terraform"
  description = "security group for vpc endpoints"
  vpc_id      = aws_vpc.this.id

  ingress {
    description = "Allow access to 443 port"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.cidr_block]
  }

  egress {
    description = ""
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.cidr_block]
  }

  tags = {
    Name = "prd-endpoint-terraform"
  }
}