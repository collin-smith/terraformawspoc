// Create a db subnet group named "dev_db_subnet_group"
resource "aws_db_subnet_group" "dev_db_subnet_group" {
  name        = "dev_db_subnet_group"
  description = "DB subnet group for dev"
  subnet_ids  = flatten([var.private_subnet_ids])
}