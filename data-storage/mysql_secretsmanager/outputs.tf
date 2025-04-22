output "A_web_public_dns" {
  description = "The public DNS address of the web server"
  value       = aws_eip.tutorial_web_eip[0].public_dns
  depends_on = [aws_eip.tutorial_web_eip]
}
output "B_web_public_ip" {
  description = "The public IP address of the web server"
  value       = aws_eip.tutorial_web_eip[0].public_ip
  depends_on = [aws_eip.tutorial_web_eip]
}

output "C_ssh_bastion_username" {
  description = "Bastion User Name"
  value       = "ec2-user"
}

output "D_ec2_keypair_bastion" {
  description = "EC2 Key Pair for the Bastion Host for PEM or SSK Key File for SSH client"
  value       = var.ec2_keypair_bastion
}

output "E_database_endpoint" {
  description = "The endpoint of the database"
  value       = aws_db_instance.rds_database.address
}

output "F_database_port" {
  description = "The port of the database"
  value       = aws_db_instance.rds_database.port
}

output "G_rds_username" {
  description = "RDS Username"
  value       = var.rds_username
}

output "H_rds_password" {
  description = "RDS Username"
  value       =  format("Check in Secrets Manager under secret :%s",aws_secretsmanager_secret.mysecret.name)
}

output "I_lambdasecurityGroup" {
  description = "Lambda Security Group"
  value       =  aws_security_group.sg_lambda.id
}

output "J_iamrole_mysqlrdsrole_arn" {
  description = "IAM Role iamrole_mysqlrdsrole arn"
  value       =  aws_iam_role.iamrole_mysqlrdsclient.arn

}