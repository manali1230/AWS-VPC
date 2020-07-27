//variable created to store the key
variable "key" {
  default = "My12"
}

//generate key-pair
resource "aws_key_pair" "enter_key_name" {
  key_name   = var.key
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC+nYcXP3F5MRp+1XLRCoOd5YnC58uYrfKNnVJ5KNexZJU5J4qScYk+htJQCvUVTON/3X29zLM3pcRERkRy7dr8pv0L//MdL+n4nf7hI9qh/sAl7cTSx/sw+R7Do25NNDTZzksmHNK+9ojwus+C2DI+KQ/LLiGR/r6TNdsPPSeJLN0gxdbM2jaH9mGoOlQdPC5eJBYkA36Rk2AHWQ9S9Acjz1h19rxorLKV95UN3T09MJsaTwlOosf0h8UU7lBmdIya5QN18XmPy6XovaNxJlNLFQwSbVukR5RE/W6eeg/P2wbq6sHuKi3NYWJXAuj71RWCIWFVY8P8XZ3ZBdnoOF9b manali@DESKTOP-B1P0RR5"
}

//create instance
resource "aws_instance" "wp" {

  key_name      = "${aws_key_pair.enter_key_name.key_name}"
  ami           = "ami-000cbce3e1b899ebd"
  instance_type = "t2.micro"
  associate_public_ip_address = true
  subnet_id = aws_subnet.subnet1.id
  vpc_security_group_ids = [aws_security_group.publicsubnet.id]
  availability_zone = "ap-south-1a"

tags = {
    Name = "wordpress"
  }
depends_on = [
    aws_vpc.main,aws_route_table_association.addsubnet1,aws_security_group.publicsubnet,
  ]
}

resource "aws_instance" "mysql" {

  key_name      = "${aws_key_pair.enter_key_name.key_name}"
  ami           = "ami-08706cb5f68222d09"
  instance_type = "t2.micro"
  associate_public_ip_address = false
  subnet_id = aws_subnet.subnet2.id
  vpc_security_group_ids = [aws_security_group.sql_sg.id]
  availability_zone = "ap-south-1a"
tags = {
    Name = "mysql"
  }
depends_on = [
    aws_vpc.main,aws_security_group.sql_sg,
  ]
}
