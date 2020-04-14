#
# Load Balancer
#
resource "aws_lb" "demo" {
  name               = var.name
  load_balancer_type = "application"
  internal           = false
  subnets            = [for subnet in aws_subnet.public : subnet.id]
  security_groups    = [aws_security_group.allow-http.id]
}

resource "aws_lb_listener" "default" {
  load_balancer_arn = aws_lb.demo.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.demo.arn
  }
}

resource "aws_lb_target_group" "demo" {
  name        = var.name
  port        = 30080
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = aws_vpc.demo.id
}