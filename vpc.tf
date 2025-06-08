resource "aws_default_vpc" "chess_server" {
  tags = {
    Name = "chess_server"
  }
}
