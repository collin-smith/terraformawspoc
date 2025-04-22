data "archive_file" "lambda_gettasks_zip" {
  type = "zip"
source_dir  = "${path.module}/lambda_gettasks/"
output_path = "${path.module}/lambda_gettasks.zip"
}

resource "aws_lambda_function" "lambda_gettasks" {
  function_name = "gettasks"
  role          = var.iamrole_mysqlrdsrole_arn
  handler       = "index.handler"
  runtime       = "python3.10"
  filename         = data.archive_file.lambda_gettasks_zip.output_path
  source_code_hash = data.archive_file.lambda_gettasks_zip.output_base64sha256
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
      Name = "Insert lambda"
    }
  )

  environment {
    variables = {
      SECRET_NAME = var.rds_secretname,
      DB_NAME = var.rds_dbName,
        }
  }
}

