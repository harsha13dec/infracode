#AWS SERVICE CREDENTIALS
provider "aws" {
  region = "ap-south-1"
}

# Declare the data source
data "aws_availability_zones" "available" {
  state = "available"
}

# Name of the Resource

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

#Create VPC
resource "aws_vpc" "Tesla" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "Tesla"
  }
}

# Internet Gateway

resource "aws_internet_gateway" "Tesla-igw" {
  vpc_id = aws_vpc.Tesla.id

  tags = {
    Name = "Tesla-igw"
  }
}

#Public Subnet

resource "aws_subnet" "Tesla-pub-subnet" {
  vpc_id     = aws_vpc.Tesla.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "Tesla-pub"
  }
}

#Private Subnet

resource "aws_subnet" "Tesla-pvt-subnet" {
  vpc_id            = aws_vpc.Tesla.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "ap-south-1b"
  tags = {
    Name = "Tesla-pvt"
  }
}

#Public Route Table
resource "aws_route_table" "Tesla-pbrt" {
  vpc_id = aws_vpc.Tesla.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Tesla-igw.id
  }

  tags = {
    Name = "Tesla-pbrt"
  }
}

# PRIVATE ROUTE TABLE
resource "aws_route_table" "Tesla-pvrt" {
  vpc_id = aws_vpc.Tesla.id

  tags = {
    Name = "Tesla-pvrt"
  }
}

# PUBLIC ASSOCIATION
resource "aws_route_table_association" "Teslapubasn" {
  subnet_id      = aws_subnet.Tesla-pub-subnet.id
  route_table_id = aws_route_table.Tesla-pbrt.id
}

# PRIVATE ASSOCIATION
resource "aws_route_table_association" "Teslapvtbasn" {
  subnet_id      = aws_subnet.Tesla-pvt-subnet.id
  route_table_id = aws_route_table.Tesla-pvrt.id
}
