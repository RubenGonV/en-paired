# ============================================
# VPC Configuration - 100% FREE Resources
# ============================================
# All resources below are FREE:
# - VPC: Free
# - Subnets: Free
# - Internet Gateway: Free
# - Route Tables: Free
# - Security Groups: Free
# ============================================

# Get available AZs in the region
data "aws_availability_zones" "available" {
  state = "available"
}

# Main VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "en-paired-vpc"
    Project = "en-paired"
  }
}

# Internet Gateway for public subnets
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "en-paired-igw"
    Project = "en-paired"
  }
}

# Public Subnet 1 (AZ 1)
resource "aws_subnet" "public_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "en-paired-public-subnet-1"
    Project = "en-paired"
    Type = "public"
  }
}

# Public Subnet 2 (AZ 2)
resource "aws_subnet" "public_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "en-paired-public-subnet-2"
    Project = "en-paired"
    Type = "public"
  }
}

# Route Table for Public Subnets
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "en-paired-public-rt"
    Project = "en-paired"
  }
}

# Associate Public Subnet 1 with Public Route Table
resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public.id
}

# Associate Public Subnet 2 with Public Route Table
resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public.id
}

# Security Group for Web/Application Servers (Future EC2/ECS)
resource "aws_security_group" "web" {
  name        = "en-paired-web-sg"
  description = "Security group for web/application servers"
  vpc_id      = aws_vpc.main.id

  # Allow HTTP from anywhere (for web traffic)
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow HTTPS from anywhere
  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow FastAPI port (8000) from anywhere
  ingress {
    description = "FastAPI"
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    description = "All outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "en-paired-web-sg"
    Project = "en-paired"
  }
}

# Security Group for Database (Future RDS)
resource "aws_security_group" "database" {
  name        = "en-paired-db-sg"
  description = "Security group for database servers"
  vpc_id      = aws_vpc.main.id

  # Allow PostgreSQL from web security group only
  ingress {
    description     = "PostgreSQL from web servers"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.web.id]
  }

  # No outbound rules needed for database

  tags = {
    Name = "en-paired-db-sg"
    Project = "en-paired"
  }
}

