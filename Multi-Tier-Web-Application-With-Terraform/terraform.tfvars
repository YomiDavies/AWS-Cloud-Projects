# AWS Configuration
region = "ca-west-1" 
profile = "prod_admin"

# VPC Configuration
cidr_block = "10.0.0.0/16"

# Subnet Configuration
public_subnet1_cidr_block = "10.0.10.0/24"  
public_subnet2_cidr_block = "10.0.20.0/24"  
private_subnet1_cidr_block = "10.0.100.0/24"  
private_subnet2_cidr_block = "10.0.200.0/24"     

# Availability Zones
public_subnet1_az = "ca-west-1a"
public_subnet2_az = "ca-west-1b"
private_subnet1_az = "ca-west-1a"
private_subnet2_az = "ca-west-1b"

# Instance Configuration
instance_type = "t3.micro"