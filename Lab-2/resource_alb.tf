resource "aws_lb" "ppln_alb" {
  name               = "ppln-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.load_balancer_sg.id]
  subnets            = [aws_subnet.webserver_subnet_a.id, aws_subnet.webserver_subnet_b.id]

  #enable_deletion_protection = true

  tags = {
    Name = "PPLN ALB"
  }
}

resource "aws_lb_target_group" "webserver_tg" {
  name     = "webserver-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.ppln_vpc.id
}

resource "aws_lb_target_group" "game_tg" {
  name     = "game-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.ppln_vpc.id
}

resource "aws_lb_listener" "webserver_listener" {
  load_balancer_arn = aws_lb.ppln_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.webserver_tg.arn
  }
}

resource "aws_lb_listener_rule" "game" {
  listener_arn = aws_lb_listener.webserver_listener.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.game_tg.arn
  }

  condition {
    path_pattern {
      values = ["/game/*"]
    }
  }
}