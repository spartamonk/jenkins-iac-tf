data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "${terraform.workspace}-vpc"
  }
}

resource "aws_subnet" "subnets" {
  vpc_id                  = aws_vpc.vpc.id
  for_each                = var.subnets
  cidr_block              = cidrsubnet(var.vpc_cidr, 4, index(keys(var.subnets), each.key))
  availability_zone       = data.aws_availability_zones.available.names[each.value.az]
  map_public_ip_on_launch = each.value.public_ip
  tags = {
    Name = "${terraform.workspace}-${each.key}"
  }
}

locals {
  has_public_subnet = anytrue(flatten([for _, subnet in var.subnets : subnet[*].public_ip]))
  pubic_subnet_id   = try([for _, subnet in aws_subnet.subnets : subnet.id if subnet.map_public_ip_on_launch][0], null)
  private_subnet_id = try([for _, subnet in aws_subnet.subnets : subnet.id if subnet.map_public_ip_on_launch][0], null)
}


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  count  = local.has_public_subnet ? 1 : 0
  tags = {
    Name = "${terraform.workspace}-igw"
  }
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.vpc.id
  count  = local.has_public_subnet ? 1 : 0
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw[0].id
  }

  tags = {
    Name = "${terraform.workspace}-igw"
  }
}

resource "aws_route_table_association" "rta" {
  count          = local.has_public_subnet ? 1 : 0
  subnet_id      = local.pubic_subnet_id
  route_table_id = aws_route_table.rt[0].id
}