resource "aws_cloudwatch_log_group" "my_logs" {
  name = "/ecs/cert-conv-backend-logs"
  retention_in_days = 7
}