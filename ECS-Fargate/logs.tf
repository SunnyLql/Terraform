# logs.tf

# Set up CloudWatch group and log stream and retain logs for 30 days
resource "aws_cloudwatch_log_group" "myapp_log_group" {
  name              = "/ecs/${var.name}-${var.env}"
  retention_in_days = 30


}

resource "aws_cloudwatch_log_stream" "myapp_log_stream" {
  name           = "${var.name}-${var.env}-log-stream"
  log_group_name = aws_cloudwatch_log_group.myapp_log_group.name
}
