# Terraform-aws-vpc

## Overview 

This Terraform module creates an AWS VPC with a given CIDR block. It also creates multiple subnets (public and private), and for public subnets, it sets up an Internet Gateway (IGW) and appropriate route tables.

## First we will add the IAM user access_key and secret_key for run this command:
- aws comfigure
  AWS Access Key ID : ******************
  AWS Secret Access Key : *************************
  Default Region Name : ap-south-1
## Features

- Creates a VPC with a specified CIDR block
- Creates public and private subnets
- Creates an Internet Gateway (IGW) for public subnets
- Sets up route tables for public subnets

## Usage
```
module "vpc" {
  source = "./module/vpc" 

  vpc_config = {
    cidr_block = "10.0.0.0/16"
    name       = "your-vpc-name"
  }

  subnet_config = {
    public_subnet-1 = {
        cidr_block = "10.0.0.0/24"
        az         = "ap-south-1a"
        # To set the subnet as public, default is private
        public     = true
    }

    private_subnet = {
        cidr_block = "10.0.2.0/24"
        az         = "ap-south-1c"
    }
  }
}
```
