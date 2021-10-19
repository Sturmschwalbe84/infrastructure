#===========================================================================================
# Rainbow Gravity's Inrastructure for exam
# 
# ECS CloudWatch Alarm & Auto Scaling Policy
#===========================================================================================

# AWS CloudWatch CPU utilization metric
resource "aws_cloudwatch_metric_alarm" "ECS_CPU" {
  alarm_name          = "t${local.ENV_Tag}-ECS Instances CPU utilization."
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "80"
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.Autoscaling_group.name
  }
  alarm_description = "This metric monitors ECS Instances cpu utilization."
  alarm_actions     = [aws_autoscaling_policy.ECS_CPU_Policy.arn]
}

# AWS autoscaling policy
resource "aws_autoscaling_policy" "ECS_CPU_Policy" {
  name                   = "foobar3-terraform-test"
  scaling_adjustment     = 4
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.Autoscaling_group.name
}
