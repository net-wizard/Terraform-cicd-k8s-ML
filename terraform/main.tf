resource "aws_vpc" "retailrec_vpc" {
  cidr_block = var.vpc_cidr
  tags       = merge(var.common_tags, { Name = "retailrec_vpc" })

}
resource "aws_subnet" "retailrec_subnet_public_a" {
  vpc_id            = aws_vpc.retailrec_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-south-1a"
  tags              = merge(var.common_tags, { Name = "retailrec_subnet_public_a" })
}
resource "aws_subnet" "retailrec_subnet_public_b" {
  vpc_id            = aws_vpc.retailrec_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "ap-south-1b"
  tags              = merge(var.common_tags, { Name = "retailrec_subnet_public_b" })
}
resource "aws_internet_gateway" "retailrec_ig" {
  vpc_id = aws_vpc.retailrec_vpc.id
  tags   = merge(var.common_tags, { Name = "retailrec_ig" })

}
resource "aws_route_table" "retailrec_rt" {
  vpc_id = aws_vpc.retailrec_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.retailrec_ig.id
  }
  tags = merge(var.common_tags, { Name = "retailrec_rt" })
}
resource "aws_route_table_association" "retailrec_rt_asc_subnet_a" {
  subnet_id      = aws_subnet.retailrec_subnet_public_a.id
  route_table_id = aws_route_table.retailrec_rt.id
}
resource "aws_route_table_association" "retailrec_rt_asc_subnet_b" {
  subnet_id      = aws_subnet.retailrec_subnet_public_b.id
  route_table_id = aws_route_table.retailrec_rt.id
}