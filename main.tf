resource "aws_vpc" "main" {
  cidr_block       = var.cidr_block
  instance_tenancy = "default"
  enable_dns_hostnames = true

  tags = local.vpc-final-tags
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = local.igw-final-tags
}

#public subnets
resource "aws_subnet" "public" {
  count = length(var.public-subnet-cidrs)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public-subnet-cidrs[count.index]
  availability_zone = local.zone-names[count.index]
  map_public_ip_on_launch = true

  tags = merge(
    local.common-tags,
    {
      Name = "${var.project}-${var.environment}-public-${local.zone-names[count.index]}"
    },
     var.public-subnet-tags
  )
}

#private
resource "aws_subnet" "private" {
  count = length(var.private-subnet-cidrs)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private-subnet-cidrs[count.index]
  availability_zone = local.zone-names[count.index]
  map_public_ip_on_launch = false

  tags = merge(
    local.common-tags,
    {
      Name = "${var.project}-${var.environment}-private-${local.zone-names[count.index]}"
    },
    var.private-subnet-tags
  )
}

#database
resource "aws_subnet" "data-base" {
  count = length(var.data-base-subnet-cidrs)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.data-base-subnet-cidrs[count.index]
  availability_zone = local.zone-names[count.index]
  map_public_ip_on_launch = false

  tags = merge(
    local.common-tags,
    {
      Name = "${var.project}-${var.environment}-data-base-${local.zone-names[count.index]}"
    },
    var.data-base-subnet-tags
  ) 
} 

#route-table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags =  merge(
    local.common-tags,
    {
      Name = "${var.project}-${var.environment}-public"
    },
    var.public-route-table-tags
  )  
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags =  merge(
    local.common-tags,
    {
      Name = "${var.project}-${var.environment}-private"
    },
    var.private-route-table-tags
  )  
}

resource "aws_route_table" "data-base" {
  vpc_id = aws_vpc.main.id

  tags =  merge(
    local.common-tags,
    {
      Name = "${var.project}-${var.environment}-data-base"
    },
    var.data-base-route-table-tags
  )  
}

#nat route

resource "aws_route" "public" {
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = var.destination_cidr_block
  nat_gateway_id = aws_nat_gateway.main.id
}

#elastic ip

resource "aws_eip" "nat" {
  domain   = "vpc"

tags =  merge(
    local.common-tags,
    {
      Name = "${var.project}-${var.environment}-nat"
    },
    var.eip_tags
  )    
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id

  tags = {
    Name =  merge(
    local.common-tags,
    {
      Name = "${var.project}-${var.environment}"
    },
    var.nat_gateway-tags
  )    
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.main]
}

resource "aws_route" "private" {
  route_table_id            = aws_route_table.private.id
  destination_cidr_block    = var.destination_cidr_block
  nat_gateway_id = aws_nat_gateway.main.id
}

resource "aws_route" "data-base" {
  route_table_id            = aws_route_table.data-base.id
  destination_cidr_block    = var.destination_cidr_block
  nat_gateway_id = aws_nat_gateway.main.id
}