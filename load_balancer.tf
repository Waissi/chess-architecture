resource "aws_lb" "chess_server_lb" {
  name               = "chess-server-lb"
  load_balancer_type = "network"
  security_groups    = [aws_security_group.chess_server_sg.id]
  subnets            = data.aws_subnets.default_vpc_subnets.ids
}

resource "aws_lb_target_group" "chess_server_tg" {
  name        = "chess-server-tg"
  port        = 6789
  protocol    = "UDP"
  vpc_id      = aws_default_vpc.chess_server.id
  target_type = "instance"
  health_check {
    protocol            = "HTTP"
    path                = "/healthz"
    port                = "80"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 30
    matcher             = "200"
  }
}

resource "aws_lb_listener" "load_balancer_listener" {
  load_balancer_arn = aws_lb.chess_server_lb.arn
  port              = 6789
  protocol          = "UDP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.chess_server_tg.arn
  }
}
