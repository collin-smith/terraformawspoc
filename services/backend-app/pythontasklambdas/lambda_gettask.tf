data "archive_file" "lambda_gettask_zip" {
  type = "zip"
source_dir  = "${path.module}/lambda_gettask/"
output_path = "${path.module}/lambda_gettask.zip"
}

resource "aws_lambda_function" "lambda_gettask" {
  function_name = "gettask"
  role          = var.iamrole_mysqlrdsrole_arn
  handler       = "index.handler"
  runtime       = "python3.10"
  filename         = data.archive_file.lambda_gettask_zip.output_path
  source_code_hash = data.archive_file.lambda_gettask_zip.output_base64sha256
  timeout = 28
  memory_size = 1024

  vpc_config {
    subnet_ids = var.public_subnet_ids
    security_group_ids = [
      #Lambda Security Group
      var.sg_lambda_id
    ]
  }

  tags = merge(
    var.common_tags,
    {
      Name = "Front end lambda"
    }
  )

  #As a simple lambda you do not actually need access to these variables as you do not access RDS in this Lambda
  environment {
    variables = {
      SECRET_NAME = var.rds_secretname,
      DB_NAME = var.rds_dbName,
        }
  }
}

