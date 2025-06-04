resource "aws_security_group" "chess_server_sg" {
  name        = "chess_server_sg"
  description = "Allows connections to chess server"
  vpc_id      = "vpc-03d7cacbbbbe7f25c"
}

resource "aws_security_group" "chess_allocator_sg" {
  name        = "chess_allocator_sg"
  description = "Allows connections to chess allocator"
  vpc_id      = "vpc-03d7cacbbbbe7f25c"
}

resource "aws_vpc_security_group_egress_rule" "allow_server_trafic_out" {
  security_group_id = aws_security_group.chess_server_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_egress_rule" "allow_allocator_traffic_out" {
  security_group_id = aws_security_group.chess_allocator_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_ingress_rule" "allow_server_ssh" {
  security_group_id = aws_security_group.chess_server_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_server_udp" {
  security_group_id = aws_security_group.chess_server_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 6789
  ip_protocol       = "udp"
  to_port           = 6789
}

resource "aws_vpc_security_group_ingress_rule" "allow_allocator_ssh" {
  security_group_id = aws_security_group.chess_allocator_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_allocator_udp" {
  security_group_id = aws_security_group.chess_allocator_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 6790
  ip_protocol       = "udp"
  to_port           = 6790
}
