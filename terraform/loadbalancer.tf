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
  load_balancer_arn = aws_lb.my_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my_target_group.arn
  }
}

output "load_balancer_dns_name" {
  description = "The DNS name of the Load Balancer"
  value       = aws_lb.my_lb.dns_name
}