# create a VPC
resource "aws_vpc" "blog-vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "blog_vpc"
  }
}

# create public subnet

resource "aws_subnet" "blog-public-subnet" {
  cidr_block        = "10.0.0.0/24"
  vpc_id            = "${aws_vpc.blog-vpc.id}"
  availability_zone = "us-west-1b"

  tags = {
    Name = "blog_subnet_public"
  }
}

# create private subnet
resource "aws_subnet" "blog-private-subnet" {
  cidr_block        = "10.0.1.0/24"
  vpc_id            = "${aws_vpc.blog-vpc.id}"
  availability_zone = "us-west-1b"

  tags = {
    Name = "blog_subnet_private"
  }
}

# provision internet gateway and attach to VPC
resource "aws_internet_gateway" "blog-gateway" {
  vpc_id = "${aws_vpc.blog-vpc.id}"

  tags = {
    Name = "blog_gateway"
  }
}

# change route table associated with public subnet (1 route table created by default with VPC i think)
#...or create one
resource "aws_route_table" "blog-public-route-table" {
  vpc_id = "${aws_vpc.blog-vpc.id}"

  # Note that the default route, mapping the VPC's CIDR block to "local", is created implicitly and cannot be specified.

  route {
    # destination
    cidr_block = "0.0.0.0/0"

    # target
    gateway_id = "${aws_internet_gateway.blog-gateway.id}"
  }
  tags = {
    Name = "blog_public_route_table"
  }
}

# associate a subnet with the route table (public subnet in this case)
resource "aws_route_table_association" "route-table-association" {
  subnet_id      = "${aws_subnet.blog-public-subnet.id}"
  route_table_id = "${aws_route_table.blog-public-route-table.id}"
}

# set the main route table for VPC
resource "aws_main_route_table_association" "a" {
  vpc_id         = "${aws_vpc.blog-vpc.id}"
  route_table_id = "${aws_route_table.blog-public-route-table.id}"
}

# provision EC2 instance in public subnet (optional, elastic IP)
# use association resources for subnet?
