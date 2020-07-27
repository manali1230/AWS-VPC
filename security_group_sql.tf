resource "aws_security_group" "sql_sg" {
  name        = "allow sg"
  description = "ingress and egress"
  vpc_id      = "${aws_vpc.main.id}"

  ingress {
    description = "Mysql"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
ingress {
    description = "Mysql ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "mysql sg"
  }
depends_on = [
   aws_vpc.main
  ]
}