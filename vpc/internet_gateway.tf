resource "aws_internet_gateway" "dev_igw" {
  vpc_id = aws_vpc.dev_vpc.id
  
  tags = merge(
    var.common_tags,
    {
      Name = "Internet Gateway dev_igw"
    }
  )
}
