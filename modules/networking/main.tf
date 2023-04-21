#Public Subnets
resource "aws_subnet" "public-subnet" {
  count                   = var.local_count
  vpc_id                  = var.vpc_id
  cidr_block              = cidrsubnet(var.vpc_cidr_block, 8, sum([50,"${count.index}"]))
  map_public_ip_on_launch = "true"
  availability_zone       = var.azs[count.index]
  
  tags = var.tags
  
}

resource "aws_internet_gateway" "igw" {
  vpc_id = var.vpc_id

  tags = var.tags
}


#Public Route Table For WebServers Instance1 in AZ1
resource "aws_route_table" "public-route-table" {
  vpc_id = var.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = var.tags
}

#Route Association with All Public Subnets
resource "aws_route_table_association" "Public-route-association" {
  count          = var.local_count
  subnet_id      = aws_subnet.public-subnet["${count.index}"].id
  route_table_id = aws_route_table.public-route-table.id
}

#Security Group for LoadBalancer
resource "aws_security_group" "nlb_sg" {
  name        = var.nlb_sg_name
  description = "Allow incoming HTTP connections"
  vpc_id      = var.vpc_id

  ingress {
    from_port        = 80
    protocol         = "tcp"
    to_port          = 80
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags

}

##Security Groups for Public Subnets Resources
resource "aws_security_group" "asg_sg" {
  name        = var.asg_sg_name
  description = "Allow access to App"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
  }

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

##Lambda Sg
resource "aws_security_group" "lambda_sg" {
  name          = var.lambda_security_group_name
  description   = "Allow traffic from VPC"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = [var.vpc_cidr_block]
  }

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "udp"
    cidr_blocks = [var.vpc_cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

#Security Group for RDS
resource "aws_security_group" "db_sg" {
  name          = var.rds_sg_name
  description   = "Allow traffic from VPC"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#Security Group for Batch Instance
resource "aws_security_group" "batch_sg" {
  name          = var.batch_instance_sg_name
  description   = "Allow traffic from VPC"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
  }

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_vpc_endpoint" "ssm_lambda_endpoint" {
  vpc_id             = var.vpc_id
  service_name       = "com.amazonaws.${var.region}.ssm"
  vpc_endpoint_type  = "Interface"
  auto_accept        = true 
  subnet_ids         = [aws_subnet.public-subnet[0].id,aws_subnet.public-subnet[1].id,aws_subnet.public-subnet[2].id]
  security_group_ids = [
    aws_security_group.lambda_sg.id,
  ]

  private_dns_enabled = true
}