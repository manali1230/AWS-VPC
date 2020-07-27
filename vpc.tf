//variable created to store the region
variable "region" {
  default = "ap-south-1"
}

//provider and profile
provider "aws" {
  region	= var.region
  profile	= "mymanali"
}

resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_hostnames = true
  tags = {
    Name = "Main VPC"
  }
}

resource "aws_subnet" "subnet1" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "10.0.1.0/24"
  availability_zone= "ap-south-1a"
  map_public_ip_on_launch = "true"
  tags = {
    Name = "Subnet1"
  }
depends_on = [
   aws_vpc.main
  ]
}
resource "aws_subnet" "subnet2" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "10.0.2.0/24"
  availability_zone= "ap-south-1a"
  map_public_ip_on_launch = "false"
  tags = {
    Name = "Subnet2"
  }
depends_on = [
   aws_vpc.main
  ]
}
resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.main.id}"

  tags = {
    Name = "internet_gateway"
  }
   depends_on = [
    aws_vpc.main
  ]

}

resource "aws_route_table" "r" {
  vpc_id = "${aws_vpc.main.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name = "route_table"
  }
depends_on = [
   aws_internet_gateway.gw
  ]
}

resource "aws_route_table_association" "addsubnet1" {
  subnet_id      = aws_subnet.subnet1.id
  route_table_id = aws_route_table.r.id
  depends_on = [
    aws_route_table.r
  ]
}

resource "aws_main_route_table_association" "subnetmain1" {
  vpc_id         = aws_vpc.main.id
  route_table_id = aws_route_table.r.id
  depends_on = [
    aws_route_table_association.addsubnet1
  ]
}

