# AWS Configuration
variable "region" {
    description = "AWS Region"
    type = string
    default = "ca-west-1"
}

variable "profile" {
    description = "AWS profile"
    type = string
    default = "default"
}

variable "cidr_block" {
    description = "CIDR Block for VPC"
    type = string
    default = "10.0.0.0/16"
  
}

variable "public_subnet1_cidr_block" {
    description = "cidr block for the first public subnet"
    type = string
    
}

variable "public_subnet2_cidr_block" {
    description = "cidr block for the second public subnet"
    type = string
   
}

variable "public_subnet3_cidr_block" {
    description = "cidr block for the third public subnet"
    type = string
    
}

variable "private_subnet1_cidr_block" {
    description = "cidr block for the first private subnet"
    type = string
   
}

variable "private_subnet2_cidr_block" {
    description = "cidr block for the second private subnet"
    type = string
  
}

variable "private_subnet3_cidr_block" {
    description = "cidr block for the third private subnet"
    type = string
    
}

variable "public_subnet1_az" {
  description = "availability zone for the first public subnet"
  type = string
}

variable "public_subnet2_az" {
  description = "availability zone for the second public subnet"
  type = string
}

variable "public_subnet3_az" {
  description = "availability zone for the third public subnet"
  type = string
}

variable "private_subnet1_az" {
  description = "availability zone for the first private subnet"
  type = string
}

variable "private_subnet2_az" {
  description = "availability zone for the second private subnet"
  type = string
}

variable "private_subnet3_az" {
  description = "availability zone for the third private subnet"
  type = string
}

variable "instance_type"{
  description = "EC2 Instance Type"
  type = string
  default = "t2.micro"
}