resource "aws_instance" "public-ec2" {
 ami           = "ami-00569e54da628d17c"
  instance_type = "t2.micro"
  associate_public_ip_address = true
  subnet_id = aws_subnet.eks-pub1.id
  vpc_security_group_ids = [aws_security_group.eks.id]
  key_name = "finalproject"
  tags = {
    Name = "bastion-host"
  }
  
}