# Create ec2-instance

resource "aws_instance" "Tesla-EV" {
  ami                         = "ami-08df646e18b182346"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.Tesla-pub-subnet.id
  vpc_security_group_ids      = [aws_security_group.Tesla-SG.id]
  key_name                    = "harsha"
  count                       = 2
  associate_public_ip_address = "true"
  tags = {
    Name = "TESLA-EV"
  }
}
# Create An PVT ec2-instance

resource "aws_instance" "Tesla-EVR" {
  ami                         = "ami-08df646e18b182346"
  instance_type               = "t2.micro"
  availability_zone           = "ap-south-1b"
  subnet_id                   = aws_subnet.Tesla-pvt-subnet.id
  vpc_security_group_ids      = [aws_security_group.Tesla-SG.id]
  key_name                    = "harsha"
  associate_public_ip_address = "false"
  tags = {
    Name = "TESLA-EVR"
  }
}

