# Create a Provider Block
provider "aws" {
    region = var.region
    profile = var.profile
}

# Create a VPC
resource "aws_vpc" "custom-vpc" {
  cidr_block       = var.cidr_block

  tags = {
    Name = "Custom_Vpc"
  }
}

# Create an Internet Gateway and attach it to the VPC
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.custom-vpc.id

  tags = {
    Name = "Internet_Gateway"
  }
}
# Create 3 Public and 3 Private Subnets
resource "aws_subnet" "public1" {
  vpc_id     = aws_vpc.custom-vpc.id
  cidr_block =  var.public_subnet1_cidr_block
  availability_zone = var.public_subnet1_az
  map_public_ip_on_launch = true

  tags = {
    Name = "public_subnet1"
  }
}

resource "aws_subnet" "public2" {
  vpc_id     = aws_vpc.custom-vpc.id
  cidr_block =  var.public_subnet2_cidr_block
  availability_zone = var.public_subnet2_az
  map_public_ip_on_launch = true

  tags = {
    Name = "public_subnet2"
  }
}

resource "aws_subnet" "public3" {
  vpc_id     = aws_vpc.custom-vpc.id
  cidr_block =  var.public_subnet3_cidr_block
  availability_zone = var.public_subnet3_az
  map_public_ip_on_launch = true

  tags = {
    Name = "public_subnet3"
  }
}

# Create a Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.custom-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  # route {
  #   cidr_block = "10.0.0.0/16"
  #   gateway_id = "Local"
  # }

  tags = {
    Name = "public_rt"
  }
}
# Associate the route table with public subnet 1
resource "aws_route_table_association" "public1" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.public.id
}

# Associate the route table with public subnet 2
resource "aws_route_table_association" "public2" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.public.id
}

# Associate the route table with public subnet 3
resource "aws_route_table_association" "public3" {
  subnet_id      = aws_subnet.public3.id
  route_table_id = aws_route_table.public.id
}

resource "aws_subnet" "private1" {
  vpc_id     = aws_vpc.custom-vpc.id
  cidr_block =  var.private_subnet1_cidr_block
  availability_zone = var.private_subnet1_az

  tags = {
    Name = "private_subnet1"
  }
}

resource "aws_subnet" "private2" {
  vpc_id     = aws_vpc.custom-vpc.id
  cidr_block =  var.private_subnet2_cidr_block
  availability_zone = var.private_subnet2_az

  tags = {
    Name = "private_subnet2"
  }
}

resource "aws_subnet" "private3" {
  vpc_id     = aws_vpc.custom-vpc.id
  cidr_block =  var.private_subnet3_cidr_block
  availability_zone = var.private_subnet3_az

  tags = {
    Name = "private_subnet3"
  }
}

resource "aws_eip" "eip1" {
  domain   = "vpc"

  tags = {
    Name = "EIP1"
  }

}

resource "aws_eip" "eip2" {
  domain   = "vpc"

  tags = {
    Name = "EIP2"
  }

}

resource "aws_eip" "eip3" {
  domain   = "vpc"

  tags = {
    Name = "EIP3"
  }

}

resource "aws_nat_gateway" "nat_gw1" {
  allocation_id = aws_eip.eip1.id
  subnet_id     = aws_subnet.public1.id
  

  tags = {
    Name = " NAT-GW1"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.gw]
}

resource "aws_nat_gateway" "nat_gw2" {
  allocation_id = aws_eip.eip2.id
  subnet_id     = aws_subnet.public2.id
  

  tags = {
    Name = "NAT-GW2"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.gw]
}

resource "aws_nat_gateway" "nat_gw3" {
  allocation_id = aws_eip.eip3.id
  subnet_id     = aws_subnet.public3.id
  

  tags = {
    Name = "NAT-GW3"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.gw]
}

resource "aws_route_table" "prt1" {
  vpc_id = aws_vpc.custom-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw1.id
  }

  

  tags = {
    Name = "private_rt1"
  }
}

resource "aws_route_table" "prt2" {
  vpc_id = aws_vpc.custom-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw2.id
  }

  

  tags = {
    Name = "private_rt2"
  }
}

