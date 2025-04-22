resource "random_password" "password" {
  length           = 32
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "aws_secretsmanager_secret" "mysecret" {
  name = var.secretname
  description = "Secrets Manager secret name"

  tags = merge(
    var.common_tags,
    {
      Name = "Secrets Manager Secret"
    }
  )
}

resource "aws_secretsmanager_secret_rotation" "mysecret" {
  secret_id = aws_secretsmanager_secret.mysecret.id
  rotation_lambda_arn = aws_lambda_function.lambda_secretrotation.arn

  rotation_rules {
    automatically_after_days = 30
  }
}

resource "aws_secretsmanager_secret_version" "secret" {
  secret_id = aws_secretsmanager_secret.mysecret.id
  secret_string = jsonencode({
    username = var.rds_username
    password = random_password.password.result
    engine   = "mysql"
    host     = aws_db_instance.rds_database.address 
    port     = 3306
  })
}


