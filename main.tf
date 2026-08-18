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

# resource "aws_subnet" "public" {
#   count = length(var.public-subnet-cidrs)
#   vpc_id     = aws_vpc.main.id
#   cidr_block = var.public-subnet-cidrs[count.index]


#   tags = {
#     Name = "Main"
#   }
# }