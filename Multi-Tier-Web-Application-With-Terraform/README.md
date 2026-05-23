![te](https://github.com/YomiDavies/AWS-Cloud-Projects/blob/main/Multi-Tier-Web-Application-With-Terraform/Architecture%20for%20H.Availability.png)








# Project Overview
This project provisions a fully automated, highly available, and auto-scaled web application infrastructure on AWS using Terraform and HCL. The infrastructure spans two availability zones in the CA-West-1 (Calgary) region and uses an Application Load Balancer to distribute traffic across EC2 instances running in private subnets.

✅ What Was Built

| Resources | Name | Description |
| -------- | -------- | -------- |
| VPC      | Custom_VPC | Custom VPC with CIDR 10.0.0.0/16, DNS hostnames enabled   |
| Internet Gateway    | IGW-custom_VPC     | Attached to the VPC for internet access    |
| Public Subnets    | Public_Subnet1, Public_Subnet2     | 0.0.10.0/24 and 10.0.20.0/24 across ca-west-1a and ca-west-1b     |
| Private Subnets    | Private_Subnet1, Private_Subnet2     | 10.0.100.0/24 and 10.0.200.0/24 across ca-west-1a and ca-west-1b     |
| Elastic IPs   | EIP1, EIP2    | Assigned to NAT Gateways   |
| NAT Gateways    | NATGW1, NATGW2     | One per AZ in public subnets for private instance internet access    |
| Route Tables    | Public_RT, Private_RT_1, Private_RT_2     | Public routes via IGW, private routes via respective NAT Gateways     |
| Security Groups    | WebSG, ALBSG    | WebSG allows HTTP inbound; ALBSG allows HTTP from internet     |
| IAM Role    | EC2_SSM     | Grants EC2 instances permission to connect via SSM     |
| Instance Profile    | LT_Profile     | Attaches EC2_SSM role to instances     |
| Target Group    | WebTG     | HTTP port 80 with health check     |
| Load Balancer  | WebALB     | Internet-facing ALB across both public subnets     |
| ALB Listener    | web_listener    | Forwards HTTP port 80 traffic to WebTG     |
| Launch Template    | WebLT     | Amazon Linux 2023, t3.micro, Apache httpd via user data    |
| Auto Scaling Group   | ASG    | desired=2, min=1, max=4, ELB health checks, private subnets     |
| Row 2    | Data     | More     |
| Row 1    | Data     | More     |
| Row 2    | Data     | More     |
