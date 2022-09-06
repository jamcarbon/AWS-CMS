resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "main"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "igw"
  }
}


# Public subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main.id
  count                   = length(var.public_subnets_cidr)
  cidr_block              = element(var.public_subnets_cidr, count.index)
  availability_zone       = [
    "${var.region}a",
    "${var.region}b",
    "${var.region}c",
  ]
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.project_name}-public-subnet"
  }
}

# Private Subnet
resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.main.id
  count                   = length(var.private_subnets_cidr)
  cidr_block              = element(var.private_subnets_cidr, count.index)
  availability_zone       = [
    "${var.region}a",
    "${var.region}b",
    "${var.region}c",
  ]
  map_public_ip_on_launch = false

  tags = {
    Name        = "${var.project_name}-private-subnet"
  }
}