#### Public Subnets

# Public Subnet on ap-southeast-1a
resource "aws_subnet" "public_subnet_ap-southeast_1a" {
  vpc_id                  = aws_vpc.cluster_vpc.id
  cidr_block              = "10.0.0.0/20"
  map_public_ip_on_launch = true
  availability_zone       = "ap-southeast-1a"

  tags = {
    Name = format("%s-public-subnet-1a", var.cluster_name)
  }
}

# Public Subnet on ap-southeast-1b
resource "aws_subnet" "public_subnet_ap-southeast_1b" {
  vpc_id                  = aws_vpc.cluster_vpc.id
  cidr_block              = "10.0.16.0/20"
  map_public_ip_on_launch = true
  availability_zone       = "ap-southeast-1b"

  tags = {
    Name = format("%s-public-subnet-1b", var.cluster_name)
  }
}

# Public Subnet on ap-southeast-1c
resource "aws_subnet" "public_subnet_ap-southeast_1c" {
  vpc_id                  = aws_vpc.cluster_vpc.id
  cidr_block              = "10.0.32.0/20"
  map_public_ip_on_launch = true
  availability_zone       = "ap-southeast-1c"

  tags = {
    Name = format("%s-public-subnet-1c", var.cluster_name)
  }
}

# Associate subnet public_subnet_ap-southeast_1a to public route table
resource "aws_route_table_association" "public_subnet_ap-southeast_1a_association" {
  subnet_id      = aws_subnet.public_subnet_ap-southeast_1a.id
  route_table_id = aws_vpc.cluster_vpc.main_route_table_id
}

# Associate subnet public_subnet_ap-southeast_1b to public route table
resource "aws_route_table_association" "public_subnet_ap-southeast_1b_association" {
  subnet_id      = aws_subnet.public_subnet_ap-southeast_1b.id
  route_table_id = aws_vpc.cluster_vpc.main_route_table_id
}

# Associate subnet public_subnet_ap-southeast_1b to public route table
resource "aws_route_table_association" "public_subnet_ap-southeast_1c_association" {
  subnet_id      = aws_subnet.public_subnet_ap-southeast_1c.id
  route_table_id = aws_vpc.cluster_vpc.main_route_table_id
}
