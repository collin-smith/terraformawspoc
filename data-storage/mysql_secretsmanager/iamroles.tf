#Role #1: MySQL RDS Access Role (Allowing access to RDS and Secrets Manager)
#An IAM role is an IAM identity that you can create in your account that has specific permissions. 
#Note: This role should be passed on for Lambdas or other services to interact with the created database here
resource "aws_iam_role" "iamrole_mysqlrdsclient" {
  name = "iamrole_mysqlrdsclient"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })

  tags = merge(
    var.common_tags,
    {
      Name = "MySQL RDS IAM Role"
    }
  )
}

#A policy is an object in AWS that, when associated with an identity or resource, defines their permissions. 
#AWS evaluates these policies when an IAM principal (user or role) makes a request.
resource "aws_iam_policy" "iampolicy_mysqlrdsclient" {
  name        = "iampolicy_mysqlrdsclient"
  description = "IAM policy for Lambda to access RDS and Secrets Manager"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "rds:DescribeDBInstances",
          "rds:Connect"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "secretsmanager:GetSecretValue"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })

  tags = merge(
    var.common_tags,
    {
      Name = "Policy to allow access to connect to RDS and Secrets Manager"
    }
  )
}

#Attaching a policy(permissions) to an IAM role
#Provides minimum permissions for a Lambda function to execute while accessing a resource within a VPC - create, describe, delete network interfaces and write permissions to CloudWatch Logs.
resource "aws_iam_role_policy_attachment" "iampolicyattachment_mysqlrdsclient_vpcaccess" {
  role       = aws_iam_role.iamrole_mysqlrdsclient.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

#Attaching a policy(permissions) to an IAM role
#Provides access to RDS and Secrets Manager
resource "aws_iam_role_policy_attachment" "iampolicyattachment_mysqlrds" {
  role       = aws_iam_role.iamrole_mysqlrdsclient.name
  policy_arn = aws_iam_policy.iampolicy_mysqlrdsclient.arn
}


# Role#2 Create IAM Role for MySQLRDS Rotation
resource "aws_iam_role" "iamrole_mysqlrds_rotation" {
  name = "iamrole_mysqlrds_rotation"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })

  tags = merge(
    var.common_tags,
    {
      Name = "RDS Secret Rotation Lambda Role"
    }
  )
}


# Create IAM Policy for Secrets Manager Rotation
resource "aws_iam_policy" "iampolicy_mysqlrds_rotation" {
  name        = "iampolicy_mysqlrds_rotation"
  description = "Policy for a Secret Rotation Lambda function"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:DescribeSecret",
          "secretsmanager:GetSecretValue",
          "secretsmanager:PutSecretValue",
          "secretsmanager:UpdateSecretVersionStage",
          "secretsmanager:UpdateSecret",
          "secretsmanager:GetRandomPassword"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "rds:ModifyDBCluster"
        ]
        Resource = "*"
      }
    ]
  })

  tags = merge(
    var.common_tags,
    {
      Name = "RdsSecretRotationPolicy"
    }
  )
}

# Attach the Policy to IAM Role
resource "aws_iam_role_policy_attachment" "iampolicyattachment_mysqlrdsrotation" {
  role       = aws_iam_role.iamrole_mysqlrds_rotation.name
  policy_arn = aws_iam_policy.iampolicy_mysqlrds_rotation.arn
}

# Attach AWSLambdaVPCAccessExecutionRole Policy
resource "aws_iam_role_policy_attachment" "iampolicyattachment_mysqlrdsrotation_vpc_access" {
  role       = aws_iam_role.iamrole_mysqlrds_rotation.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}