resource "aws_route_table" "prt3" {
  vpc_id = aws_vpc.custom-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw3.id
  }

  

  tags = {
    Name = "private_rt3"
  }
}

resource "aws_route_table_association" "private_1" {
  subnet_id      = aws_subnet.private1.id
  route_table_id = aws_route_table.prt1.id
}

resource "aws_route_table_association" "private_2" {
  subnet_id      = aws_subnet.private2.id
  route_table_id = aws_route_table.prt2.id
}

resource "aws_route_table_association" "private_3" {
  subnet_id      = aws_subnet.private3.id
  route_table_id = aws_route_table.prt3.id
}

# Create a Security group WebSG for the public subnets 
resource "aws_security_group" "websg" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.custom-vpc.id

  tags = {
    Name = "WebSG"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_ipv4" {
  security_group_id = aws_security_group.websg.id
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
  cidr_ipv4 = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.private_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

# Create a security group INSG for the private subnets
resource "aws_security_group" "private_sg" {
  name        = "PrivateSG"
  description = "Allow inbound traffic only from the public subnet SG"
  vpc_id      = aws_vpc.custom-vpc.id

  tags = {
    Name = "allow_publicSG"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_psg_only" {
  security_group_id = aws_security_group.private_sg.id
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
  referenced_security_group_id = aws_security_group.websg.id
}

resource "aws_vpc_security_group_egress_rule" "all_traffic_ipv4" {
  security_group_id = aws_security_group.websg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

# create an IAM Role
resource "aws_iam_role" "test_role" {
  name = "test_role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    Name = "Role-ec2"
  }
}



resource "aws_iam_instance_profile" "test_profile" {
  name = "test_profile"
  role = aws_iam_role.test_role.name
}


data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role_policy_attachment" "ssm_policy" {
  role       = aws_iam_role.test_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_launch_template" "launch_temp" {
  name = "lt_template"
  image_id = "ami-0e7c11559210b8837"
  instance_type = var.instance_type

vpc_security_group_ids = [aws_security_group.websg.id]

user_data = base64encode(<<-EOF
#!/bin/bash
# Update the system
dnf update -y
# Install Apache web server
dnf install -y httpd
# Start and enable Apache
systemctl start httpd
systemctl enable httpd
# Create a simple landing page
echo "<h1>Hello from EC2 User Data</h1>" > /var/www/html/index.html
EOF
)

  iam_instance_profile {
    name = aws_iam_instance_profile.test_profile.name
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "test"
    }
  }


}

# Create a target group
resource "aws_lb_target_group" "tg" {
  name     = "TG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.custom-vpc.id

tags = {
  Name = "PT_TG"
}

 health_check {
    enabled             = true
    port                = 80
    protocol            = "HTTP"
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 5
  }
}

# Create a Load Balancer
resource "aws_lb" "test" {
  name               = "Web-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.websg.id]
  subnets            = [aws_subnet.public1.id, aws_subnet.public2.id, aws_subnet.public3.id]

 

  tags = {
   Name = "Web_ALB"
  }
}

#Create a Listener - tells ALB what to do with Incoming Traffic

resource "aws_lb_listener" "web_listener" {
  load_balancer_arn = aws_lb.test.arn 
  port              = "443"
  protocol          = "HTTP"
 
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

resource "aws_autoscaling_policy" "asg-p" {
  name = "ASG-policy"
  policy_type = "TargetTrackingScaling"
  autoscaling_group_name = aws_autoscaling_group.asg.name

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 30.0
  }
}
# Create an auto scaling group
resource "aws_autoscaling_group" "asg" {
  vpc_zone_identifier = [aws_subnet.public1.id, aws_subnet.public2.id, aws_subnet.public3.id]
  desired_capacity   = 2
  max_size           = 5
  min_size           = 1
  health_check_type = "EC2"
  health_check_grace_period = 300
  wait_for_capacity_timeout = "0"
  target_group_arns = [aws_lb_target_group.tg.arn]

  launch_template {
    id      = aws_launch_template.launch_temp.id
    version = "$Latest"
  }
}

