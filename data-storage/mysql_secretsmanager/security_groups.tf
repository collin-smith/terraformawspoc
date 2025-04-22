// Security group for Bastion Host
resource "aws_security_group" "sg_bastionhost" {
  name        = "sg_bastionhost"
  description = "Security group for rds bastion host"
  vpc_id      = var.vpc_id


  #You can limit the ingress to specific ranges to limit
  ingress {
    description = "Allow all traffic through HTTP"
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow SSH from my computer"
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr_block]
  }

  tags = {
    Name = "sg_bastionhost"
  }
}


# Security Group for RDS Database
resource "aws_security_group" "sg_rds_mysql" {
  name        = "sg_rds_mysql"
  description = "Allow access from Bastion host and Lambdas"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Allow MySQL traffic from only the lambda groups"
    from_port       = "3306"
    to_port         = "3306"
    protocol        = "tcp"
    security_groups = [aws_security_group.sg_bastionhost.id,aws_security_group.sg_lambda.id]
  }

  tags = merge(
    var.common_tags,
    {
      Name = "sg_rds_mysql"
    }
  )
}

#Security Group for VPC Endpoint to Secrets Manager
resource "aws_security_group" "sg_vpce_secretsmanager" {
  name        = "sg_vpce_secretsmanager"
  description = "Security group for vpc_endpoint to secrets manager"
  vpc_id      = var.vpc_id

  # Ingress Rules
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
    description = "Allow HTTPS inbound from the VPC itself"
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr_block]
  }

  tags = merge(
    var.common_tags,
    {
      Name = "sg_vpce_secretsmanager"
    }
  )
}

resource "aws_security_group" "sg_lambda" {
  name        = "sg_lambda"
  description = "Security group for lambdas"
  vpc_id      = var.vpc_id

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr_block]
  }

  tags = {
    Name = "sg_lambda"
  }
}

