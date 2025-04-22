data "archive_file" "lambda_mysqlrdsclient_zip" {
  type = "zip"
source_dir  = "${path.module}/lambda_mysqlrdsclient/"
output_path = "${path.module}/lambda_mysqlrdsclient.zip"
}

resource "aws_lambda_function" "lambda_mysqlrdsclient" {
  function_name = "mysqlrdsclient"
  role          = aws_iam_role.iamrole_mysqlrdsclient.arn
  handler       = "index.handler"
  runtime       = "python3.9"
  filename         = data.archive_file.lambda_mysqlrdsclient_zip.output_path
  source_code_hash = data.archive_file.lambda_mysqlrdsclient_zip.output_base64sha256
  timeout = 28
  memory_size = 1024

  vpc_config {
    subnet_ids = var.public_subnet_ids
    security_group_ids = [
      #Lambda Security Group
      aws_security_group.sg_lambda.id 
    ]
  }

  tags = merge(
    var.common_tags,
    {
      Name = "Lambda MySql RDS Client"
    }
  )

  environment {
    variables = {
      SECRET_NAME = aws_secretsmanager_secret.mysecret.name,
      DB_NAME = aws_db_instance.rds_database.db_name  }
  }
}

