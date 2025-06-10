resource "aws_default_vpc" "chess_server" {
  tags = {
    Name = "chess_server"
  }
}

data "aws_subnets" "default_vpc_subnets" {
  filter {
    name   = "vpc-id"
    values = [aws_default_vpc.chess_server.id]
  }
}
