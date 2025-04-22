// Create an Elastic IP named "tutorial_web_eip" for each
// EC2 instance
resource "aws_eip" "tutorial_web_eip" {
  count    = 1
  instance = aws_instance.bastionhost[count.index].id

  tags = merge(
    var.common_tags,
    {
      Name = "rds_bastionhost_eip_${count.index}"
    }
  )
}