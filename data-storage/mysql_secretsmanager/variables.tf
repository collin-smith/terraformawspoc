# Variables
variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "common_tags" {
  description = "A list of common tags to be applied to all resources"
  type        = map(string)
  default = {
    Environment = "dev_mysqlsecretsmanager"
    Team        = "cloud team"
  }
}

variable "vpc_cidr_block" {
  description = "VPC Cidr block"
  default     = "10.0.0.0/16"
}

variable "vpc_id" {
  description = "VPC Id"
  default     = "vpc-02e30fa06939fb8d2"
}

variable "public_subnet_ids" {
  description = "Public subnet ids"
  default     =   [
  "subnet-00faec5d6404e78ed",
  "subnet-07a9efffa65fa9227",
  "subnet-044c46ec084412506",
]
}

variable "private_subnet_ids" {
  description = "Private subnet ids"
  default     = [
  "subnet-0de8b98c877073e68",
  "subnet-033a80f9a293c03cb",
  "subnet-047e14cc97078e594",
]
}

#Usually the first public subnet id from above
variable "bastion_subnet_id" {
  description = "Public subnet for Bastion Host"
  default     = "subnet-00faec5d6404e78ed"
}

#The secret name should be updated each time you apply the terraform
variable "secretname" {
  description = "Secrets Manager secret name"
  default     = "RDS_SecretApril211347"
}

#ec2 Key pair created in the console and download the pem file locally
variable "ec2_keypair_bastion" {
  description = "Private ec2 key pair for bastion host"
  default     = "rds-bastion"
}

variable "rds_username" {
  description = "RDS Username to store in secrets manager"
  default     = "rdsuser"
}

variable "rds_db_subnet_group_name" {
  description = "RDS Subnet Group Name "
  default     = "dev_db_subnet_group"
}