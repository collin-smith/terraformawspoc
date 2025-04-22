
#Role #1: (Allowing simple vpc access only)
#An IAM role is an IAM identity that you can create in your account that has specific permissions. 
resource "aws_iam_role" "iamrole_pythonlambda" {
  name = "iamrole_lambda"

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
      Name = "Lambda assume role"
    }
  )
}

#Attaching a policy(permissions) to an IAM role
#Provides minimum permissions for a Lambda function to execute while accessing a resource within a VPC - create, describe, delete network interfaces and write permissions to CloudWatch Logs.
resource "aws_iam_role_policy_attachment" "iampolicyattachment_pythonlambda_vpcaccess" {
  role       = aws_iam_role.iamrole_pythonlambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

#The role to access the MySQL RDS and Secrets Manager can be found in the data-storage\mysql_secretsmanager iamroles.tf
#Role #2: MySQL RDS Access Role (Allowing access to RDS and Secrets Manager)
#An IAM role is an IAM identity that you can create in your account that has specific permissions. 
#resource "aws_iam_role" "iamrole_mysqlrdsrole" {
#  name = "iamrole_mysqlrdsrole"

#  assume_role_policy = jsonencode({
##    Version = "2012-10-17"
#    Statement = [
 #     {
  #      Action = "sts:AssumeRole"
   #     Effect = "Allow"
    #    Principal = {
#          Service = "lambda.amazonaws.com"
 #       }
  #    }
   # ]
#  })

#  tags = merge(
#    var.common_tags,
#    {
#      Name = "Lambda assume role"
#    }
#  )
#}

#A policy is an object in AWS that, when associated with an identity or resource, defines their permissions. 
#AWS evaluates these policies when an IAM principal (user or role) makes a request.
#resource "aws_iam_policy" "iampolicy_mysqlrds" {
#  name        = "iampolicy_mysqlrds"
#  description = "IAM policy for Lambda to access RDS and Secrets Manager"

#  policy = jsonencode({
#    Version = "2012-10-17"
#    Statement = [
#      {
#        Action = [
#          "rds:DescribeDBInstances",
#          "rds:Connect"
#        ]
#        Effect   = "Allow"
#        Resource = "*"
#      },
#      {
#        Action = [
#          "secretsmanager:GetSecretValue"
#        ]
#        Effect   = "Allow"
#        Resource = "*"
#      }
#    ]
#  })

#  tags = merge(
#    var.common_tags,
#    {
#      Name = "Policy to allow access to connect to RDS and Secrets Manager"
#    }
#  )
#}

#Attaching a policy(permissions) to an IAM role
#Provides minimum permissions for a Lambda function to execute while accessing a resource within a VPC - create, describe, delete network interfaces and write permissions to CloudWatch Logs.
#resource "aws_iam_role_policy_attachment" "iampolicyattachment_mysqlrds_vpcaccess" {
#  role       = aws_iam_role.iamrole_mysqlrdsrole.name
#  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
#}

#Attaching a policy(permissions) to an IAM role
#Provides access to RDS and Secrets Manager
#resource "aws_iam_role_policy_attachment" "iampolicyattachment_mysqlrds" {
#  role       = aws_iam_role.iamrole_mysqlrdsrole.name
#  policy_arn = aws_iam_policy.iampolicy_mysqlrds.arn
#}


