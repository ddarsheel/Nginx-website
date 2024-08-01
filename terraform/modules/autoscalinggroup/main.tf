resource "aws_autoscaling_group" "web" {
  launch_configuration = var.launch_configuration_id
  vpc_zone_identifier  = var.subnet_ids
  min_size              = var.min_size
  max_size              = var.max_size
  desired_capacity      = var.desired_capacity

  tag {
    key                 = "Name"
    value               = "test-ec2"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "scale_up" {
  name                   = "scale_up"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  autoscaling_group_name = aws_autoscaling_group.web.name
}

resource "aws_autoscaling_policy" "scale_down" {
  name                   = "scale_down"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  autoscaling_group_name = aws_autoscaling_group.web.name
}
