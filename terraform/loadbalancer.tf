resource "aws_lb" "my_lb" {
  name               = "cert-conv-backend-lob"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow_http.id]
  subnets            = [data.aws_subnet.my_subnet.id, data.aws_subnet.my_subnet_2.id]
}

resource "aws_lb_target_group" "my_target_group" {
  name     = "cert-conv-backend-target-group"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.my_vpc.id
  target_type = "ip"
}


resource "aws_lb_listener" "my_listener" {
  certificate_arn   = var.cert_arn
  load_balancer_arn = aws_lb.my_lb.arn
  port              = "443"
  protocol          = "HTTPS"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my_target_group.arn
  }
}

resource "aws_lb_listener_certificate" "my_lb_listener_certificate" {
  certificate_arn = var.cert_arn
  listener_arn    = aws_lb_listener.my_listener.arn
}

output "load_balancer_dns_name" {
  description = "The DNS name of the Load Balancer"
  value       = aws_lb.my_lb.dns_name
}