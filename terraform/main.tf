terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

resource "aws_vpc" "wp_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "wp_vpc"
  }
}

resource "aws_internet_gateway" "vpc_ig" {
  vpc_id = aws_vpc.wp_vpc.id

  tags = {
    Name = "vpc_ig"
  }
}


resource "aws_subnet" "vpc_subenet" {
  vpc_id = aws_vpc.wp_vpc.id
  cidr_block = "10.0.0.1/24"
  map_public_ip_on_launch = true
  availability_zone = "ap-south-1a"

  tags = {
    Name = "vpc_subnet"
  }
}

resource "aws_route_table" "vpc_rt" {
  vpc_id = aws_vpc.wp_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc_ig.id
  } 
    tags = {
      Name = "vpc_rt"
    }
}

resource "aws_route_table_association" "rt_asso" {
  subnet_id = aws_subnet.vpc_subenet.id
  route_table_id = aws_route_table.vpc_rt.id
}


resource "aws_instance" "wp_ec2" {
  ami = "ami-06984ea821ac0a879"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.vpc_subenet.id
  key_name = "jay-tf"
  security_groups = [aws_security_group.wp_ec2_SG.id]


  tags = {
    Name = "wp_ec2"
  }
  #user_data = file("fulcrum.sh") 
  user_data = "${file("docker.sh")}"
}

resource "aws_security_group" "wp_ec2_SG" {
  name = "allow ssh"
  vpc_id = aws_vpc.wp_vpc.id

  ingress  {
    cidr_blocks = [ "0.0.0.0/0" ]
    description = "SSH from VPC"
    from_port = 22
    protocol = "tcp"
    to_port = 22
  } 

  ingress   {
    cidr_blocks = [ "0.0.0.0/0" ]
    description = "HTTP from VPC"
    from_port = 80
    protocol = "tcp"
    to_port = 80
  } 
  egress {
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = [ "0.0.0.0/0" ]
  }

   tags = {
      Name = "allow ssh http"
   }

}

output "ec2_ip" {
  value = aws_instance.wp_ec2.public_ip
}