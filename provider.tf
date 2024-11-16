provider "aws" {
  region = var.aws_region
}


resource "aws_instance" "Myinstance" {
  ami= var.ami
  instance_type = var.instance_type
  key_name = var.key_name
  vpc_security_group_ids = [ aws_security_group.sg.id ]
  
}

locals {
  ingress_rules = [
    {port = 443
  description = "This port is used for https"
  },
  {port = 80
  description = "This port is used for nginx or application server"
  },
  {port = 8080
  description = "This port is used for jenkins"
  }
  ]
}

resource "aws_security_group" "sg" {
  egress = [{
    cidr_blocks = ["0.0.0.0/0"]
    description = "This is used for elb sg created by mahesh"
    from_port = 0
    to_port = 0
    ipv6_cidr_blocks = []
    prefix_list_ids = []
    protocol = "-1"
    security_groups = []
    self = false
  }]

  dynamic "ingress" {
    for_each = local.ingress_rules
    content { 
      description = "This is used for inbound rules"
      from_port = ingress.value.port
      to_port = ingress.value.port
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
    
  }
  
}