variable "aws_region" {
  description = "AWS region"
  type        = string
  default = "us-east-1"
}

variable "common_tags" {
  description = "A list of common tags to be applied to all resources"
  type        = map(string)
  default = {
    Environment = "dev"
    Team        = "cloud team"
  }
}

#Reuse from POC outputs
variable "public_subnet_ids" {
  description = "Public subnet ids"
  default     =   [
  "subnet-00faec5d6404e78ed",
  "subnet-07a9efffa65fa9227",
  "subnet-044c46ec084412506",
  ]
}

#Reuse from RDS Outputs
variable "rds_secretname" {
  description = "AWS Secret Name"
  type        = string
  default = "RDS_SecretApril211347"
}

#Ensure you created this database according to the article
variable "rds_dbName" {
  description = "database name"
  type        = string
  default = "POC"
}

#Reuse from RDS Outputs
variable "iamrole_mysqlrdsrole_arn" {
  description = "MySQL access IAM Role"
  type        = string
  default = "arn:aws:iam::099611363243:role/iamrole_mysqlrdsclient"
}

#Reuse from RDS Outputs
variable "sg_lambda_id" {
  description = "Lambda Security Group"
  type        = string
  default = "sg-0ab7551e2594c935c"
}




