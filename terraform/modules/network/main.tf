# 1. VPC Creation
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = { Name = "CloudDevOps-VPC" }
}

# 2. Public Subnet Creation
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.vpc_cidr
  map_public_ip_on_launch = true
  tags = { Name = "Public-Subnet" }
}

# 3. Internet Gateway Creation
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = { Name = "Main-IGW" }
}

# 4. Network ACL 
resource "aws_network_acl" "main" {
  vpc_id = aws_vpc.main.id
  subnet_ids = [aws_subnet.public.id]

  ingress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
}
# 5. Route Table Creation
resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

# 6. Route Table Association Creation
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.rt.id
}