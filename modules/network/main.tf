data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "${terraform.workspace}-vpc"
  }
}

resource "aws_subnet" "main" {
  vpc_id                  = aws_vpc.vpc.id
  for_each                = var.subnets
  cidr_block              = cidrsubnet(var.vpc_cidr, 4, index(keys(var.subnets), each.key))
  availability_zone       = data.aws_availability_zones.available.names[each.value.az]
  map_public_ip_on_launch = each.value.public_ip
  tags = {
    Name = "${terraform.workspace}-${each.key}"
  }
}