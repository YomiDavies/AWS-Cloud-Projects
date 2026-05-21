# Define the provider block
provider "aws" {
  region  = var.region
  profile = var.profile
}


# Create a vpc
resource "aws_vpc" "main" {
  cidr_block = var.cidr_block
  enable_dns_hostnames = "true"

  tags = {
    Name = "custom_VPC"
  }
}

# Create an Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "IGW-custom_VPC"
  }
}

# Attach an Internet Gateway to the VPC
# YOU WILL RUN INTERNET GATEWAY ATTACHMENT THE FIRT TIME ONLY.
# resource "aws_internet_gateway_attachment" "example" {
#   internet_gateway_id = aws_internet_gateway.gw.id
#   vpc_id              = aws_vpc.main.id
# }

# Public Subnet 1
resource "aws_subnet" "public_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet1_cidr_block
  availability_zone       = var.public_subnet1_az
  map_public_ip_on_launch = true

  tags = {
    Name = "Public_Subnet1"
  }
}

# Public Subnet 2
resource "aws_subnet" "public_2" {
    vpc_id                = aws_vpc.main.id
    cidr_block            = var.public_subnet2_cidr_block
    availability_zone     = var.public_subnet2_az
    map_public_ip_on_launch = true

    tags = {
        Name = "Public_Subnet2"
    }


}
  
# Route table with a route to the internet
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  route {
    cidr_block = "10.0.0.0/16"
    gateway_id = "local"
  }
  tags = {
    Name = "public-RT"
  }
}

# Associate route table with public subnet 1
resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public.id
}

# Associate route table with public subnet 2
resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public.id
}

# Create the first Private Subnet
resource "aws_subnet" "private_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_subnet1_cidr_block
  availability_zone       = var.private_subnet1_az

  tags = {
    Name = "Private_Subnet1"
  }
}

# Create the second Private Subnet 
resource "aws_subnet" "private_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_subnet2_cidr_block
  availability_zone       = var.private_subnet2_az

  tags = {
    Name = "Private_Subnet2"
  }
}

# Create the First Elastic IP Address
resource "aws_eip" "eip1"{
  domain   = "vpc"

  tags = {
      Name = "EIP1"
  }

}

# Create the Second Elastic IP Address
resource "aws_eip" "eip2" {
  domain   = "vpc"

  tags = {
      Name = "EIP2"
  }

}

# Create a NAT gateway in the first public subnet
resource "aws_nat_gateway" "nat-gw-1" {
  allocation_id     = aws_eip.eip1.id
  subnet_id         = aws_subnet.public_1.id

  tags = {
    name = "NATGW1"
  }
    
  }

# Create a NAT gateway in the second public subnet
  resource "aws_nat_gateway" "nat-gw-2" {
  allocation_id     = aws_eip.eip2.id
  subnet_id         = aws_subnet.public_2.id

  tags = {
    name = "NATGW2"
  }
    
  }

  # Create Private Route Table 1 - routes through NAT Gateway 1 (ca-west-1a)
resource "aws_route_table" "private_rt_1" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gw-1.id
  }

  tags = {
    Name = "Private_RT_1"
  }
}

  # Create Private Route Table 2 - routes through NAT Gateway 2 (ca-west-1b)
resource "aws_route_table" "private_rt_2" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gw-2.id
  }

  tags = {
    Name = "Private_RT_2"
  }
}

# Associate Private Route Table 1 with Private Subnet 1
resource "aws_route_table_association" "private_1" {
  subnet_id      = aws_subnet.private_1.id
  route_table_id = aws_route_table.private_rt_1.id
}

# Associate Private Route Table 2 with Private Subnet 2
resource "aws_route_table_association" "private_2" {
  subnet_id      = aws_subnet.private_2.id
  route_table_id = aws_route_table.private_rt_2.id
}

# Create the WebSG security group
resource "aws_security_group" "websg" {
  name        = "allow_http2"
  description = "Allow HTTP inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "WebSG"
  }
}
# The resource to create an ingress rule in the security group, which is aws_vpc_security_group_ingress_rule
resource "aws_vpc_security_group_ingress_rule" "allow_http1" {
  security_group_id = aws_security_group.websg.id
  cidr_ipv4         = aws_vpc.main.cidr_block
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

# The resource to create an egress rule in the security group, which is aws_vpc_security_group_egress_rule
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4-1" {
  security_group_id = aws_security_group.websg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

# Create the ABSG security group
resource "aws_security_group" "albsg" {
  name        = "allow_http"
  description = "Allow HTTP inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "ALBSG"
  }
}

# The resource to create an ingress rule in the security group, which is aws_vpc_security_group_ingress_rule
resource "aws_vpc_security_group_ingress_rule" "allow_http2" {
  security_group_id = aws_security_group.albsg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

# The resource to create an egress rule in the security group, which is aws_vpc_security_group_egress_rule
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4-2" {
  security_group_id = aws_security_group.albsg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

# Create the IAM Role
resource "aws_iam_role" "ssm_role" {
  name = "EC2_SSM"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name = "EC2_SSM"
  }
}

# Attach AmazonEC2RoleforSSM policy to the role
resource "aws_iam_role_policy_attachment" "ssm_policy" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}

# Create an Instance Profile
resource "aws_iam_instance_profile" "lt_profile" {
  name = "LT_Profile"
  role = aws_iam_role.ssm_role.name

  tags = {
    Name = "LT_Profile"
  }
}

# Create a target Group
resource "aws_lb_target_group" "web-tg" {
  name     = "WebTG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  tags = {
    Name = "WebTG"
  }

  health_check {
    enabled             = true
    port                = 80
    protocol            = "HTTP"
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

# Create a Load balancer
resource "aws_lb" "web-alb" {
  name               = "WebALB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.albsg.id]
  subnets            = [aws_subnet.public_1.id, aws_subnet.public_2.id]


  tags = {
    Name = "WebALB"
  }
}

# Create a listener - tells ALB what to do with Incoming traffoic
resource "aws_lb_listener" "web_listener" {
  load_balancer_arn = aws_lb.web-alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web-tg.arn
  }
}

# Create a launch template
resource "aws_launch_template" "web_lt" {
  name   = "WebLT"
  image_id      = "ami-09118fdae94b4fed8"
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.websg.id]

# User data script
user_data = base64encode(<<-EOF
#!bin/bash
yum update -y
yum install httpd -y
systemctl start httpd
systemctl enable httpd
echo " This is an app server in AWS Region CA-WEST-1 " > /var/www/html/index.html
EOF
)

  iam_instance_profile {
    name = aws_iam_instance_profile.lt_profile.name
  }

tags = {
    Name = "Web_LT"
}
}

# Create the autoscaling group
resource "aws_autoscaling_group" "asg" {
  vpc_zone_identifier = [aws_subnet.private_1.id, aws_subnet.private_2.id]
  health_check_type = "ELB"
  desired_capacity   = 2
  max_size           = 4
  min_size           = 1
  target_group_arns = [aws_lb_target_group.web-tg.arn]
  

  launch_template {
    id      = aws_launch_template.web_lt.id
    version = "$Latest"
  }

  tag {
    key = "Name"
    value = "ASG"
    propagate_at_launch = true
  }

}

output "aws_lb" {
  value = aws_lb.web-alb.dns_name
  
}