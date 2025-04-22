# Create VPC Endpoint for Secrets Manager
resource "aws_vpc_endpoint" "secretsmanager" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.aws_region}.secretsmanager"
  vpc_endpoint_type = "Interface"

  subnet_ids         = var.public_subnet_ids
  security_group_ids = [aws_security_group.sg_vpce_secretsmanager.id]

  private_dns_enabled = true

  tags = merge(
    var.common_tags,
    {
      Name = "Secrets Manager VPC Endpoint"
    }
  )
}