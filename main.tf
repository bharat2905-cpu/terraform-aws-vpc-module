provider "aws" {
  region = "ap-south-1"
}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_config.cidr_block
  tags = {
    Name = var.vpc_config.name
  }
}

resource "aws_subnet" "subnet" {
  vpc_id   = aws_vpc.main.id
  for_each = var.subnet_config  # key={cidr, az} each.key each.value

  cidr_block        = each.value.cidr_block
  availability_zone = each.value.az

  tags = {
    Name = each.key
  }
}

locals {
  public_subnets = {
    # key={} if public is true in subent_config
    for key, config in var.subnet_config : key => config if config.public
  }

  private_subnets = {
    for key, config in var.subnet_config : key => config if !config.public 
  }
}

# Internet Gateway, if there is atleast one public subnet
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  count  = length(local.public_subnets) > 0 ? 1 : 0    # > 0 ? 1 : 0 this is ternary operator
}

# Routing table
resource "aws_route_table" "rtb" {
  vpc_id = aws_vpc.main.id
  count = length(local.public_subnets) > 0 ? 1 : 0
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw[0].id
  }
}

# Route table association 
resource "aws_route_table_association" "arta" {
  for_each = local.public_subnets    # public_subnet={} private_subnet={}

  subnet_id = aws_subnet.subnet[each.key].id
  route_table_id = aws_route_table.rtb[0].id
}