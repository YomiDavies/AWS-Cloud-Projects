# AWS Configuration
variable "region" {
 description = "AWS region" 
 type = string
 default = "ca-west-1" 
}

variable "profile" {
    description = "AWS profile"
    type = string
    default = "default"
}

# VPC Configuration
variable "cidr_block" {
    description = "VPC cidr block"
    type = string
    default = "10.0.0.0/16"
}

# Subnet Configuration
variable "public_subnet1_cidr_block" {
    description = "CIDR block for the first public subnet"
    type = string 
}

variable "public_subnet2_cidr_block" {
    description = "CIDR block for the second public subnet"
    type = string
}

variable "private_subnet1_cidr_block" {
    description = "CIDR block for the first private subnet"
    type = string
}

variable "private_subnet2_cidr_block" {
    description = "CIDR block for the second private subnet"
    type = string
}

# Availability Zones
variable "public_subnet1_az" {
    description = "Availability zone for the first public subnet"
    type = string
}

variable "public_subnet2_az" {
    description = "Availability zone for the second public subnet"
    type = string
}

variable "private_subnet1_az" {
    description = "Availability zone for the first private subnet"
    type = string
}

variable "private_subnet2_az" {
    description = "Availability zone for the second private subnet"
    type = string
}

variable "instance_type" {
    description = " EC2 Instance type"
    type = string
    default = "t2.micro"
}