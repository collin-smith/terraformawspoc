data "archive_file" "lambda_secretrotation_zip" {
  type = "zip"
  source_dir  = "${path.module}/lambda_secretrotation/"
  output_path = "${path.module}/lambda_secretrotation.zip"
}

# Lambda Function
resource "aws_lambda_function" "lambda_secretrotation" {
  function_name = "secretrotation"
  role          = aws_iam_role.iamrole_mysqlrds_rotation.arn
  handler       = "index.lambda_handler"
  runtime       = "python3.9"
  filename         = data.archive_file.lambda_secretrotation_zip.output_path
  source_code_hash = data.archive_file.lambda_secretrotation_zip.output_base64sha256
  timeout = 28
  memory_size = 1024

  vpc_config {
    subnet_ids = var.public_subnet_ids
    security_group_ids = [
      aws_security_group.sg_lambda.id    // Access to RDS
    ]
  }

# The secrets manager rotation lambda requires the SECRETS_MANAGER_ENDPOINT
# service_client = boto3.client('secretsmanager', endpoint_url=os.environ['SECRETS_MANAGER_ENDPOINT'])
  environment {
    variables = {
      SECRETS_MANAGER_ENDPOINT =  "https://secretsmanager.${var.aws_region}.amazonaws.com"}
  }

  tags = merge(
    var.common_tags,
    {
      Name = "RDS MySql Secret Rotation Lambda"
    }
  )


}

# Grant Secrets Manager Permission to Invoke Lambda
resource "aws_lambda_permission" "allow_secrets_manager" {
  statement_id  = "AllowSecretsManager"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_secretrotation.function_name
  principal     = "secretsmanager.amazonaws.com"
}
