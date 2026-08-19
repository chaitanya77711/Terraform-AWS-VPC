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