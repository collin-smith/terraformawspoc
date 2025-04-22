// Create an EC2 instance named "tutorial_web"
resource "aws_instance" "bastionhost" {
  count = 1
 
  # Verify that the AMI is a valid option for your region (See EC2 in Console)
  ami = "ami-01816d07b1128cd2d"
  instance_type          = "t2.nano"
  subnet_id              = var.bastion_subnet_id
   key_name               = var.ec2_keypair_bastion   

  vpc_security_group_ids = [aws_security_group.sg_bastionhost.id]


  tags = merge(
    var.common_tags,
    {
      Name = "dev_bastionhost_${count.index}"
    }
  )

}