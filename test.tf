variable "vpc_config" {
default = {
cidr_block = "10.0.0.0/16"
subnets = ["10.0.1.0/24","10.0.2.0/24"]
tags = {
Environment = "Dev" , Team = "Devops"}
}
}
locals {
  
}
resource "aws_security_group" "my_sG" {
  
}


resource "aws_vpc" "myvpc" {
    cidr_block = var.vpc_config.cidr_block
    enable_dns_hostnames = false
    enable_dns_support = true
    tags = merge({Name="myTerraform-vpc"},var.vpc_config.tags)
}

resource "aws_subnet" "public-sbn" {
    for_each = var.vpc_config.subnets
    vpc_id = aws_vpc.myvpc.id
    cidr_block = each.value
    map_public_ip_on_launch = true
    tags = merge({Name="public_sbn-${each.value}"},var.vpc_config.tags)
}


resource "aws_internet_gateway" "my-igw" {
    vpc_id = aws_vpc.myvpc.id
    tags = {
      Name = "myvpc_igw"
    }
}

resource "aws_route_table" "main" {
vpc_id = aws_vpc.myvpc.id
tags = {
  Name="myvpc_route"
}
}

resource "aws_route" "intenet_access" {
  route_table_id = aws_route_table.main.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.my-igw.id
}

# resource "aws_route_table_association" "subnet1_association" {
#   subnet_id = aws_subnet.public-sbn.id
#   route_table_id = aws_route_table.main.id
# }
resource "aws_route_table_association" "subnet1_association" {
  for_each = aws_subnet.public-sbn
  subnet_id = each.value.id
  route_table_id = aws_route_table.main.id
}

output "vpc_id" {
    value = aws_vpc.myvpc.id
  
}
output "subnet_id" {
    value = [for subnet in aws_subnet.public-sbn: subnet.id]
}