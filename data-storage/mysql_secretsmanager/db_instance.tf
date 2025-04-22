resource "aws_db_instance" "rds_database" {
 allocated_storage      = 10
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t3.micro"
  username = var.rds_username
  password = random_password.password.result
  db_name                = "tutorial"
  parameter_group_name   = "default.mysql5.7"
  skip_final_snapshot    = true
  db_subnet_group_name   = aws_db_subnet_group.dev_db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.sg_rds_mysql.id]


  tags = merge(
    var.common_tags,
    {
      Name = "RDS Instance"
    }
  )
}


  