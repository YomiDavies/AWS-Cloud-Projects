![te](https://github.com/YomiDavies/AWS-Cloud-Projects/blob/main/Multi-Tier-Web-Application-With-Terraform/Architecture%20for%20H.Availability.png)








# Project Overview
This project provisions a fully automated, highly available, and auto-scaled web application infrastructure on AWS using Terraform and HCL. The infrastructure spans two availability zones in the CA-West-1 (Calgary) region and uses an Application Load Balancer to distribute traffic across EC2 instances running in private subnets.

✅ What Was Built
ResourceNameDescriptionVPCcustom_VPCCustom VPC with CIDR 10.0.0.0/16, DNS hostnames enabledInternet GatewayIGW-custom_VPCAttached to the VPC for internet accessPublic SubnetsPublic_Subnet1, Public_Subnet210.0.10.0/24 and 10.0.20.0/24 across us-east-1a and us-east-1bPrivate SubnetsPrivate_Subnet1, Private_Subnet210.0.100.0/24 and 10.0.200.0/24 across us-east-1a and us-east-1bElastic IPsEIP1, EIP2Assigned to NAT GatewaysNAT GatewaysNATGW1, NATGW2One per AZ in public subnets for private instance internet accessRoute TablesPublic_RT, Private_RT_1, Private_RT_2Public routes via IGW, private routes via respective NAT GatewaysSecurity GroupsWebSG, ALBSGWebSG allows HTTP inbound; ALBSG allows HTTP from internetIAM RoleEC2_SSMGrants EC2 instances permission to connect via SSMInstance ProfileLT_ProfileAttaches EC2_SSM role to instancesTarget GroupWebTGHTTP port 80 with health checksLoad BalancerWebALBInternet-facing ALB across both public subnetsALB Listenerweb_listenerForwards HTTP port 80 traffic to WebTGLaunch TemplateWebLTAmazon Linux 2023, t3.micro, Apache httpd via user dataAuto Scaling GroupASGdesired=2, min=1, max=4, ELB health checks, private subnets
